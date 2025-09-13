import uvm_pkg ::*;
import pack1::*;
`include "uvm_macros.svh"
class my_subscriber extends uvm_subscriber#(my_sequence_item);

`uvm_component_utils(my_subscriber)

    my_sequence_item local_item;
    
    // Coverage groups
    covergroup memory_cg;
      address_cp: coverpoint local_item.Address {
        bins low = {[0:7]};
        bins mid = {[8:15]};
        bins high = {[16:31]};
      }
      data_cp: coverpoint local_item.Data_out {
        bins zero = {0};
        bins low = {[1:255]};
        bins mid = {[256:65535]};
        bins high = {[65536:4294967295]};
      }
      valid_cp: coverpoint local_item.Valid_out;
      cross_address_data: cross address_cp, data_cp;
    endgroup

    function new(string name, uvm_component parent);
      super.new(name, parent);
      memory_cg = new();
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      $display("my_subscriber build_phase");
      local_item = my_sequence_item::type_id::create("local_item");
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      $display("my_subscriber connect_phase");
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      $display("my_subscriber run_phase");
    endtask

    virtual function void write(my_sequence_item t);
      `uvm_info("SUBSCRIBER", $sformatf("Received item in subscriber: %s", t.convert2string()), UVM_MEDIUM)
      
      // Update local item for coverage
      local_item = t;
      
      // Sample coverage
      memory_cg.sample();
    endfunction
  
endclass