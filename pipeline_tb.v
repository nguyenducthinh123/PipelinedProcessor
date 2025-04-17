module pipeline_tb;

    // Clock and reset signals
    reg clk = 0;
    reg rst;

    // Instantiate DUT
    Pipeline_RISCV dut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generator: 100ns cycle
    always #50 clk = ~clk;

    // Main test sequence
    initial begin
        // Apply reset
        rst = 0;
        #100;
        rst = 1;  // Release reset to start processor

        // Wait enough cycles for all instructions to propagate through pipeline
        #10000;

        // Display key register values
        $display("=== Simulation Results ===");
        $display("x1  = %0d", dut.Decode.rf.Register[1]);   // x1 = 10
        $display("x2  = %0d", dut.Decode.rf.Register[2]);   // x2 = 20
        $display("x3  = %0d", dut.Decode.rf.Register[3]);   // x3 = x1 + x2 = 30
        $display("x4  = %0d", dut.Decode.rf.Register[4]);   // x4 = x3 - x1 = 20
        $display("x5  = %0d", dut.Decode.rf.Register[5]);   // x5 = 20
        $display("x6  = %0d", dut.Decode.rf.Register[6]);   // x6 = 0 or 1 depending on beq
        $display("x7  = %0d", dut.Decode.rf.Register[7]);   // x7 = 7 (label1)

        $finish;
    end

    // Monitor PC + current instruction
    initial begin
        $monitor("Time = %0t | PC = %h | Instr = %h", 
                 $time, 
                 dut.Fetch.PCD, 
                 dut.Decode.InstrD);
    end

    // Dump VCD waveform
    initial begin
        $dumpfile("pipeline_tb.vcd");
        $dumpvars(0, pipeline_tb);
    end

endmodule
