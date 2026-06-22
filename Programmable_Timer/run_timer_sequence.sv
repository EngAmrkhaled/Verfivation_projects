class run_timer_sequence extends uvm_sequence;
    `uvm_object_utils(run_timer_sequence)
    
    timer_reg_block rmodel;

    function new(string name = "run_timer_sequence"); super.new(name); endfunction

    virtual task body();
        uvm_status_e status;
        uvm_reg_data_t rdata;

        `uvm_info("SEQ", "--- STARTING RAL TIMER CONFIG ---", UVM_LOW)
        rmodel.prd.write(status, 32'd50);
        rmodel.ctrl.write(status, 32'd3);
        #500;
        rmodel.cnt.read(status, rdata);
        `uvm_info("SEQ", $sformatf("Current Timer Count: %0d", rdata), UVM_LOW)
        rmodel.stat.read(status, rdata);
        `uvm_info("SEQ", $sformatf("Timer Done Status: %0b", rdata), UVM_LOW)
    endtask
endclass