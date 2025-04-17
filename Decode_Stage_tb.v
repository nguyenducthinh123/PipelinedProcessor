module Decode_Stage_tb();
    reg clk;
    reg rst;
    reg RegWriteW;
    reg [4:0] RDW;
    reg [31:0] InstrD, PCD, PCPlus4D, ResultW;
    wire RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE;
    wire [2:0] ALUControlE;
    wire [31:0] RD1_E, RD2_E, Imm_Ext_E, PCE, PCPlus4E;
    wire [4:0] RS1_E, RS2_E, RD_E;

    // Instantiate DUT
    Decode_Stage DUT (
        .clk(clk),
        .rst(rst),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .RegWriteW(RegWriteW),
        .RDW(RDW),
        .ResultW(ResultW),
        .RegWriteE(RegWriteE),
        .ALUSrcE(ALUSrcE),
        .MemWriteE(MemWriteE),
        .ResultSrcE(ResultSrcE),
        .BranchE(BranchE),
        .ALUControlE(ALUControlE),
        .RD1_E(RD1_E),
        .RD2_E(RD2_E),
        .Imm_Ext_E(Imm_Ext_E),
        .RD_E(RD_E),
        .PCE(PCE),
        .PCPlus4E(PCPlus4E),
        .RS1_E(RS1_E),
        .RS2_E(RS2_E)
    );

    // Clock generator (100ns cycle)
    always begin
        clk = 0; #50;
        clk = 1; #50;
    end

    initial begin
        rst = 0;
        RegWriteW = 0;
        RDW = 0;
        ResultW = 0;
        InstrD = 0;
        PCD = 0;
        PCPlus4D = 0;

        #100;
        rst = 1;

        // Test sequence
        // Format: InstrD = <32-bit instruction in hex>; PCD, PCPlus4D = PC values

        // addi x1, x0, 10
        InstrD = 32'h00A00093;
        PCD = 32'h00000000;
        PCPlus4D = 32'h00000004;
        #100;

        // addi x2, x0, 20
        InstrD = 32'h01400113;
        PCD = 32'h00000004;
        PCPlus4D = 32'h00000008;
        #100;

        // add x3, x1, x2
        InstrD = 32'h002081B3;
        PCD = 32'h00000008;
        PCPlus4D = 32'h0000000C;
        #100;

        // sub x4, x3, x1
        InstrD = 32'h40118233;
        PCD = 32'h0000000C;
        PCPlus4D = 32'h00000010;
        #100;

        // sw x4, 0(x0)
        InstrD = 32'h00402023;
        PCD = 32'h00000010;
        PCPlus4D = 32'h00000014;
        #100;

        // addi x5, x0, 20
        InstrD = 32'h01400293;
        PCD = 32'h00000014;
        PCPlus4D = 32'h00000018;
        #100;

        // beq x5, x4, label1
        InstrD = 32'h00428463;
        PCD = 32'h00000018;
        PCPlus4D = 32'h0000001C;
        #100;

        // addi x6, x0, 1
        InstrD = 32'h00100313;
        PCD = 32'h0000001C;
        PCPlus4D = 32'h00000020;
        #100;

        // addi x7, x0, 7
        InstrD = 32'h00700393;
        PCD = 32'h00000020;
        PCPlus4D = 32'h00000024;
        #100;

        $finish;
    end

    // Monitor
    initial begin
        $monitor("T=%0t | InstrD=%h | RD1_E=%h | RD2_E=%h | Imm=%h | ALUCtrl=%b | RegWriteE=%b | BranchE=%b",
                 $time, InstrD, RD1_E, RD2_E, Imm_Ext_E, ALUControlE, RegWriteE, BranchE);
    end

    // Dump waveform
    initial begin
        $dumpfile("decode_stage_tb.vcd");
        $dumpvars(0, Decode_Stage_tb);
    end
endmodule
