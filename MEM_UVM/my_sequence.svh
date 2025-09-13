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
    `uvm_info("SEQ", "Starting memory sequence...", UVM_LOW)
    
    // Write sequence
    for (int i = 0; i < 16; i++) begin
        item = my_sequence_item::type_id::create("item");
        start_item(item);
        assert(item.randomize() with {
            Wr_En == 1;
            Rd_En == 0;
            Address == i;
        });
        item.is_write = 1;
        `uvm_info("SEQ", $sformatf("Writing item: %s", item.convert2string()), UVM_MEDIUM)
        finish_item(item);
        #20; // Add delay between write operations
    end
    
    // Add delay between write and read sequences
    #100;
    
    // Read sequence
    for (int i = 0; i < 16; i++) begin
        item = my_sequence_item::type_id::create("item");
        start_item(item);
        assert(item.randomize() with {
            Wr_En == 0;
            Rd_En == 1;
            Address == i;
        });
        item.is_read = 1;
        `uvm_info("SEQ", $sformatf("Reading item: %s", item.convert2string()), UVM_MEDIUM)
        finish_item(item);
        #20; // Add delay between read operations
    end
endtask
endclass