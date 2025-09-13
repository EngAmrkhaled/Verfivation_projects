import uvm_pkg ::*;
import pack1::*;
`include "uvm_macros.svh"
class my_sequencer extends uvm_sequencer #(my_sequence_item);

`uvm_component_utils(my_sequencer)

    my_sequence_item local_item;  // Add local sequence item

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      $display("my_sequencer build_phase");
      local_item = my_sequence_item::type_id::create("local_item");  // Create sequence item
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      $display("my_sequencer connect_phase");
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      $display("my_sequencer run_phase");
    endtask

endclass
