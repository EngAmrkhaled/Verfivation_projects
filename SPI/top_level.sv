`timescale 1ns / 1ps

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "spi_intf.sv"

`include "RAM.v"
`include "SPI_Slave.v"
`include "SPI_Wrapper.v"

import pack1::*;

bind SPI_Wrapper spi_sva_assertions SVA_INST (
    .clk(clk), .rst_n(rst_n), .SS_n(SS_n), .MISO(MISO)
);

module top;

    logic clk = 0;
    logic rst_n;

    always #5 clk = ~clk;

    initial begin
        rst_n = 0;
        #20; 
        rst_n = 1;
    end

    spi_intf intf (
        .clk(clk), 
        .rst_n(rst_n)
    );

    SPI_Wrapper #(
        .MEM_DEPTH(256), 
        .ADDR_SIZE(8)
    ) dut (
        .clk(intf.clk),
        .rst_n(intf.rst_n),
        .MOSI(intf.MOSI),
        .SS_n(intf.SS_n),
        .MISO(intf.MISO)
    );

    initial begin
        uvm_config_db#(virtual spi_intf)::set(null, "*", "vif", intf);
        run_test("spi_test");
    end

endmodule