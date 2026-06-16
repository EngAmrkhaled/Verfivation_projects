//import pack1::*;
//import uvm_pkg::*;
//`include "uvm_macros.svh"
class my_sequence_item extends uvm_sequence_item;
 
    `uvm_object_utils(my_sequence_item)

    rand bit [4:0] Address;
    rand bit [31:0] Data_in;
    rand bit Wr_En;
    rand bit Rd_En;
    bit [31:0] Data_out;
    bit Valid_out;
    bit is_write;
    bit is_read;


    constraint valid_ops {
      Wr_En != Rd_En; // Prevent simultaneous read and write
    }

    function new(string name = "my_sequence_item");
      super.new(name);
    endfunction

function string convert2string();
    if (is_write) 
        return $sformatf("WRITE: Address=0x%0h, Data=0x%0h", Address, Data_in);
    else if (is_read)
        return $sformatf("READ: Address=0x%0h, Data=0x%0h, Valid=%0b", Address, Data_out, Valid_out);
    else
        return $sformatf("OP: Address=0x%0h, Wr_En=%0b, Rd_En=%0b, Data_in=0x%0h", 
                        Address, Wr_En, Rd_En, Data_in);
endfunction

// Description : Custom field-by-field comparison method used mainly by 
    //               the scoreboard to check actual vs. expected transactions.
virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        my_sequence_item rhs_mint;
        //  Perform a dynamic cast (downcast) to ensure the target object (rhs)
        //   is compatible and of the same type (my_sequence_item).
        if (!$cast(rhs_mint, rhs)) return 0;
        return (super.do_compare(rhs, comparer) &&
                (this.Address == rhs_mint.Address) &&
                (this.Data_out == rhs_mint.Data_out));
    endfunction

endclass