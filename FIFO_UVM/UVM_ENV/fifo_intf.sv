interface fifo_intf(input logic wclk, input logic rclk, input logic wrst_n, input logic rrst_n);
    // Write Domain
    logic winc;
    logic [7:0] wdata;
    logic wfull;
    
    // Read Domain
    logic rinc;
    logic [7:0] rdata;
    logic rempty;
endinterface

// -------------------------------------------------------------------------
// SVA: FIFO
// -------------------------------------------------------------------------

 import uvm_pkg::*;
`include "uvm_macros.svh"
module fifo_sva_assertions (
    input wire wclk, rclk, wrst_n, rrst_n,
    input wire winc, rinc, wfull, rempty
);

    property prop_no_write_on_full;
        @(posedge wclk) disable iff (!wrst_n)
        wfull |-> !winc;
    endproperty

    property prop_no_read_on_empty;
        @(posedge rclk) disable iff (!rrst_n)
        rempty |-> !rinc;
    endproperty

    AST_WRITE_FULL: assert property (prop_no_write_on_full)
        else `uvm_error("SVA", "Protocol Violation: Write attempted while FIFO is FULL!")

    AST_READ_EMPTY: assert property (prop_no_read_on_empty)
        else `uvm_error("SVA", "Protocol Violation: Read attempted while FIFO is EMPTY!")
        
endmodule