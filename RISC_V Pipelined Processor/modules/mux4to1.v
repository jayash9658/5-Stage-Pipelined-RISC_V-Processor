module mux4x1 (
  input  [63:0] a,
  input  [63:0] b,
  input  [63:0] c,
  input  [63:0] d,
  input  [1:0]  sel,
  output reg [63:0] y
);

always @(*) begin
    case(sel)
        2'b00: y = a;
        2'b01: y = b;
        2'b10: y = c;
        2'b11: y = d;
    endcase
end

endmodule