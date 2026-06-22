module timer_top (
    input  logic        clk,
    input  logic        rst_n,
    // (Bus Interface)
    input  logic [31:0] bus_addr,
    input  logic [31:0] bus_wdata,
    input  logic        bus_write,
    input  logic        bus_sel,
    output logic [31:0] bus_rdata,
    //interrupt
    output logic        irq
);

    // inter Regs
    logic [31:0] tmr_ctrl;
    logic [31:0] tmr_prd;
    logic        tmr_stat_done;
    logic [31:0] tmr_cnt;

    // (Bus Logic)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tmr_ctrl <= 32'h0;
            tmr_prd  <= 32'h0;
        end else if (bus_sel && bus_write) begin
            case (bus_addr)
                32'h00: tmr_ctrl <= bus_wdata;  
                32'h04: tmr_prd  <= bus_wdata; 
                
            endcase
        end
    end

    // (Timer Core Logic)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tmr_cnt       <= 32'h0;
            tmr_stat_done <= 1'b0;
        end else begin
            if (tmr_ctrl[0]) begin //Enable (TMR_CTRL[0]) ـ 1
                if (tmr_cnt >= tmr_prd) begin
                    tmr_cnt       <= 32'h0;       
                    tmr_stat_done <= 1'b1;       
                end else begin
                    tmr_cnt       <= tmr_cnt + 1; 
                    tmr_stat_done <= 1'b0;
                end
            end else begin
                tmr_cnt <= 32'h0;
            end
        end
    end

   
    always_comb begin
        bus_rdata = 32'h0;
        if (bus_sel && !bus_write) begin
            case (bus_addr)
                32'h00: bus_rdata = tmr_ctrl;
                32'h04: bus_rdata = tmr_prd;
                32'h08: bus_rdata = {31'h0, tmr_stat_done};
                32'h0C: bus_rdata = tmr_cnt;
            endcase
        end
    end

   
    assign irq = tmr_ctrl[1] & tmr_stat_done;

endmodule