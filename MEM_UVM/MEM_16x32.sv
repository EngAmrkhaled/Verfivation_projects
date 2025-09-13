
module Memory_16x32 #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 5,
    parameter DEPTH = 32
)(  input wire CLK,input wire Rst_n,
    input wire Wr_En,input wire Rd_En,
    input wire [DATA_WIDTH-1:0] Data_in,
    input wire [ADDR_WIDTH-1:0] Address,
    output reg [DATA_WIDTH-1:0] Data_out,
    output reg Valid_out);

    
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge CLK or negedge Rst_n) begin
        if (!Rst_n) begin
            // Synchronous Reset
            Data_out <= '0;
            Valid_out <= 1'b0;
            for (int i = 0; i < DEPTH; i++) begin
                mem[i] <= '0;
                                             end
                      end
        else begin
            // Write Operation
            if (Wr_En && !Rd_En) begin
                mem[Address] <= Data_in;
                Data_out <= '0;
                Valid_out <= 1'b0;
                                 end
            // Read Operation
            else if (Rd_En && !Wr_En) begin
                Data_out <= mem[Address];
                Valid_out <= 1'b1;
                                     end
            // No Operation
            else begin
                Data_out <= '0;
                Valid_out <= 1'b0;
                  end
             end
    end

    // Assertion to prevent write/read collision
    always @(posedge CLK) begin
        if (Wr_En && Rd_En) begin
            $error("Write and Read enable active simultaneously!");
        end
    end

endmodule

