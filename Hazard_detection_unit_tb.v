module Hazard_detection_unit_tb;

    reg MemReadE;
    reg [4:0] RD_E;
    reg [4:0] Rs1_D, Rs2_D;
    wire PCWrite, IF_ID_Write, FlushE;

    // Instantiate DUT (Device Under Test)
    Hazard_detection_unit dut (
        .MemReadE(MemReadE),
        .RD_E(RD_E),
        .Rs1_D(Rs1_D),
        .Rs2_D(Rs2_D),
        .PCWrite(PCWrite),
        .IF_ID_Write(IF_ID_Write),
        .FlushE(FlushE)
    );

    initial begin
        $dumpfile("hazard_detection_unit_tb.vcd");
        $dumpvars(0, Hazard_detection_unit_tb);

        // Test 1: Không có hazard
        MemReadE = 0;
        RD_E = 5'd2;
        Rs1_D = 5'd1;
        Rs2_D = 5'd3;
        #100;
        $display("Test 1 (no hazard): PCWrite=%b IF_ID_Write=%b FlushE=%b", PCWrite, IF_ID_Write, FlushE);

        // Test 2: Có hazard trên Rs1_D
        MemReadE = 1;
        RD_E = 5'd2;
        Rs1_D = 5'd2;  // RAW hazard
        Rs2_D = 5'd3;
        #100;
        $display("Test 2 (hazard on Rs1): PCWrite=%b IF_ID_Write=%b FlushE=%b", PCWrite, IF_ID_Write, FlushE);

        // Test 3: Có hazard trên Rs2_D
        MemReadE = 1;
        RD_E = 5'd3;
        Rs1_D = 5'd1;
        Rs2_D = 5'd3;  // RAW hazard
        #100;
        $display("Test 3 (hazard on Rs2): PCWrite=%b IF_ID_Write=%b FlushE=%b", PCWrite, IF_ID_Write, FlushE);

        // Test 4: Có MemRead nhưng không match
        MemReadE = 1;
        RD_E = 5'd4;
        Rs1_D = 5'd1;
        Rs2_D = 5'd2;
        #100;
        $display("Test 4 (no match): PCWrite=%b IF_ID_Write=%b FlushE=%b", PCWrite, IF_ID_Write, FlushE);

        // Test 5: RD_E == x0 → không hazard
        MemReadE = 1;
        RD_E = 5'd0;
        Rs1_D = 5'd0;
        Rs2_D = 5'd1;
        #100;
        $display("Test 5 (RD_E == x0): PCWrite=%b IF_ID_Write=%b FlushE=%b", PCWrite, IF_ID_Write, FlushE);

        $finish;
    end

endmodule
