class spi_item extends uvm_sequence_item;
    rand bit [1:0] cmd;   
    rand bit [7:0] data;  
    bit MISO;             

    `uvm_object_utils_begin(spi_item)
        `uvm_field_int(cmd, UVM_DEFAULT)
        `uvm_field_int(data, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "spi_item");
        super.new(name);
    endfunction
endclass