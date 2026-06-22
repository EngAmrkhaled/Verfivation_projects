`uvm_analysis_imp_decl(_bus)

class timer_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(timer_scoreboard)

    uvm_analysis_imp_bus#(timer_bus_item, timer_scoreboard) bus_export;
    
    virtual timer_if vif;
    
    timer_reg_block regmodel;

    int expected_period = 0;
    bit interrupt_enabled = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        bus_export = new("bus_export", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual timer_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("SB", "Could not get virtual interface vif!")
        end
    endfunction

    virtual function void write_bus(timer_bus_item item);
        if (item.is_write && item.addr == 32'h04) begin
            expected_period = item.data;
            `uvm_info("SB", $sformatf("Scoreboard updated expected period to: %0d", expected_period), UVM_HIGH)
        end
        
        if (item.is_write && item.addr == 32'h00) begin
            interrupt_enabled = item.data[1]; 
            `uvm_info("SB", $sformatf("Scoreboard updated Interrupt Enable to: %0b", interrupt_enabled), UVM_HIGH)
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            @(posedge vif.clk);
            if (vif.irq == 1'b1) begin
                `uvm_info("SB", "Hardware IRQ detected! Checking validity...", UVM_LOW)
                if (!interrupt_enabled) begin
                    `uvm_error("SB", "FAIL: Hardware raised IRQ but Interrupt Enable (IE) is disabled in RAL!")
                end else begin
                    `uvm_info("SB", "PASS: IRQ raised correctly while IE is enabled.", UVM_LOW)
                end
            end
        end
    endtask
endclass