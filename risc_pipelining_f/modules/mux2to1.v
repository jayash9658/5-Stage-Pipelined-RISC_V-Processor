//2x1 mux

module mux2 (
    input s,
    input i0,
    input i1,
    output y
);
    wire t0, t1, t2;

    not(t0, s);
    and(t1, i0, t0);
    and(t2, i1, s);
    or(y, t1, t2);

endmodule

module mux2_64 (
    input sel,
    input [63:0] in0,
    input [63:0] in1,
    output [63:0] out
);

assign out = sel ? in1 : in0;

endmodule