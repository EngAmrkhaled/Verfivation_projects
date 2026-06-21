`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"


`include "spi_config.sv"
`include "ram_config.sv"
`include "spi_item.sv"
`include "ram_item.sv"
`include "spi_sequencer.sv" 
`include "ram_sequencer.sv" 
`include "ram_driver.sv"    
`include "spi_sub_sequences.sv"
`include "wrapper_vsqr.sv"
`include "write_read_vseq.sv"
`include "spi_driver.sv"
`include "spi_monitor.sv"
`include "ram_monitor.sv"
`include "spi_agent.sv"
`include "ram_agent.sv"
`include "wrapper_scoreboard.sv"
`include "wrapper_env.sv"
`include "wrapper_test.sv"

module tb_top;
    bit clk;
    bit rst_n;

    
    always #5 clk = ~clk;

    
    initial begin
        rst_n = 0;
        #20 rst_n = 1;
    end

   
    spi_intf s_intf(clk, rst_n);
    ram_intf r_intf(clk, rst_n);

  
    SPI_Wrapper DUT (
        .clk(clk),
        .rst_n(rst_n),
        .MOSI(s_intf.MOSI),
        .SS_n(s_intf.SS_n),
        .MISO(s_intf.MISO)
    );

    // Passive Agent:
    assign r_intf.din      = DUT.rx_data_wire;
    assign r_intf.rx_valid = DUT.rx_valid_wire;
    assign r_intf.dout     = DUT.tx_data_wire;
    assign r_intf.tx_valid = DUT.tx_valid_wire;

    initial begin
        
        uvm_config_db#(virtual spi_intf)::set(null, "*", "spi_vif", s_intf);
        uvm_config_db#(virtual ram_intf)::set(null, "*", "ram_vif", r_intf);

       
        run_test("wrapper_test");
    end
endmodule