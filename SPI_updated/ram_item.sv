class ram_item extends uvm_sequence_item;
    bit [9:0] din; 
    `uvm_object_utils_begin(ram_item)
        `uvm_field_int(din, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "ram_item");
        super.new(name);
    endfunction
endclass