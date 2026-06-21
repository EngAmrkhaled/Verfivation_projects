class ram_monitor extends uvm_monitor;
    `uvm_component_utils(ram_monitor)

    virtual ram_intf vif;
    uvm_analysis_port #(ram_item) mon_ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        mon_ap = new("mon_ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual ram_intf)::get(this, "", "ram_vif", vif))
            `uvm_fatal("RAM_MON", "Failed to get RAM VIF")
    endfunction

    task run_phase(uvm_phase phase);
        ram_item item;
        forever begin
            @(posedge vif.clk);
            if (vif.rx_valid === 1'b1) begin
                item = ram_item::type_id::create("item");
                item.din = vif.din; 
                
                `uvm_info("RAM_MON", $sformatf("Captured Internal RAM Data: 0x%0h", item.din), UVM_HIGH)
                mon_ap.write(item); // Scoreboard
            end
        end
    endtask
endclass