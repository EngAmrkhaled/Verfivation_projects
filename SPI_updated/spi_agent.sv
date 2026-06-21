class spi_agent extends uvm_agent;
    `uvm_component_utils(spi_agent)

    spi_monitor   mon;
    spi_driver    drv;
    spi_sequencer sqr;
    
    spi_config    cfg;
    uvm_analysis_port #(spi_item) agt_ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        agt_ap = new("agt_ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if(!uvm_config_db#(spi_config)::get(this, "", "spi_cfg", cfg))
            `uvm_fatal("SPI_AGT", "Failed to get SPI Config")

        mon = spi_monitor::type_id::create("mon", this);

        if (cfg.is_active == UVM_ACTIVE) begin
            drv = spi_driver::type_id::create("drv", this);
            sqr = spi_sequencer::type_id::create("sqr", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mon.mon_ap.connect(this.agt_ap);
        
        if (cfg.is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
    endfunction
endclass