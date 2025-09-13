import uvm_pkg ::*;
import pack1::*;
`include "uvm_macros.svh"
class my_scoreboard extends uvm_scoreboard;

`uvm_component_utils(my_scoreboard)

    uvm_analysis_imp #(my_sequence_item, my_scoreboard) analysis_export;
    my_sequence_item local_item;
    
    // Reference model memory
    bit [31:0] ref_mem [0:31];

    function new(string name, uvm_component parent);
      super.new(name, parent);
      analysis_export = new("analysis_export", this);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      $display("my_scoreboard build_phase");
      local_item = my_sequence_item::type_id::create("local_item");
      
      // Initialize reference memory
      foreach(ref_mem[i]) ref_mem[i] = 0;
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      $display("my_scoreboard connect_phase");
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      $display("my_scoreboard run_phase");
    endtask

virtual function void write(my_sequence_item t);
    // Update reference model for write operations
    if (t.is_write) begin
        ref_mem[t.Address] = t.Data_in;
        `uvm_info("SCOREBOARD", $sformatf("Write to Address=0x%0h, Data=0x%0h", 
                 t.Address, t.Data_in), UVM_MEDIUM)
    end
    
    // Check if read data matches reference model
    if (t.is_read) begin
        if (t.Data_out === ref_mem[t.Address]) begin
            `uvm_info("SCOREBOARD", $sformatf("PASS: Address=0x%0h, Expected=0x%0h, Got=0x%0h", 
                     t.Address, ref_mem[t.Address], t.Data_out), UVM_MEDIUM)
        end else begin
            `uvm_error("SCOREBOARD", $sformatf("FAIL: Address=0x%0h, Expected=0x%0h, Got=0x%0h", 
                     t.Address, ref_mem[t.Address], t.Data_out))
        end
    end
endfunction
  endclass