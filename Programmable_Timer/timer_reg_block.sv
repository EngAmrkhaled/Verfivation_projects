class timer_reg_block extends uvm_reg_block;
    `uvm_object_utils(timer_reg_block)

    rand reg_tmr_ctrl ctrl;
    rand reg_tmr_prd  prd;
         reg_tmr_stat stat;
         reg_tmr_cnt  cnt;
    uvm_reg_map       timer_map;

    function new(string name = "timer_reg_block");
        super.new(name, UVM_NO_COVERAGE);
    endfunction

    virtual function void build();
        timer_map = create_map("timer_map", 'h0, 4, UVM_LITTLE_ENDIAN);

        ctrl = reg_tmr_ctrl::type_id::create("ctrl");
        ctrl.configure(this, null, "");
        ctrl.build();
        timer_map.add_reg(ctrl, 'h00, "RW"); // 0x00

        prd = reg_tmr_prd::type_id::create("prd");
        prd.configure(this, null, "");
        prd.build();
        timer_map.add_reg(prd, 'h04, "RW");  // 0x04

        stat = reg_tmr_stat::type_id::create("stat");
        stat.configure(this, null, "");
        stat.build();
        timer_map.add_reg(stat, 'h08, "RO"); // 0x08

        cnt = reg_tmr_cnt::type_id::create("cnt");
        cnt.configure(this, null, "");
        cnt.build();
        timer_map.add_reg(cnt, 'h0C, "RO");  // 0x0C

        lock_model();
    endfunction
endclass