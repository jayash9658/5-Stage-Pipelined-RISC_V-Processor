`define IMEM_SIZE 4096

module instruction_mem(
  	input reset,
  	input [63:0] addr,
  	output reg [31:0] instr
);
  
  reg [7:0] RAM[0:`IMEM_SIZE-1];
  
  initial begin
    $readmemh("instructions.txt",RAM);
  end
  
  always @(*)begin
    if(reset==1'b1)
      instr = 32'b0;
    else
      instr = {RAM[addr],RAM[addr+1],RAM[addr+2],RAM[addr+3]};
  end

endmodule
