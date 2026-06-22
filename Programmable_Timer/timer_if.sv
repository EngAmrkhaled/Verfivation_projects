interface timer_if (input logic clk, input logic rst_n);
    
    
    logic [31:0] bus_addr;
    logic [31:0] bus_wdata;
    logic        bus_write;
    logic        bus_sel;
    logic [31:0] bus_rdata;
    logic        irq;

endinterface