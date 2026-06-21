`uvm_analysis_imp_decl(_spi)
`uvm_analysis_imp_decl(_ram)

class wrapper_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(wrapper_scoreboard)

    uvm_analysis_imp_spi #(spi_item, wrapper_scoreboard) spi_export;
    uvm_analysis_imp_ram #(ram_item, wrapper_scoreboard) ram_export;

    // (Golden Model) 
    bit [7:0] golden_mem [256];
    bit [7:0] predicted_wr_addr;
    bit [7:0] predicted_rd_addr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        spi_export = new("spi_export", this);
        ram_export = new("ram_export", this);
    endfunction

   
    function void write_spi(spi_item item);
        `uvm_info("SB_SPI", $sformatf("Observed External SPI: Cmd=%b, Data=0x%0h", item.cmd, item.data), UVM_LOW)
    endfunction

   
    function void write_ram(ram_item item);
        bit [1:0] op = item.din[9:8];
        bit [7:0] val = item.din[7:0];

        `uvm_info("SB_RAM", $sformatf("Observed Internal RAM Bus: Op=%b, Val=0x%0h", op, val), UVM_LOW)

        case(op)
            2'b00: predicted_wr_addr = val; 
            2'b01: begin                   
                golden_mem[predicted_wr_addr] = val;
                `uvm_info("SB_MATCH", $sformatf("SUCCESS: Data 0x%0h successfully written to internal Addr 0x%0h", val, predicted_wr_addr), UVM_LOW)
            end
            2'b10: predicted_rd_addr = val; 
            2'b11: begin
                `uvm_info("SB_MATCH", $sformatf("SUCCESS: Read request triggered for Addr 0x%0h (Expected output data: 0x%0h)", predicted_rd_addr, golden_mem[predicted_rd_addr]), UVM_LOW)
            end
        endcase
    endfunction
endclass