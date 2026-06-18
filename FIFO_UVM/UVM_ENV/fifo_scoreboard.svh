class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)

    uvm_analysis_imp #(fifo_seq_item, fifo_scoreboard) analysis_export;
    
    // ref model
    bit [7:0] expected_queue [$];

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_export = new("analysis_export", this);
    endfunction

    virtual function void write(fifo_seq_item t);
        
        if (t.is_write) begin
            expected_queue.push_back(t.wdata);
            `uvm_info("SB_WRITE", $sformatf("Pushed to queue: 0x%0h", t.wdata), UVM_HIGH)
        end
        
        // if reading do push 
        if (t.is_read) begin
            if (expected_queue.size() > 0) begin
                bit [7:0] exp_data = expected_queue.pop_front();
                if (t.rdata === exp_data) begin
                    `uvm_info("SB_MATCH", $sformatf("PASS! Read: 0x%0h == Expected: 0x%0h", t.rdata, exp_data), UVM_LOW)
                end else begin
                    `uvm_error("SB_MISMATCH", $sformatf("FAIL! Read: 0x%0h, Expected: 0x%0h", t.rdata, exp_data))
                end
            end else begin
                `uvm_error("SB_ERR", "Read detected but Expected Queue is EMPTY!")
            end
        end
    endfunction

    // report 
    virtual function void report_phase(uvm_phase phase);
        uvm_report_server server = uvm_report_server::get_server();
        if (server.get_severity_count(UVM_ERROR) == 0 && server.get_severity_count(UVM_FATAL) == 0) begin
            `uvm_info("RESULT", "\n\n  ⭐⭐⭐ ASYNC FIFO TEST PASSED SUCCESSFULLY ⭐⭐⭐ \n", UVM_NONE)
        end else begin
            `uvm_error("RESULT", "\n\n  ❌❌❌ ASYNC FIFO TEST FAILED ❌❌❌ \n")
        end
    endfunction
endclass