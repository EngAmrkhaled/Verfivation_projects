
`timescale 1ns/1ps

import pack::*;

module tb_top;
    bit clk;
    always #5 clk = ~clk;
    
    memory_if intf(clk);
    Environment env;
    
    // DUT instantiation
    Memory_16x32 dut (
        .CLK(clk),
        .Rst_n(intf.Rst_n),
        .Wr_En(intf.Wr_En),
        .Rd_En(intf.Rd_En),
        .Data_in(intf.Data_in),
        .Address(intf.Address),
        .Data_out(intf.Data_out),
        .Valid_out(intf.Valid_out)
    );
    
    initial begin
        intf.Rst_n = 0;
        repeat(3) @(posedge clk);
        intf.Rst_n = 1;
        env = new(intf);
        env.run(100); // Run 100 transactions
        $finish;
    end
    
    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, tb_top);
    end
endmodule
