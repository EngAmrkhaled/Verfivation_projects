class timer_bus_item extends uvm_sequence_item;
    rand logic [31:0] addr;
    rand logic [31:0] data;
    rand logic        is_write;

    `uvm_object_utils_begin(timer_bus_item)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(is_write, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "timer_bus_item");
        super.new(name);
    endfunction
endclass