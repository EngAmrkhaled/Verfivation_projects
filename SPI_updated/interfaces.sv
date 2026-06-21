interface spi_intf(input bit clk, input bit rst_n);
    logic MOSI;
    logic SS_n;
    logic MISO;
endinterface

interface ram_intf(input bit clk, input bit rst_n);
    logic [9:0] din;
    logic rx_valid;
    logic [7:0] dout;
    logic tx_valid;
endinterface