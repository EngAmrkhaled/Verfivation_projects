`timescale 1ns / 1ps

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "fifo_intf.sv"
`include "async_fifo.v" 
import pack1::*;


bind async_fifo fifo_sva_assertions SVA_INST (
    .wclk(wclk), .rclk(rclk), .wrst_n(wrst_n), .rrst_n(rrst_n),
    .winc(winc), .rinc(rinc), .wfull(wfull), .rempty(rempty)
);

module top;

    
    logic wclk = 0;
    logic rclk = 0;
    logic wrst_n;
    logic rrst_n;

  
    always #5 wclk = ~wclk;   
    always #8 rclk = ~rclk;   

    
    initial begin
        wrst_n = 0; rrst_n = 0;
        #25; 
        wrst_n = 1; rrst_n = 1;
    end

    
    fifo_intf intf (
        .wclk(wclk), 
        .rclk(rclk), 
        .wrst_n(wrst_n), 
        .rrst_n(rrst_n)
    );

    
    async_fifo #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(4)
    ) dut (
        .wclk(intf.wclk),
        .wrst_n(intf.wrst_n),
        .winc(intf.winc),
        .wdata(intf.wdata),
        .wfull(intf.wfull),
        .rclk(intf.rclk),
        .rrst_n(intf.rrst_n),
        .rinc(intf.rinc),
        .rdata(intf.rdata),
        .rempty(intf.rempty)
    );

   
    initial begin
        uvm_config_db#(virtual fifo_intf)::set(null, "*", "vif", intf);
        run_test("fifo_test");
    end

endmodule