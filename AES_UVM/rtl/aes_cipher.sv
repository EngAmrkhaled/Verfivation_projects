module aes_cipher (
    input clk,
    input rst_n,
    input [127:0] key_i,
    input [127:0] data_i,
    output reg [127:0] data_o,
    input start_i,
    output reg ready_o,
    output reg done_o
);

    // Internal signals
    reg [127:0] key_reg;
    reg [127:0] data_reg;
    reg processing;
    
    // Instantiate the AES encryption module
    AES_Encrypt encrypt_module (
        .in(data_reg),
        .key(key_reg),
        .out(data_o)
    );
    
    // Control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ready_o <= 1'b1;
            done_o <= 1'b0;
            processing <= 1'b0;
            key_reg <= 128'b0;
            data_reg <= 128'b0;
        end else begin
            if (start_i && ready_o) begin
                // Latch inputs and start processing
                key_reg <= key_i;
                data_reg <= data_i;
                ready_o <= 1'b0;
                processing <= 1'b1;
            end
            
            if (processing) begin
                // Encryption complete
                done_o <= 1'b1;
                ready_o <= 1'b1;
                processing <= 1'b0;
            end else begin
                done_o <= 1'b0;
            end
        end
    end

endmodule
