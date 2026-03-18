module hazard_unit (

    input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [4:0] Rs1E,
    input [4:0] Rs2E,
    input [4:0] RdE,
    input [4:0] RdM,
    input [4:0] RdW,   
    input RegWriteM,
    input RegWriteW,
    input ResultSrcE,
    input PCSrcE,

    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE,
    output reg StallF,
    output reg StallD,
    output reg FlushD,
    output reg FlushE

);

    reg lwStall;

    always @(*) begin

        
        // note: no one is supposed to be writing to x0

        // Data Forwarding
        
        if ((Rs1E == RdM) && RegWriteM && (Rs1E != 0)) 
            ForwardAE = 2'b10;
        else if ((Rs1E == RdW) && RegWriteW && (Rs1E != 0)) 
            ForwardAE = 2'b01;
        else 
            ForwardAE = 2'b00;

        if ((Rs2E == RdM) && RegWriteM && (Rs2E != 0)) 
            ForwardBE = 2'b10;
        else if ((Rs2E == RdW) && RegWriteW && (Rs2E != 0)) 
            ForwardBE = 2'b01;
        else 
            ForwardBE = 2'b00;

        // Stall for load hazard

        lwStall = ResultSrcE  && (RdE != 0) && ((Rs1D == RdE) || (Rs2D == RdE)); // ResultSrcE to say its a load instruction
        StallF = lwStall;
        StallD = lwStall;

        // Flush when a branch is taken or a load introduces a bubble
        
        FlushD = PCSrcE;
        FlushE = lwStall || PCSrcE;

    end


endmodule