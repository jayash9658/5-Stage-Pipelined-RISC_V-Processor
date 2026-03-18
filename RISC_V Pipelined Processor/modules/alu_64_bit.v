`include "modules/ALU_Operations.v"

module alu_64_bit(
  input [63:0] a,
  input [63:0] b,
  input [3:0] opcode,
  output reg [63:0] result,
  output reg cout,
  output reg carry_flag,
  output reg overflow_flag,
  output reg zero_flag
);
  

  wire [63:0] temp_result [9:0];
  wire [9:0] temp_cout, temp_c63;
  
  wire [63:0] not_b;
  assign not_b = ~b;
  
  //ADD_Oper
  add_64b add1(a,b,1'b0,temp_result[0],temp_cout[0],temp_c63[0]);
  
  //SLL_Oper
  sll_64b sll1(a,b[5:0],temp_result[1]);
  
  //SLT_Oper
  add_64b sub2(a,not_b, 1'b1,temp_result[2], temp_cout[2], temp_c63[2]);
  
  //SLTU_Oper
  add_64b sub3(a,not_b, 1'b1,temp_result[3], temp_cout[3], temp_c63[3]);
  wire temp_cout_notu = ~temp_cout[3];
  
  //XOR_Oper
  xor_64b xor1(a,b,temp_result[4]);
  
  //SRL_Oper
  srl_64b srl1(a,b[5:0],temp_result[5]);
  
  //OR_Oper
  or_64b or1(a,b,temp_result[6]);
  
  //AND_Oper
  and_64b and1(a,b,temp_result[7]);
  
  //SUB_Oper
  add_64b sub1(a,not_b, 1'b1,temp_result[8], temp_cout[8], temp_c63[8]);
  
  //SRl_64b srl1(a,b[5:0],temp_result[5]);A_Oper
  sra_64b sra1(a,b[5:0],temp_result[9]);
  
  
  always @(*) begin
    case(opcode)
      4'b0000 : begin //ADD_Oper
        {cout,result} = {temp_cout[0], temp_result[0]};
        carry_flag = temp_cout[0];
        overflow_flag = temp_c63[0]^temp_cout[0];
        zero_flag = ~|result;
        
      end
      4'b0001 : begin //SLL_Oper
        result = temp_result[1];
        cout = 1'b0;
        carry_flag = 1'b0;
        overflow_flag = 1'b0;
        zero_flag = ~|result;

      end
      4'b0010 : begin //SLT_Oper
        result = {63'b0, temp_result[2][63] ^ (temp_c63[2] ^ temp_cout[2])};
        cout = 1'b0;
        carry_flag = 1'b0;
        overflow_flag = 1'b0;
        zero_flag = ~|result;

      end
      4'b0011 : begin //SLTU_Oper
        result = {63'b0,temp_cout_notu};
        cout = 1'b0;
        carry_flag = 1'b0;
        overflow_flag = 1'b0;
        zero_flag = ~|result;
        
      end
      4'b0100 : begin //XOR_Oper
        result = temp_result[4];
        cout= 1'b0;
        carry_flag = 1'b0;
        overflow_flag = 1'b0;
        zero_flag = ~|result;
        
      end
      4'b0101 : begin //SRL_Oper
        result = temp_result[5];
        cout = 1'b0;
        carry_flag = 1'b0;
        overflow_flag = 1'b0;
        zero_flag = ~|result;

      end
      4'b0110 : begin //OR_Oper
        result = temp_result[6];
        cout= 1'b0;
        carry_flag = 1'b0;
        overflow_flag = 1'b0;
        zero_flag = ~|result;

      end
      4'b0111 : begin //AND_Oper
        result = temp_result[7];
        cout=1'b0;
        carry_flag = 1'b0;
        overflow_flag = 1'b0;
        zero_flag = ~|result;
        
      end
      4'b1000 : begin //SUB_Oper
        {cout,result} = {temp_cout[8], temp_result[8]};
        carry_flag = ~temp_cout[8];
        overflow_flag = temp_c63[8]^temp_cout[8];
        zero_flag = ~|result;
        

      end
      4'b1101 : begin //SRA_Oper
        result = temp_result[9];
        cout = 1'b0;
        carry_flag = 1'b0;
        overflow_flag = 1'b0;
        zero_flag = ~|result;
        
      end
      default: begin
        result = 64'b0;
        cout = 1'b0;
        carry_flag = 1'b0;
        overflow_flag = 1'b0;
        zero_flag = 1'b0;
      end
    endcase
  end
  
endmodule
