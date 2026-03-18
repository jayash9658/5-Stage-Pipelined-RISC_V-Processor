module flopenrc #(parameter WIDTH = 32)(
    input clk,
    input reset,
    input en,
    input clr,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

always @(posedge clk) begin
    if (reset || clr)
        q <= 0;
    else if (en)
        q <= d;
end

endmodule