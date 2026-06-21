 import uvm_pkg::*;
`include "uvm_macros.svh"
interface spi_intf(input logic clk, input logic rst_n);
    logic MOSI;
    logic SS_n;
    logic MISO;
endinterface

// SVA Module
module spi_sva_assertions (
    input wire clk, rst_n, SS_n, MISO
);
   

    //(SS_n = 1 MISO not work)
    property prop_miso_idle;
        @(posedge clk) disable iff (!rst_n)
        SS_n |-> (MISO == 1'b0); 
    endproperty

    AST_MISO_IDLE: assert property (prop_miso_idle)
        else `uvm_warning("SVA", "MISO changed while SS_n is HIGH (Slave not selected)!")
endmodule