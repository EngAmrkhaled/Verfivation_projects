import uvm_pkg::*;
`include "uvm_macros.svh"

interface my_intf;
  // Clock and Reset
  logic CLK;
  logic Rst_n;
  
  // Control Signals
  logic Wr_En;
  logic Rd_En;
  
  // Data Path
  logic [31:0] Data_in;
  logic [4:0] Address;
  logic [31:0] Data_out;
  logic Valid_out;
endinterface

module memory_sva_assertions (
    input wire CLK,
    input wire Rst_n,
    input wire Wr_En,
    input wire Rd_En,
    input wire [31:0] Data_in,
    input wire [4:0]  Address,
    input wire [31:0] Data_out,
    input wire        Valid_out
);
    

    
    property prop_no_simultaneous_read_write;
        @(posedge CLK) disable iff (!Rst_n)
        !(Wr_En && Rd_En);
    endproperty

    property prop_reset_state;
        @(posedge CLK) !Rst_n |=> (Data_out == '0 && Valid_out == 1'b0);
    endproperty

    property prop_read_latency;
        @(posedge CLK) disable iff (!Rst_n)
        (Rd_En && !Wr_En) |=> (Valid_out == 1'b1);
    endproperty

    property prop_valid_out_down;
        @(posedge CLK) disable iff (!Rst_n)
        (!Rd_En) |=> (Valid_out == 1'b0);
    endproperty

   
    AST_SIMULTANEOUS_RW: assert property (prop_no_simultaneous_read_write)
        else `uvm_error("SVA_PROTO_ERR", "Violation: Wr_En and Rd_En are both active!")

    AST_RESET_EFFECT: assert property (prop_reset_state)
        else `uvm_error("SVA_RESET_ERR", "Violation: Outputs failed to clear on Reset!")

    AST_READ_LATENCY: assert property (prop_read_latency)
        else `uvm_error("SVA_LATENCY_ERR", "Violation: Valid_out did not rise 1 cycle after Rd_En!")

    AST_VALID_LOW: assert property (prop_valid_out_down)
        else `uvm_error("SVA_VALID_ERR", "Violation: Valid_out is high without a read command!")

    
    COV_BURST_WRITES: cover property (@(posedge CLK) Wr_En [*3]);
    COV_BURST_READS:  cover property (@(posedge CLK) Rd_En [*3]);

endmodule