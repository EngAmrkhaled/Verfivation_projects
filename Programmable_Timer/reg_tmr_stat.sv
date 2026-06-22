class reg_tmr_stat extends uvm_reg;
    `uvm_object_utils(reg_tmr_stat)
    uvm_reg_field DONE;

    function new(string name = "reg_tmr_stat");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction

    virtual function void build();
        DONE = uvm_reg_field::type_id::create("DONE");
        // volatile = 1 
        DONE.configure(this, 1, 0, "RO", 1, 1'b0, 1, 0, 0);
    endfunction
endclass