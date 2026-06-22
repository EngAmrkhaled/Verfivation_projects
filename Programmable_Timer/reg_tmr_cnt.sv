class reg_tmr_cnt extends uvm_reg;
    `uvm_object_utils(reg_tmr_cnt)
    uvm_reg_field VALUE;

    function new(string name = "reg_tmr_cnt");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction

    virtual function void build();
        VALUE = uvm_reg_field::type_id::create("VALUE");
        VALUE.configure(this, 32, 0, "RO", 1, 32'h0, 1, 0, 0);
    endfunction
endclass