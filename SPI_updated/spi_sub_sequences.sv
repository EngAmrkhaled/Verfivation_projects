class spi_write_seq extends uvm_sequence#(spi_item);
    `uvm_object_utils(spi_write_seq)
    
    bit [7:0] addr;
    bit [7:0] data;

    function new(string name = "spi_write_seq"); super.new(name); endfunction

    task body();
        spi_item item1, item2;

        //send addr (Opcode = 2'b00)
        item1 = spi_item::type_id::create("item1");
        start_item(item1);
        item1.cmd  = 2'b00;
        item1.data = addr;
        finish_item(item1);

        // write data (Opcode = 2'b01)
        item2 = spi_item::type_id::create("item2");
        start_item(item2);
        item2.cmd  = 2'b01;
        item2.data = data;
        finish_item(item2);
    endtask
endclass


class spi_read_seq extends uvm_sequence#(spi_item);
    `uvm_object_utils(spi_read_seq)
    
    bit [7:0] addr;

    function new(string name = "spi_read_seq"); super.new(name); endfunction

    task body();
        spi_item item1, item2;

        // send addr (Opcode = 2'b10)
        item1 = spi_item::type_id::create("item1");
        start_item(item1);
        item1.cmd  = 2'b10;
        item1.data = addr;
        finish_item(item1);

        // read data MISO (Opcode = 2'b11)
        item2 = spi_item::type_id::create("item2");
        start_item(item2);
        item2.cmd  = 2'b11;
        item2.data = 8'h00; 
        finish_item(item2);
    endtask
endclass