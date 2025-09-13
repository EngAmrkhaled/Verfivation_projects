import uvm_pkg ::*;
import pack1::*;
`include "uvm_macros.svh"
class my_sequence extends uvm_sequence;
`uvm_object_utils(my_sequence)

    function new(string name = "my_sequence");
      super.new(name);
    endfunction

  
task body();
    my_sequence_item item;
    `uvm_info("SEQ", "Starting AES sequence...", UVM_LOW)
    
    for (int i = 0; i < 16; i++) begin
        item = my_sequence_item::type_id::create("item");
        start_item(item);
        assert(item.randomize());
        `uvm_info("SEQ", $sformatf("Generating AES item: %s", item.convert2string()), UVM_MEDIUM)
        finish_item(item);
        #100; // Add delay between operations
    end
endtask
endclass