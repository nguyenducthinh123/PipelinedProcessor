module Decode_Stage_tb();

    // Clock & reset
    reg clk;
    reg rst;

    // Inputs to Decode_Stage
    reg RegWriteW;
    reg [4:0] RDW;
    reg [31:0] InstrD, PCD, PCPlus4D, ResultW;

    // Internal connections
    wire RegWriteE, ALUSrcE, MemWriteE, MemReadE, ResultSrcE, BranchE;
    wire [2:0] ALUControlE;
    wire [31:0] RD1_E, RD2_E, Imm_Ext_E, PCE, PCPlus4E;
    wire [4:0] RS1_E, RS2_E, RD_E;

    // Output from Hazard Unit
    wire Flush;

    // Hazard detection input (from Decode stage)
    wire [4:0] RS1_D = InstrD[19:15];
    wire [4:0] RS2_D = InstrD[24:20];

    // Clock 100ns
    always begin
        clk = 0; #50;
        clk = 1; #50;
    end

    // Instantiate DUT
    Decode_Stage decode (
        .clk(clk),
        .rst(rst),
        .Flush(Flush),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .RegWriteW(RegWriteW),
        .RDW(RDW),
        .ResultW(ResultW),
        .RegWriteE(RegWriteE),
        .ALUSrcE(ALUSrcE),
        .MemWriteE(MemWriteE),
        .MemReadE(MemReadE),
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

    // Instantiate Hazard Detection Unit
    Hazard_detection_unit hazard (
        .MemReadE(MemReadE),
        .RD_E(RD_E),
        .Rs1_D(RS1_D),
        .Rs2_D(RS2_D),
        .PCWrite(),       // Không dùng trong pha Decode test
        .IF_ID_Write(),   // Không dùng trong pha Decode test
        .FlushE(Flush)    // Tín hiệu đưa vào Decode_Stage
    );

    // Stimulus
    initial begin
        // Init
        rst = 0;
        RegWriteW = 0;
        RDW = 5'd0;
        ResultW = 32'h00000000;
        InstrD = 32'h00000000;
        PCD = 32'h00000000;
        PCPlus4D = 32'h00000004;

        #100;
        rst = 1;

        // addi x1, x0, 10
        InstrD = 32'h00A00093; PCD = 32'h00; PCPlus4D = 32'h04; #100;

        // addi x2, x0, 20
        InstrD = 32'h01400113; PCD = 32'h04; PCPlus4D = 32'h08; #100;

        // add x3, x1, x2
        InstrD = 32'h002081B3; PCD = 32'h08; PCPlus4D = 32'h0C; #100;

        // sub x4, x3, x1
        InstrD = 32'h40118233; PCD = 32'h0C; PCPlus4D = 32'h10; #100;

        // sw x4, 0(x0)
        InstrD = 32'h00402023; PCD = 32'h10; PCPlus4D = 32'h14; #100;

        // lw x2, 0(x0)
        InstrD = 32'h00002103; PCD = 32'h14; PCPlus4D = 32'h18; #100;

        // add x3, x2, x1 → RAW hazard with lw x2
        InstrD = 32'h001101B3; PCD = 32'h18; PCPlus4D = 32'h1C; #100;

        // addi x6, x0, 1
        InstrD = 32'h00100313; PCD = 32'h1C; PCPlus4D = 32'h20; #100;

        // addi x7, x0, 7
        InstrD = 32'h00700393; PCD = 32'h20; PCPlus4D = 32'h24; #100;

        $finish;
    end

    // Monitor
    initial begin
        $monitor("T=%0t | Instr=%h | Flush=%b | RD_E=%d | Rs1_D=%d Rs2_D=%d | MemReadE=%b | RegWrite=%b",
                 $time, InstrD, Flush, RD_E, RS1_D, RS2_D, MemReadE, RegWriteE);
    end

    // Dump waveform
    initial begin
        $dumpfile("decode_stage_tb.vcd");
        $dumpvars(0, Decode_Stage_tb);
    end

endmodule