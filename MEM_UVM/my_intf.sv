interface my_intf;
  // Clock and Reset
  logic CLK;
  logic Rst_n;
  
  // Control Signals
  logic Wr_En;
  logic Rd_En;
  
  // Data Path
  logic [31:0] Data_in;
  logic [4:0] Address;
  logic [31:0] Data_out;
  logic Valid_out;
endinterface