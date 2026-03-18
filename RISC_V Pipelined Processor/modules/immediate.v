module immediate_gen (

    input [31:0] Instr,
    output reg [63:0] ImmExt

);

    wire [6:0] opcode;
    reg [1:0] ImmSrc;

    assign opcode = Instr[6:0];

    always @(*) begin

        
        // Default set - 

        ImmSrc = 2'b00;
        ImmExt = 64'b0;
        
        case (opcode) 
        
            // 7'b0110011 : ImmSrc = 2'bxx; // R type 

            7'b0000011, 7'b0010011 : ImmSrc = 2'b00; // I type load, addi

            7'b0100011 : ImmSrc = 2'b01; // S type store

            7'b1100011 : ImmSrc = 2'b10; // B type beq
 
        
        endcase

        case (ImmSrc)

            2'b00 : ImmExt = {{52{Instr[31]}}, Instr[31:20]}; // I type 12 bit sign imm

            2'b01 : ImmExt = {{52{Instr[31]}}, Instr[31:25], Instr[11:7]}; // S type 12 big sign imm

            2'b10 : ImmExt = {{52{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8],1'b0}; // B type 13 bit sign imm

            // 2'b11 : ImmExt = {{44{Instr[31]}},Instr[19:12],Instr[20],Instr[30:21],1'b0} // J type 21-bit signed imm

            // U, J type aren't implemented

        endcase


    end


endmodule
