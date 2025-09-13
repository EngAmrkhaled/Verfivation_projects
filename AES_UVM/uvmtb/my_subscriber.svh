import uvm_pkg ::*;
import pack1::*;
`include "uvm_macros.svh"
class my_subscriber extends uvm_subscriber#(my_sequence_item);

`uvm_component_utils(my_subscriber)

    my_sequence_item local_item;
    
    // Coverage groups for AES
    covergroup aes_cg;
      key_cp: coverpoint local_item.key {
        bins low = {[0:64'hFFFFFFFF]};
        bins mid = {[64'h100000000:64'hFFFFFFFFFFFFFFFF]};
      }
      data_in_cp: coverpoint local_item.data_in {
        bins zero = {0};
        bins low = {[1:64'hFFFFFFFF]};
        bins mid = {[64'h100000000:64'hFFFFFFFFFFFFFFFF]};
      }
      data_out_cp: coverpoint local_item.data_out {
        bins zero = {0};
        bins low = {[1:64'hFFFFFFFF]};
        bins mid = {[64'h100000000:64'hFFFFFFFFFFFFFFFF]};
      }
      done_cp: coverpoint local_item.done;
      cross_key_data: cross key_cp, data_in_cp;
    endgroup

    function new(string name, uvm_component parent);
      super.new(name, parent);
      aes_cg = new();
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
      aes_cg.sample();
    endfunction
  
endclass