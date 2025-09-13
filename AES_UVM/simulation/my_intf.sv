interface my_intf;
  // Clock and Reset
  logic CLK;
  logic Rst_n;
  
  // AES Signals
  logic [127:0] key;
  logic [127:0] data_in;
  logic [127:0] data_out;
  logic start;
  logic ready;
  logic done;
endinterface