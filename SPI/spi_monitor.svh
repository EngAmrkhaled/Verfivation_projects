class spi_monitor extends uvm_monitor;
    `uvm_component_utils(spi_monitor)

    virtual spi_intf vif;
    uvm_analysis_port #(spi_seq_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual spi_intf)::get(this, "", "vif", vif))
            `uvm_fatal("MON", "Failed to get VIF")
    endfunction

    task run_phase(uvm_phase phase);
        spi_seq_item item;
        bit [9:0] mosi_shift;
        bit [7:0] miso_shift;
        int count;

        forever begin
            @(negedge vif.SS_n); 
            count = 0;
            mosi_shift = 0;
            miso_shift = 0;

            while (1) begin
                @(posedge vif.clk);
                if (vif.SS_n) break; 
                
                //in first 10 cycles we collect from MOSI
                if (count < 10) begin
                    mosi_shift = {mosi_shift[8:0], vif.MOSI};
                end 
                // after get from mem
                else if (count >= 12 && count <= 19) begin
                    miso_shift = {miso_shift[6:0], vif.MISO};
                end
                count++;
            end
            
            item = spi_seq_item::type_id::create("item");
            item.cmd       = mosi_shift[9:8];
            item.data      = mosi_shift[7:0];
            item.miso_data = miso_shift;
            ap.write(item);
        end
    endtask
endclass