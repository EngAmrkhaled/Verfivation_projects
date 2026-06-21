class spi_monitor extends uvm_monitor;
    `uvm_component_utils(spi_monitor)

    virtual spi_intf vif;
    uvm_analysis_port #(spi_item) mon_ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        mon_ap = new("mon_ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual spi_intf)::get(this, "", "spi_vif", vif))
            `uvm_fatal("SPI_MON", "Failed to get SPI VIF")
    endfunction

    task run_phase(uvm_phase phase);
        spi_item item;
        bit [9:0] frame;

        forever begin
            @(negedge vif.SS_n); 
            frame = 0;
            
            for(int i = 9; i >= 0; i--) begin
                @(posedge vif.clk);
                frame[i] = vif.MOSI; 
            end
            
            item = spi_item::type_id::create("item");
            item.cmd  = frame[9:8];
            item.data = frame[7:0];
            
            @(posedge vif.SS_n); 
            `uvm_info("SPI_MON", $sformatf("Captured External SPI Frame: Cmd=%b, Data=0x%0h", item.cmd, item.data), UVM_HIGH)
            mon_ap.write(item);  
        end
    endtask
endclass