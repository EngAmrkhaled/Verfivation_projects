import pack1::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class my_sequence_item extends uvm_sequence_item;
    rand bit [127:0] key;
    rand bit [127:0] data_in;
    bit [127:0] data_out;
    bit start;
    bit ready;
    bit done;

    `uvm_object_utils(my_sequence_item)

    function new(string name = "my_sequence_item");
      super.new(name);
    endfunction

    function string convert2string();
        return $sformatf("Key=0x%0h, Data_in=0x%0h, Data_out=0x%0h, Start=%0b, Ready=%0b, Done=%0b", 
                        key, data_in, data_out, start, ready, done);
    endfunction
endclass