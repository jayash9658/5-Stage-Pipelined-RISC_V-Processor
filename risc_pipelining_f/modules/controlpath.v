`include "modules/Control_Unit.v"

module controlpath (

    input [6:0] opcode,
	input [2:0] funct3,
	input [6:0] funct7,
    input clk,
    input master_reset,
    //input resetF,
    input resetE,
    input resetM,
    input resetW,
    //input en_F,
    input en_E,
    input en_M,
    input en_W,
    input ZeroE,

    output PCSrcE,
    output RegWriteM,
    output RegWriteW,
    output ResultSrcE,
    output ALUSrcE,
    output [3:0] ALUControlE,
    output MemWriteM,
    output ResultSrcW

	// output reg RegWrite
	// output reg ResultSrc,
	// output reg MemWrite,
	// output reg Branch,
	// output reg [3:0] ALUControl,
	// output reg ALUSrc

);

    wire [8:0] ControlD;
    wire [8:0] ControlE; 
    wire [2:0] ControlM; 
    wire [1:0] ControlW; 

    // Control bus layout
    // [8] RegWrite
    // [7] ResultSrc
    // [6] MemWrite
    // [5] Branch
    // [4:1] ALUControl
    // [0] ALUSrc

    ////////////////////////
    
    wire RegWriteD;
    wire ResultSrcD;
    wire MemWriteD;
    wire BranchD;
    wire [3:0] ALUControlD;
    wire ALUSrcD;

    wire RegWriteE;
    //wire ResultSrcE;
    wire MemWriteE;
    wire BranchE;
    //wire [3:0] ALUControlE;
    //wire ALUSrcE;

    //wire RegWriteM;
    wire ResultSrcM;
    //wire MemWriteM;

    //wire RegWriteW;
    //wire ResultSrcW;

    ////////////////////////

    control_unit_h cud(

        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),

        .RegWrite(RegWriteD),
        .ResultSrc(ResultSrcD),
        .MemWrite(MemWriteD),
        .Branch(BranchD),
        .ALUControl(ALUControlD),
        .ALUSrc(ALUSrcD)

        // imm src is skipped
    );

    ///////////////////

    assign ControlD = {
        RegWriteD,
        ResultSrcD,
        MemWriteD,
        BranchD,
        ALUControlD,
        ALUSrcD
    };

    flopenrc #(9) ControlDE (
        .clk(clk),
        .clr(resetE),
        .en(en_E),
        .d(ControlD),
        .q(ControlE),
        .reset(master_reset)
    );

    assign {
        RegWriteE,
        ResultSrcE,
        MemWriteE,
        BranchE,
        ALUControlE,
        ALUSrcE
    } = ControlE;  

    /////////////////

    flopenrc #(3) ControlEM (
        .clk(clk),
        .clr(resetM),
        .en(en_M),
        .d(ControlE[8:6]),
        .q(ControlM),
        .reset(master_reset)
    );

    assign {
        RegWriteM,
        ResultSrcM,
        MemWriteM
    } = ControlM;    

    //////////////////////

    flopenrc #(2) ControlMW (
        .clk(clk),
        .clr(resetW),
        .en(en_W),
        .d(ControlM[2:1]),
        .q(ControlW),
        .reset(master_reset)
    );  

    assign {
        RegWriteW,
        ResultSrcW
    } = ControlW;    

    ///////////////////////

    assign PCSrcE = ZeroE & BranchE;



endmodule
