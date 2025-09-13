import uvm_pkg ::*;
import pack1::*;
`include "uvm_macros.svh"
class my_monitor extends uvm_monitor;

 `uvm_component_utils(my_monitor)

    uvm_analysis_port #(my_sequence_item) ap;
    my_sequence_item local_item;
    virtual my_intf vif;

    function new(string name, uvm_component parent);
      super.new(name, parent);
      ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      $display("my_monitor build_phase");
      
      if (!uvm_config_db#(virtual my_intf)::get(this, "", "vif", vif)) begin
        `uvm_error("MONITOR", "Failed to get virtual interface from config DB")
      end
      
      local_item = my_sequence_item::type_id::create("local_item");
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      $display("my_monitor connect_phase");
    endfunction

task run_phase(uvm_phase phase);
    my_sequence_item item;
    super.run_phase(phase);
    $display("my_monitor run_phase");
    
    forever begin
        // Wait for encryption to start
        @(posedge vif.CLK iff vif.start);
        
        item = my_sequence_item::type_id::create("item");
        item.key = vif.key;
        item.data_in = vif.data_in;
        item.start = vif.start;
        
        // Wait for encryption to complete
        wait(vif.done);
        
        @(posedge vif.CLK);
        item.data_out = vif.data_out;
        item.done = vif.done;
        item.ready = vif.ready;
        
        `uvm_info("MON", $sformatf("Monitoring AES item: %s", item.convert2string()), UVM_MEDIUM)
        ap.write(item);
    end
endtask
  endclass