class spi_driver extends uvm_driver #(spi_seq_item);
    `uvm_component_utils(spi_driver)

    virtual spi_intf vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual spi_intf)::get(this, "", "vif", vif))
            `uvm_fatal("DRV", "Failed to get VIF")
    endfunction

    task run_phase(uvm_phase phase);
        spi_seq_item item;
        bit [9:0] frame;
        
        vif.SS_n <= 1;
        vif.MOSI <= 0;
        
        wait(vif.rst_n);
        
        forever begin
            seq_item_port.get_next_item(item);
            
            @(posedge vif.clk);
            vif.SS_n <= 0; 
            
            frame = {item.cmd, item.data};
            
            // send frame
            for (int i = 9; i >= 0; i--) begin
                vif.MOSI <= frame[i];
                @(posedge vif.clk);
            end
            
            // if reading wait 10 cycles to get from mem
            if (item.cmd == 2'b11) begin
                repeat(10) @(posedge vif.clk);
            end
            
            vif.SS_n <= 1;
            vif.MOSI <= 0;
            @(posedge vif.clk); 
            
            seq_item_port.item_done();
        end
    endtask
endclass