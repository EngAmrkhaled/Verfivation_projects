// File: mem_if.sv
interface memory_if(input logic CLK);
    logic [31:0] Data_in, Data_out;
    logic [4:0] Address;
    logic Wr_En, Rd_En, Valid_out;
    logic Rst_n;
    
    clocking drv_cb @(posedge CLK);
        output Address, Wr_En, Rd_En, Data_in;
        input Data_out, Valid_out;
    endclocking
    
    clocking mon_cb @(posedge CLK);
        default input #1step output #0; 
        input Address, Wr_En, Rd_En, Data_in, Data_out, Valid_out;
    endclocking
endinterface
