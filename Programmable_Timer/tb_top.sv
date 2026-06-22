`timescale 1ns/1ps
  import uvm_pkg::*;
  import timer_uvm_pkg::*;

module tb_top;

    // (Clock & Reset)
    logic clk;
    logic rst_n;

    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

   
    initial begin
        rst_n = 0;
        #20;
        rst_n = 1; 
    end

    
    timer_if  vif (.clk(clk), .rst_n(rst_n));

    
    timer_top dut (
        .clk       (vif.clk),
        .rst_n     (vif.rst_n),
        .bus_addr  (vif.bus_addr),
        .bus_wdata (vif.bus_wdata),
        .bus_write (vif.bus_write),
        .bus_sel   (vif.bus_sel),
        .bus_rdata (vif.bus_rdata),
        .irq       (vif.irq)
    );

    
    initial begin
        $display("[TB_TOP] Pass Virtual Interface to uvm_config_db...");
        uvm_config_db#(virtual timer_if)::set(null, "*", "vif", vif);
        $display("[TB_TOP] Starting run_test()...");
        run_test("timer_test");
    end

    
    initial begin
        $dumpfile("timer_sim.vcd");
        $dumpvars(0, tb_top);
    end

endmodule