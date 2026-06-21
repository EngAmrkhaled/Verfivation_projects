class ram_agent extends uvm_agent;
    `uvm_component_utils(ram_agent)

    ram_monitor   mon;
    ram_driver    drv;
    ram_sequencer sqr;
    
    ram_config    cfg;
    uvm_analysis_port #(ram_item) agt_ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        agt_ap = new("agt_ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        
        if(!uvm_config_db#(ram_config)::get(this, "", "ram_cfg", cfg))
            `uvm_fatal("RAM_AGT", "Failed to get RAM Config")

        mon = ram_monitor::type_id::create("mon", this);

        if (cfg.is_active == UVM_ACTIVE) begin
            drv = ram_driver::type_id::create("drv", this);
            sqr = ram_sequencer::type_id::create("sqr", this);
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