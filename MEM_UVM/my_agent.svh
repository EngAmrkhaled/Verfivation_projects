import uvm_pkg ::*;
import pack1::*;
`include "uvm_macros.svh"
class my_agent extends uvm_agent;
 `uvm_component_utils(my_agent)

    my_driver     drv;
    my_sequencer  sqr;
    my_monitor    mon;
    uvm_analysis_port #(my_sequence_item) ap;
    virtual my_intf vif;  // Virtual interface reference

    function new(string name, uvm_component parent);
      super.new(name, parent);
      ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      $display("my_agent build_phase");
      
      // Retrieve virtual interface from configuration database
      if (!uvm_config_db#(virtual my_intf)::get(this, "", "vif", vif)) begin
        `uvm_error("AGENT", "Failed to get virtual interface from config DB")
      end
      
      // Set virtual interface for driver and monitor
      uvm_config_db#(virtual my_intf)::set(this, "drv", "vif", vif);
      uvm_config_db#(virtual my_intf)::set(this, "mon", "vif", vif);
      
      drv = my_driver::type_id::create("drv", this);
      sqr = my_sequencer::type_id::create("sqr", this);
      mon = my_monitor::type_id::create("mon", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      $display("my_agent connect_phase");
      drv.seq_item_port.connect(sqr.seq_item_export);
      mon.ap.connect(this.ap);
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      $display("my_agent run_phase");
    endtask
  endclass
