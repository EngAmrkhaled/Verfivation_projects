class fifo_agent extends uvm_agent;
    `uvm_component_utils(fifo_agent)

    fifo_driver    drv;
    fifo_sequencer sqr;
    fifo_monitor   mon;
    uvm_analysis_port #(fifo_seq_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon = fifo_monitor::type_id::create("mon", this);
        
        if (get_is_active() == UVM_ACTIVE) begin
            drv = fifo_driver::type_id::create("drv", this);
            sqr = fifo_sequencer::type_id::create("sqr", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mon.ap.connect(this.ap);
        if (get_is_active() == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
    endfunction
endclass