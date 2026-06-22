class reg_tmr_prd extends uvm_reg;
    `uvm_object_utils(reg_tmr_prd)
    rand uvm_reg_field VAL;

    function new(string name = "reg_tmr_prd");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction

    virtual function void build();
        VAL = uvm_reg_field::type_id::create("VAL");
        VAL.configure(this, 32, 0, "RW", 0, 32'h0, 1, 1, 0);
    endfunction
endclass