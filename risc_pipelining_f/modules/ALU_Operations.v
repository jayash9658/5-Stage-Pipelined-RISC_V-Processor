`include "modules/mux2to1.v"

// ADDITION
module add_1b (
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    wire t0,t1,t2;

    xor g1 (t0, a, b);
    xor g2 (sum, t0, cin);

    and g3 (t1, a, b);
    and g4 (t2, cin, t0);
    or  g5 (cout, t1, t2);

endmodule



module add_64b (
    input [63:0] a,
    input [63:0] b,
    input cin,
    output [63:0] sum,
    output cout,
 	output c63
);

    wire [64:0] carry;

    assign carry[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : gen_adder
            add_1b fa_inst (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate
  	assign c63 = carry[63];
    assign cout = carry[64];

endmodule




//XOR 
module xor_64b(
	input [63:0] a,
    input [63:0] b,
  output [63:0] result
);
	genvar i;
  	generate
      for(i=0; i<64; i=i+1) begin : gen_adder
        xor(result[i],a[i],b[i]);
      end
    endgenerate
endmodule

// AND
module and_64b(
    input [63:0] a,
    input [63:0] b,
    output [63:0] result
);
    genvar i;
    generate
        for(i=0; i<64; i=i+1) begin : gen_and
            and(result[i], a[i], b[i]);
        end
    endgenerate
endmodule


//or
module or_64b(
    input [63:0] a,
    input [63:0] b,
    output [63:0] result
);
    genvar i;
    generate
        for(i=0; i<64; i=i+1) begin : gen_or
            or(result[i], a[i], b[i]);
        end
    endgenerate
endmodule


//shift left logical
module sll_64b (
    input [63:0] a,
  input [5:0] s,
    output [63:0] result
);
  wire [63:0] t0,t1,t2,t3,t4;
  genvar i;
  
  generate 
    for(i=0; i<64; i=i+1) begin : stage0
      if(i>=1)
        mux2 m0(s[0], a[i], a[i-1], t0[i]);
      else
        mux2 m0_z(s[0],a[i],1'b0,t0[i]);
    end
  endgenerate
  
  generate 
    for(i=0; i<64; i=i+1) begin : stage1
      if(i>=2)
        mux2 m1(s[1], t0[i], t0[i-2], t1[i]);
      else
        mux2 m1_z(s[1],t0[i],1'b0,t1[i]);
    end
  endgenerate
  
  generate 
    for(i=0; i<64; i=i+1) begin : stage2
      if(i>=4)
        mux2 m2(s[2], t1[i], t1[i-4], t2[i]);
      else
        mux2 m2_z(s[2],t1[i],1'b0,t2[i]);
    end
  endgenerate
  
  generate 
    for(i=0; i<64; i=i+1) begin : stage3
      if(i>=8)
        mux2 m3(s[3], t2[i], t2[i-8], t3[i]);
      else
        mux2 m3_z(s[3],t2[i],1'b0,t3[i]);
    end
  endgenerate
  
  generate 
    for(i=0; i<64; i=i+1) begin : stage4
      if(i>=16)
        mux2 m4(s[4], t3[i], t3[i-16], t4[i]);
      else
        mux2 m4_z(s[4],t3[i],1'b0,t4[i]);
    end
  endgenerate
  
  generate 
    for(i=0; i<64; i=i+1) begin : stage5
      if(i>=32)
        mux2 m5(s[5], t4[i], t4[i-32], result[i]);
      else
        mux2 m5_z(s[5],t4[i],1'b0,result[i]);
    end
  endgenerate

endmodule

//shift right logical
module srl_64b (
    input [63:0] a,
    input [5:0] s,
    output [63:0] result
);
    wire [63:0] t0,t1,t2,t3,t4;
    genvar i;
  
    generate 
        for(i=0; i<64; i=i+1) begin : stage0
            if(i<=62)
                mux2 m0(s[0], a[i], a[i+1], t0[i]);
            else
                mux2 m0_z(s[0], a[i], 1'b0, t0[i]);
        end
    endgenerate
  
    generate 
        for(i=0; i<64; i=i+1) begin : stage1
            if(i<=61)
                mux2 m1(s[1], t0[i], t0[i+2], t1[i]);
            else
                mux2 m1_z(s[1], t0[i], 1'b0, t1[i]);
        end
    endgenerate
  
    generate 
        for(i=0; i<64; i=i+1) begin : stage2
            if(i<=59)
                mux2 m2(s[2], t1[i], t1[i+4], t2[i]);
            else
                mux2 m2_z(s[2], t1[i], 1'b0, t2[i]);
        end
    endgenerate
  
    generate 
        for(i=0; i<64; i=i+1) begin : stage3
            if(i<=55)
                mux2 m3(s[3], t2[i], t2[i+8], t3[i]);
            else
                mux2 m3_z(s[3], t2[i], 1'b0, t3[i]);
        end
    endgenerate
  
    generate 
        for(i=0; i<64; i=i+1) begin : stage4
            if(i<=47)
                mux2 m4(s[4], t3[i], t3[i+16], t4[i]);
            else
                mux2 m4_z(s[4], t3[i], 1'b0, t4[i]);
        end
    endgenerate
  
    generate 
        for(i=0; i<64; i=i+1) begin : stage5
            if(i<=31)
                mux2 m5(s[5], t4[i], t4[i+32], result[i]);
            else
                mux2 m5_z(s[5], t4[i], 1'b0, result[i]);
        end
    endgenerate

endmodule


//shift right arithematic
module sra_64b (
    input [63:0] a,
    input [5:0] s,
    output [63:0] result
);
    wire [63:0] t0,t1,t2,t3,t4;
    wire msb = a[63];
    genvar i;
  
    generate 
        for(i=0; i<64; i=i+1) begin : stage0
            if(i<=62)
                mux2 m0(s[0], a[i], a[i+1], t0[i]);
            else
                mux2 m0_z(s[0], a[i], msb, t0[i]);
        end
    endgenerate
  
    generate 
        for(i=0; i<64; i=i+1) begin : stage1
            if(i<=61)
                mux2 m1(s[1], t0[i], t0[i+2], t1[i]);
            else
                mux2 m1_z(s[1], t0[i], msb, t1[i]);
        end
    endgenerate
  
    generate 
        for(i=0; i<64; i=i+1) begin : stage2
            if(i<=59)
                mux2 m2(s[2], t1[i], t1[i+4], t2[i]);
            else
                mux2 m2_z(s[2], t1[i], msb, t2[i]);
        end
    endgenerate
  
    generate 
        for(i=0; i<64; i=i+1) begin : stage3
            if(i<=55)
                mux2 m3(s[3], t2[i], t2[i+8], t3[i]);
            else
                mux2 m3_z(s[3], t2[i], msb, t3[i]);
        end
    endgenerate
  
    generate 
        for(i=0; i<64; i=i+1) begin : stage4
            if(i<=47)
                mux2 m4(s[4], t3[i], t3[i+16], t4[i]);
            else
                mux2 m4_z(s[4], t3[i], msb, t4[i]);
        end
    endgenerate
  
    generate 
        for(i=0; i<64; i=i+1) begin : stage5
            if(i<=31)
                mux2 m5(s[5], t4[i], t4[i+32], result[i]);
            else
                mux2 m5_z(s[5], t4[i], msb, result[i]);
        end
    endgenerate

endmodule
