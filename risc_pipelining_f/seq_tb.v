`timescale 1ns / 1ps
`include "pipelined_risc.v"

module seq_tb;

    reg clk;
    reg reset;
    integer cycle_count;

    // Instantiate processor
    riscv uut (
        .clk(clk),
        .master_reset(reset)
    );

    // Clock: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Cycle counter
    initial cycle_count = 0;
    always @(posedge clk) begin
        if (reset)
            cycle_count <= 0;
        else
            cycle_count <= cycle_count + 1;
    end

    // Main test sequence
    initial begin
        $dumpfile("processor.vcd");
        $dumpvars(0, seq_tb);

        // Clear output files at start so stale data never survives a crash
        begin : clear_files
            integer f;
            f = $fopen("register_file.txt", "w"); $fclose(f);
            f = $fopen("data_mem.txt",      "w"); $fclose(f);
        end

        // Hold reset for 2 full cycles so first instruction is not lost
        reset = 1;
        @(posedge clk);
        @(posedge clk);
        #1;
        reset = 0;
        $display("[%0t] Reset deasserted. Simulation starting...", $time);

        // Safety timeout
        repeat (10000) @(posedge clk);
        $display("WARNING: Simulation timeout after %0d cycles.", cycle_count);
        $finish;
    end

    // Monitor pipeline state every cycle
    always @(negedge clk) begin
        if (!reset) begin
            $display("Cycle %0d | PC_F=%h | InstrD=%h | ALUControlE=%b | SrcAE=%h | SrcBE=%h | ALUResultE=%h",
                cycle_count,
                uut.d1.PCF,
                uut.d1.InstrD_C,
                uut.cp1.ALUControlE,
                uut.d1.SrcAE,
                uut.d1.SrcBE,
                uut.d1.ALUResultE
            );
        end
    end

    // Track cycles from reset deassert
    integer program_start_cycle;
    initial program_start_cycle = 0;
    always @(negedge clk) begin
        if (!reset && program_start_cycle == 0)
            program_start_cycle = cycle_count;
    end

    // Halt detection: InstrD = 0xFFFFFFFF is the halt marker
    // Using 0xFFFFFFFF instead of 0x00000000 avoids confusion with
    // stall bubbles and flush zeros which are all 0x00000000
    // NOPs before halt drain the pipeline naturally
    always @(negedge clk) begin
        if (!reset && cycle_count > 4) begin
            if (uut.d1.InstrD_C === 32'hFFFFFFFF) begin
                $display("============================================");
                $display("HALT detected at cycle %0d", cycle_count);
                $display("Final PC_F = %h", uut.d1.PCF);
                $display("Total program cycles: %0d", cycle_count - program_start_cycle);
                $display("============================================");
                dump_registers(cycle_count);
                save_memory_to_file();
                $finish;
            end
        end
    end

    // Dump register file to register_file.txt
    // One 64-bit value per line, no labels, cycle count at end
    task dump_registers;
        input integer final_count;
        integer fd, j;
        begin
            fd = $fopen("register_file.txt", "w");
            if (fd == 0) begin
                $display("ERROR: Could not open register_file.txt");
                disable dump_registers;
            end
            for (j = 0; j < 32; j = j + 1) begin
                if (j == 0)
                    $fwrite(fd, "%016h\n", 64'd0);
                else
                    $fwrite(fd, "%016h\n", uut.d1.rf1.registers[j]);
            end
            $fwrite(fd, "%0d\n", final_count - program_start_cycle);
            $fclose(fd);
            $display("Register file written to register_file.txt");
        end
    endtask

    // Dump data memory to data_mem.txt
    // Format matches instructions.txt: big-endian, byte-addressable, no labels
    task save_memory_to_file;
        integer file, i;
        begin
            file = $fopen("data_mem.txt", "w");
            if (file == 0) begin
                $display("ERROR: Could not open data_mem.txt");
                disable save_memory_to_file;
            end
            for (i = 0; i < 1024; i = i + 1) begin
                $fwrite(file, "%02h\n", uut.d1.dm1.mem[i]);
            end
            $fclose(file);
            $display("Data memory written to data_mem.txt");
        end
    endtask

endmodule