`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "my_intf.sv"
`include "MEM_16x32.sv"
import pack1::*;     

module top;
 
  my_intf intf();     
  
  // Instantiate memory module
  Memory_16x32 dut (
    .CLK(intf.CLK),
    .Rst_n(intf.Rst_n),
    .Wr_En(intf.Wr_En),
    .Rd_En(intf.Rd_En),
    .Data_in(intf.Data_in),
    .Address(intf.Address),
    .Data_out(intf.Data_out),
    .Valid_out(intf.Valid_out)
  );
  
  // Clock generation
  initial begin
    intf.CLK = 0;
    forever #5 intf.CLK = ~intf.CLK;
  end
  
  // Reset generation
  initial begin
    intf.Rst_n = 0;
    #20 intf.Rst_n = 1;
  end

  initial begin
    uvm_config_db#(virtual my_intf)::set(null, "uvm_test_top", "vif", intf);
    run_test("my_test");
  end

endmodule