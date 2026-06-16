//import uvm_pkg ::*;
//import pack1::*;
//`include "uvm_macros.svh"
class my_agent extends uvm_agent;
 `uvm_component_utils(my_agent)

    my_driver     drv;
    my_sequencer  sqr;
    my_monitor    mon;
    uvm_analysis_port #(my_sequence_item) ap;
  

    function new(string name, uvm_component parent);
      super.new(name, parent);
      ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
     mon = my_monitor::type_id::create("mon", this);
        if (get_is_active() == UVM_ACTIVE) begin
            drv = my_driver::type_id::create("drv", this);
            sqr = my_sequencer::type_id::create("sqr", this);
        end else begin
            `uvm_info("AGT_BUILD", "Agent is configured as PASSIVE. Driver/Sequencer omitted.", UVM_LOW)
        end
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      mon.ap.connect(this.ap);
      if (get_is_active() == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
    endtask
  endclass
