class spi_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(spi_scoreboard)

    uvm_analysis_imp #(spi_seq_item, spi_scoreboard) analysis_export;
    
    // Memory Model
    bit [7:0] ref_mem [0:255];
    bit [7:0] ref_wr_addr;
    bit [7:0] ref_rd_addr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_export = new("analysis_export", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        foreach(ref_mem[i]) ref_mem[i] = 8'h00;
        ref_wr_addr = 0;
        ref_rd_addr = 0;
    endfunction

    virtual function void write(spi_seq_item t);
        case (t.cmd)
            2'b00: begin
                ref_wr_addr = t.data;
                `uvm_info("SB", $sformatf("Saved Write Addr: 0x%0h", ref_wr_addr), UVM_HIGH)
            end
            2'b01: begin
                ref_mem[ref_wr_addr] = t.data;
                `uvm_info("SB", $sformatf("Written Data: 0x%0h @ Addr: 0x%0h", t.data, ref_wr_addr), UVM_HIGH)
            end
            2'b10: begin
                ref_rd_addr = t.data;
                `uvm_info("SB", $sformatf("Saved Read Addr: 0x%0h", ref_rd_addr), UVM_HIGH)
            end
            2'b11: begin
                if (t.miso_data === ref_mem[ref_rd_addr]) begin
                    `uvm_info("SB_MATCH", $sformatf("PASS! Addr=0x%0h, Read=0x%0h", ref_rd_addr, t.miso_data), UVM_LOW)
                end else begin
                    `uvm_error("SB_MISMATCH", $sformatf("FAIL! Addr=0x%0h, Read=0x%0h, Expected=0x%0h", ref_rd_addr, t.miso_data, ref_mem[ref_rd_addr]))
                end
            end
        endcase
    endfunction

    virtual function void report_phase(uvm_phase phase);
        uvm_report_server server = uvm_report_server::get_server();
        if (server.get_severity_count(UVM_ERROR) == 0 && server.get_severity_count(UVM_FATAL) == 0) begin
            `uvm_info("RESULT", "\n\n  ⭐⭐⭐ SPI WRAPPER TEST PASSED SUCCESSFULLY ⭐⭐⭐ \n", UVM_NONE)
        end else begin
            `uvm_error("RESULT", "\n\n  ❌❌❌ SPI WRAPPER TEST FAILED ❌❌❌ \n")
        end
    endfunction
endclass