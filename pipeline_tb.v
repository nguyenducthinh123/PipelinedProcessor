module tb();

    // Clock and reset signals
    reg clk = 0;
    reg rst;
    
    // Instantiate the complete RISC-V pipeline processor
    Pipeline_RISCV dut (
        .clk(clk),
        .rst(rst)
    );
    
    // Clock generator
    always begin
        clk = ~clk;
        #50;  // Clock period = 100ns
    end
    
    // Test sequence
    initial begin
        // Initialize with reset active
        rst = 1'b0;
        #200;
        
        // Release reset to start execution
        rst = 1'b1;
        
        // Run long enough for all instructions to execute
        #2000;
        
        // Display register values to verify execution
        $display("Time=%0t: Simulation completed", $time);
        $display("Register x5 (t0) = %h", dut.Decode.rf.Register[5]);  // x5 = 5
        $display("Register x6 (t1) = %h", dut.Decode.rf.Register[6]);  // x6 = 3
        $display("Register x7 (t2) = %h", dut.Decode.rf.Register[7]);  // x7 = x5 + x6 = 8
        $display("Register x8 = %h", dut.Decode.rf.Register[8]);       // x8 = value loaded from memory
        $display("Register x9 = %h", dut.Decode.rf.Register[9]);       // x9 = 1
        $display("Register x10 (a0) = %h", dut.Decode.rf.Register[10]); // x10 = x8 + x9
        
        $finish;
    end
    
    // Monitor key signals for debugging
    initial begin
        $monitor("Time=%0t, PC=%h, Instruction=%h", 
                $time, 
                dut.Fetch.PCD,    // Current PC in Fetch stage
                dut.Decode.InstrD // Current instruction in Decode stage
                );
    end
    
    // Generate VCD file for waveform viewing
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
    end

endmodule