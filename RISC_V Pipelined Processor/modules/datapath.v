`include "modules/pc.v"
`include "modules/Instruction_Mem.v"
`include "modules/register_file.v"
`include "modules/alu_64_bit.v"
`include "modules/immediate.v"
`include "modules/data_memory.v"
`include "modules/adder.v"
`include "modules/flipflop_p.v"
`include "modules/mux4to1.v"

module datapath(
  //clk rst
  input clk,
  input reset,
  	
	//control signals
	input ALUSrcE,
  input [3:0] ALUControlE,
  input ResultSrcW,
  input PCSrcE,
	input RegWriteW,
	input MemWriteM,
  
  //harzard signals
  input StallF,
  input StallD,
  input FlushD,
  input FlushE,
 	input [1:0] ForwardAE,
  input [1:0] ForwardBE,       
           
  //outputs
  output [31:0] InstrD_C,
	output ZeroE,
  output [4:0] Rs1D_out,
  output [4:0] Rs2D_out,
  output [4:0] Rs1E,      
  output [4:0] Rs2E,
  output [4:0] RdE_out,       
  output [4:0] RdM_out,           
  output [4:0] RdW_out
                  
           
);
           
  
//IF
  
  //mux
  wire [63:0] PCF_b, PCPlus4F, PCTargetE;
  mux2_64 mpc1(PCSrcE,PCPlus4F,PCTargetE,PCF_b);
  
  //PC logic
  wire [63:0] PCF;
  pc pc1(clk, reset, ~StallF, PCF_b, PCF );
  
  //Instruction Memory 
  wire [31:0] InstrF;
  instruction_mem im1(reset, PCF, InstrF);
  
  //adder
  adder a1(PCF, 64'd4, PCPlus4F);
  
  //register
  wire [31:0] InstrD;
  wire [63:0] PCD;
  flopenrc #(32) if1(clk, reset, ~StallD, FlushD, InstrF, InstrD);
  flopenrc #(64) if2(clk, reset, ~StallD, FlushD, PCF, PCD);
  
           
           
  assign InstrD_C = InstrD;         

//ID  
 
  //Register File
  wire [4:0] RdW;
  wire [63:0]ResultW, RD1D, RD2D;
  register_file rf1(clk, reset, InstrD[19:15], InstrD[24:20], RdW, ResultW, RegWriteW, RD1D, RD2D);
  
  //Immediate Generation
  wire [63:0] ImmExtD;
  immediate_gen ig1(InstrD, ImmExtD );
  
  wire [4:0] Rs1D, Rs2D, RdD;
  assign Rs1D = InstrD[19:15];
  assign Rs2D = InstrD[24:20];
  assign RdD = InstrD[11:7];
  
           
  assign Rs1D_out = Rs1D;
  assign Rs2D_out = Rs2D;

  //register
  wire [63:0] RD1E, RD2E, ImmExtE, PCE;
  wire [4:0]RdE;
  flopenrc #(64) id1(clk, reset, 1'b1, FlushE, RD1D, RD1E);
  flopenrc #(64) id2(clk, reset, 1'b1, FlushE, RD2D, RD2E);
  flopenrc #(64) id3(clk, reset, 1'b1, FlushE, PCD, PCE);
  flopenrc #(5) id4(clk, reset, 1'b1, FlushE, Rs1D, Rs1E);
  flopenrc #(5) id5(clk, reset, 1'b1, FlushE, Rs2D, Rs2E);
  flopenrc #(5) id6(clk, reset, 1'b1, FlushE, RdD, RdE);
  flopenrc #(64) id7(clk, reset, 1'b1, FlushE, ImmExtD, ImmExtE);
  
  assign RdE_out = RdE;

//EX  

  
  //mux 4x1
  wire [63:0] SrcAE;
  wire [63:0] ALUResultM;
  mux4x1 m4e1(RD1E, ResultW, ALUResultM,64'b0, ForwardAE, SrcAE);
  
  wire [63:0] WriteDataE;
  mux4x1 m4e2(RD2E,ResultW,ALUResultM,64'b0, ForwardBE, WriteDataE);
  
  //mux2x1
  wire [63:0] SrcBE;
  mux2_64 m2e1(ALUSrcE, WriteDataE, ImmExtE, SrcBE);
  
  //Adder
  adder a2(PCE, ImmExtE, PCTargetE);
  
  //ALU Block
  wire [63:0] ALUResultE;
  wire cout, carry_flag, overflow_flag, zero_flag;
  alu_64_bit alu1(SrcAE, SrcBE, ALUControlE, ALUResultE, cout, carry_flag, overflow_flag, zero_flag );
  assign ZeroE = zero_flag;
  
  
  //register
  wire [63:0] WriteDataM;
  wire [4:0] RdM;
  flopenrc #(64) ex1(clk, reset, 1'b1, 1'b0, ALUResultE, ALUResultM);
  flopenrc #(64) ex2(clk, reset, 1'b1, 1'b0, WriteDataE, WriteDataM);
  flopenrc #(5) ex3(clk, reset, 1'b1, 1'b0, RdE, RdM);
  
  assign RdM_out = RdM;

//MEM
  
  
  //Data Memory
  wire [63:0] ReadDataM;
  DataMemory dm1(clk, reset, ALUResultM, WriteDataM, MemWriteM, ReadDataM);
  
  //register
  wire [63:0] ALUResultW, ReadDataW;
  flopenrc #(64) mem1(clk, reset, 1'b1, 1'b0, ALUResultM, ALUResultW);
  flopenrc #(64) mem2(clk, reset, 1'b1, 1'b0, ReadDataM, ReadDataW);
  flopenrc #(5) mem3(clk, reset, 1'b1, 1'b0, RdM, RdW);  
  
  assign RdW_out = RdW;         
           
//WB
  mux2_64 m2wb1(ResultSrcW, ALUResultW, ReadDataW, ResultW);
  

endmodule
