// File: transaction.svh
class Transaction;
    rand bit [31:0] Data_in;
    randc bit [4:0] Address;
    rand bit Wr_En, Rd_En;
    bit [31:0] Data_out;
    bit Valid_out;
    
    constraint wr_rd { Wr_En != Rd_En; };
endclass
