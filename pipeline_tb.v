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
        #50;
    end
    
    // Test sequence
    initial begin
        // Initialize with reset active
        rst = 1'b0;
        #200;
        
        // Release reset to start execution
        rst = 1'b1;
        
        // Run long enough for all instructions to execute
        // including the jump instruction (at least 20 cycles)
        #2000;
        
        // Display register values to verify jump worked correctly
        $display("Time=%0t: Simulation completed", $time);
        $display("Register x1 (ra) = %h", dut.Decode.rf.Register[1]);  // Đã sửa
        $display("Register x5 (t0) = %h", dut.Decode.rf.Register[5]);  // Đã sửa
        $display("Register x6 (t1) = %h", dut.Decode.rf.Register[6]);  // Đã sửa
        $display("Register x7 (t2) = %h", dut.Decode.rf.Register[7]);  // Đã sửa
        $display("Register x10 (a0) = %h", dut.Decode.rf.Register[10]); // Đã sửa
        
        $finish;
    end
    
    // Monitor key signals for debugging
    initial begin
        $monitor("Time=%0t, PC=%h, Instruction=%h", 
                $time, 
                dut.Fetch.PCD,    // Current PC in Fetch stage (Đã sửa)
                dut.Decode.InstrD // Current instruction in Decode stage (Đã sửa)
                );
    end
    
    // Generate VCD file for waveform viewing
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
    end

endmodule