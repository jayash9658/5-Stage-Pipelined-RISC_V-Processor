module register_file (
    input         clk,
    input         reset,
    input  [4:0]  read_reg1,
    input  [4:0]  read_reg2,
    input  [4:0]  write_reg,
    input  [63:0] write_data,
    input         reg_write_en,
    output [63:0] read_data1,
    output [63:0] read_data2
);

    reg [63:0] registers [0:31];
    integer i;

    // Asynchronous read — x0 always returns 0
    assign read_data1 = (read_reg1 == 5'd0) ? 64'd0 : registers[read_reg1];
    assign read_data2 = (read_reg2 == 5'd0) ? 64'd0 : registers[read_reg2];

    // Synchronous write with sync reset
    always @(negedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 64'd0;
        end else begin
            if (reg_write_en && write_reg != 5'd0)
                registers[write_reg] <= write_data;
        end
    end

endmodule
