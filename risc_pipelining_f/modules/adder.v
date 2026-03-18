// 64-bit Adder (combinational)
// Used for PC+4 and Branch Target calculation

module adder (
    input  [63:0] in1,
    input  [63:0] in2,
    output [63:0] result
);

    assign result = in1 + in2;

endmodule
