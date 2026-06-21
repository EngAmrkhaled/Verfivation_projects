class spi_seq_item extends uvm_sequence_item;
    `uvm_object_utils(spi_seq_item)

    // INs (MOSI)
    rand bit [1:0] cmd;   // 00: Wr_Addr, 01: Wr_Data, 10: Rd_Addr, 11: Rd_Data
    rand bit [7:0] data;  // Address أو Data

    //(MISO)
    bit [7:0] miso_data;

    function new(string name = "spi_seq_item");
        super.new(name);
    endfunction

    virtual function string convert2string();
        string cmd_str;
        case(cmd)
            2'b00: cmd_str = "WRITE_ADDR";
            2'b01: cmd_str = "WRITE_DATA";
            2'b10: cmd_str = "READ_ADDR ";
            2'b11: cmd_str = "READ_DATA ";
        endcase
        return $sformatf("CMD: %s, DATA/ADDR: 0x%0h, MISO_OUT: 0x%0h", cmd_str, data, miso_data);
    endfunction
endclass