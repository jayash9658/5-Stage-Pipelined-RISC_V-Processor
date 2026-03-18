module control_unit(
  input [6:0] opcode,
  output reg Branch,
  output reg MemRead,
  output reg MemtoReg,
  output reg [1:0] ALUOp,
  output reg MemWrite,
  output reg ALUSrc,
  output reg RegWrite
);
  always @(*) begin
    case(opcode)
    	7'b0110011 : begin
        	ALUSrc = 1'b0;
          	MemtoReg = 1'b0;
          	RegWrite = 1'b1;
          	MemRead = 1'b0;
          	MemWrite = 1'b0;
          	Branch = 1'b0;
          	ALUOp = 2'b10;
        end
      	7'b0000011 : begin
        	ALUSrc = 1'b1;
          	MemtoReg = 1'b1;
          	RegWrite = 1'b1;
          	MemRead = 1'b1;
          	MemWrite = 1'b0;
          	Branch = 1'b0;
          	ALUOp = 2'b00;
        end
      	7'b0100011 : begin
        	ALUSrc = 1'b1;
          	MemtoReg = 1'bx;
          	RegWrite = 1'b0;
          	MemRead = 1'b0;
          	MemWrite = 1'b1;
          	Branch = 1'b0;
          	ALUOp = 2'b00;
        end
      	7'b1100011 : begin
        	ALUSrc = 1'b0;
          	MemtoReg = 1'bx;
          	RegWrite = 1'b0;
          	MemRead = 1'b0;
          	MemWrite = 1'b0;
          	Branch = 1'b1;
          	ALUOp = 2'b01;
        end
      	7'b0010011 : begin
        	ALUSrc = 1'b1;
          	MemtoReg = 1'b0;
          	RegWrite = 1'b1;
          	MemRead = 1'b0;
          	MemWrite = 1'b0;
          	Branch = 1'b0;
          	ALUOp = 2'b00;
        end
        default: begin
          	ALUSrc = 1'b0;
          	MemtoReg = 1'b0;
          	RegWrite = 1'b0;
          	MemRead = 1'b0;
          	MemWrite = 1'b0;
          	Branch = 1'b0;
          	ALUOp = 2'b00;
        end
    endcase
  end
  
  
  
endmodule

module alu_control(
  input [1:0] ALUOp,
  input [2:0] funct3,
  input [6:0] funct7,
  output reg [3:0] ALUControl
);
  
  always @(*)begin
    case(ALUOp)
      2'b00 : ALUControl = 4'b0000;
      2'b01 : ALUControl = 4'b1000;
      2'b10 : begin
        case(funct3)
          3'b111 : ALUControl = 4'b0111;
          3'b110 : ALUControl = 4'b0110;
          3'b000 : begin
            case(funct7)
              7'b0000000 : ALUControl = 4'b0000;
              7'b0100000 : ALUControl = 4'b1000;
              default : ALUControl = 4'b0000;
            endcase
          end
          default : ALUControl = 4'b0000;
        endcase
      end
      default : ALUControl = 4'b0000;
    endcase
  end
  
endmodule



module control_unit_h(

	input [6:0] opcode,
	input [2:0] funct3,
	input [6:0] funct7,

	output RegWrite,
	output ResultSrc,
	output MemWrite,
	output Branch,
	output [3:0] ALUControl,
	output ALUSrc

	// imm src is skipped

);
	wire [1:0] ALUOp;

	control_unit cu1 (
		.opcode(opcode),
		.Branch(Branch),
		.MemRead(),
		.MemtoReg(ResultSrc),
		.ALUOp(ALUOp),
		.MemWrite(MemWrite),
		.ALUSrc(ALUSrc),
		.RegWrite(RegWrite)
	);

	alu_control cu2(
		.ALUOp(ALUOp),
		.funct3(funct3),
		.funct7(funct7),
		.ALUControl(ALUControl)
	);

endmodule