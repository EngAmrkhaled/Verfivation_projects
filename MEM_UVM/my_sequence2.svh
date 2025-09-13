/*import uvm_pkg ::*;
import pack1::*;
`include "uvm_macros.svh"
class my_sequence2 extends uvm_sequence;
`uvm_object_utils(my_sequence2)

    function new(string name = "my_sequence2");
      super.new(name);
    endfunction

    task body();
      my_sequence_item item;
      `uvm_info("SEQ2", "Starting sequence 2...", UVM_LOW)
      
      for (int i = 0; i < 4; i++) begin
        item = my_sequence_item::type_id::create("item");
        start_item(item);
        assert(item.randomize());
        `uvm_info("SEQ2", $sformatf("Sending item %0d: %s", i, item.convert2string()), UVM_MEDIUM)
        finish_item(item);
      end
    endtask
endclass*/
