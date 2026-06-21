class spi_agent extends uvm_agent;
    `uvm_component_utils(spi_agent)

    spi_driver    drv;
    spi_sequencer sqr;
    spi_monitor   mon;
    uvm_analysis_port #(spi_seq_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon = spi_monitor::type_id::create("mon", this);
        if (get_is_active() == UVM_ACTIVE) begin
            drv = spi_driver::type_id::create("drv", this);
            sqr = spi_sequencer::type_id::create("sqr", this);
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