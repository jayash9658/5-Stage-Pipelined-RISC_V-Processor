// Program Counter Module
// Synchronous update on posedge clk, asynchronous reset to 0

module pc (
    input clk,
    input reset,
    input enable,
    input [63:0] pc_in,
    output reg [63:0] pc_out
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_out <= 64'd0;
        else if (enable)
            pc_out <= pc_in;
    end

endmodule
