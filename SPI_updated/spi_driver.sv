class spi_driver extends uvm_driver #(spi_item);
    `uvm_component_utils(spi_driver)

    virtual spi_intf vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual spi_intf)::get(this, "", "spi_vif", vif))
            `uvm_fatal("SPI_DRV", "Failed to get SPI VIF")
    endfunction

    task run_phase(uvm_phase phase);
        spi_item item;
        bit [9:0] frame;
        
        vif.SS_n <= 1;
        vif.MOSI <= 0;
        
        forever begin
            seq_item_port.get_next_item(item); 
            
            @(posedge vif.clk);
            vif.SS_n <= 0; 
            
            frame = {item.cmd, item.data}; 
            
       
            for (int i = 9; i >= 0; i--) begin
                vif.MOSI <= frame[i];
                @(posedge vif.clk);
            end
            
            vif.SS_n <= 1; 
            @(posedge vif.clk);
            
            seq_item_port.item_done();
        end
    endtask
endclass