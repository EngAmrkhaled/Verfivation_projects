`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "my_intf.sv"
import pack1::*;     

module top;
 
  my_intf intf();     
  
  // Instantiate AES cipher module
  aes_cipher dut (
    .clk(intf.CLK),
    .rst_n(intf.Rst_n),
    .key_i(intf.key),
    .data_i(intf.data_in),
    .data_o(intf.data_out),
    .start_i(intf.start),
    .ready_o(intf.ready),
    .done_o(intf.done)
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