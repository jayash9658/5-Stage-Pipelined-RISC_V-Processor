module DataMemory (

    input clk,
    input reset,
  	input [63:0] address,
    input [63:0] write_data,
    input MemWrite,
    
    output reg [63:0] read_data

);

    integer i;

    // memory array 
   
  reg [7:0] mem [0:1023];  // reg [element_width-1:0] array_name [index_range];

    initial begin

        $readmemh("data_mem.txt", mem);

    end

    // synchronous reset

  	always @(posedge clk or posedge reset) begin

        if (reset) begin

          for (i = 0; i < 1024; i = i + 1) begin

                mem[i] <= 8'b0;

            end

        end

        else if (MemWrite) begin

            mem[address]     <= write_data[63:56];
            mem[address + 1] <= write_data[55:48];
            mem[address + 2] <= write_data[47:40];
            mem[address + 3] <= write_data[39:32];
            mem[address + 4] <= write_data[31:24];
            mem[address + 5] <= write_data[23:16];
            mem[address + 6] <= write_data[15:8];
            mem[address + 7] <= write_data[7:0];

        end

    end

    // asynchronous read

    always @(*) begin
        
        read_data[63:56] = mem[address];
        read_data[55:48] = mem[address + 1];
        read_data[47:40] = mem[address + 2];
        read_data[39:32] = mem[address + 3];
        read_data[31:24] = mem[address + 4];
        read_data[23:16] = mem[address + 5];
        read_data[15:8]  = mem[address + 6];
        read_data[7:0]   = mem[address + 7];
      
    end

endmodule
