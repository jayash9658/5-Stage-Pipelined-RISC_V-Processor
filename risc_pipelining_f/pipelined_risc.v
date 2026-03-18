`include "modules/controlpath.v"
`include "modules/datapath.v"
`include "modules/hazard.v"

module riscv (
    input clk,
    input master_reset
);
    wire [31:0] InstrD;
    wire FlushE, ZeroE, PCSrcE, RegWriteM, RegWriteW;
    wire ALUSrcE, MemWriteM, ResultSrcW;
    wire [3:0]ALUControlE;
    wire [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW;
    wire ResultSrcE;
    wire [1:0] ForwardAE;
    wire [1:0] ForwardBE;
    wire StallF, StallD, FlushD;
    

    controlpath cp1 (
        .clk(clk),
        .master_reset(master_reset),
        .opcode(InstrD[6:0]),
        .funct3(InstrD[14:12]),
        .funct7(InstrD[31:25]),
        .resetE(FlushE),
        .resetM(1'b0),
        .resetW(1'b0),
        .en_E(1'b1),
        .en_W(1'b1),
        .en_M(1'b1),
        .ZeroE(ZeroE),
        .PCSrcE(PCSrcE),
        // hazards need these - 
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .ResultSrcE(ResultSrcE),
        // data path needs these
        .ALUSrcE(ALUSrcE),
        .ALUControlE(ALUControlE),
        .MemWriteM(MemWriteM),
        .ResultSrcW(ResultSrcW)
                
    );

    hazard_unit h1 (
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdE(RdE),
        .RdM(RdM),
        .RdW(RdW),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .ResultSrcE(ResultSrcE),
        .PCSrcE(PCSrcE),
        //outs - 
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .StallF(StallF),
        .StallD(StallD),
        .FlushD(FlushD),
        .FlushE(FlushE)
    );

    datapath d1 (
        .clk(clk),
        .reset(master_reset),
        .ALUSrcE(ALUSrcE),
        .ALUControlE(ALUControlE),
        .ResultSrcW(ResultSrcW),
        .PCSrcE(PCSrcE),
        .RegWriteW(RegWriteW),
        .MemWriteM(MemWriteM),
        .StallF(StallF),
        .StallD(StallD),
        .FlushD(FlushD),
        .FlushE(FlushE),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        //out - 
        .InstrD_C(InstrD),
        .ZeroE(ZeroE),
        .Rs1D_out(Rs1D),
        .Rs2D_out(Rs2D),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdE_out(RdE),
        .RdM_out(RdM),
        .RdW_out(RdW)
    );

endmodule
