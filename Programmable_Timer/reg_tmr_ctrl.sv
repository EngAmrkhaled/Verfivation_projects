class reg_tmr_ctrl extends uvm_reg;
    `uvm_object_utils(reg_tmr_ctrl)
    rand uvm_reg_field EN;
    rand uvm_reg_field IE;

    function new(string name = "reg_tmr_ctrl");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction

    virtual function void build();
        EN = uvm_reg_field::type_id::create("EN");
        IE = uvm_reg_field::type_id::create("IE");
        
        EN.configure(this, 1, 0, "RW", 0, 1'b0, 1, 1, 0);
        IE.configure(this, 1, 1, "RW", 0, 1'b0, 1, 1, 0);
    endfunction
endclass