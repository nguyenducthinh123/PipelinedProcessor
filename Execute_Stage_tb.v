module Execute_Stage_tb();
    // Định nghĩa các tín hiệu test
    reg clk;
    reg rst;
    reg RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE;
    reg [2:0] ALUControlE;
    reg [31:0] RD1_E, RD2_E, Imm_Ext_E, PCE, PCPlus4E, ResultW;
    reg [4:0] RD_E;
    reg [1:0] ForwardA_E, ForwardB_E;

    wire PCSrcE, RegWriteM, MemWriteM, ResultSrcM;
    wire [4:0] RD_M;
    wire [31:0] PCPlus4M, WriteDataM, ALU_ResultM, PCTargetE;

    // Khởi tạo DUT
    Execute_Stage DUT (
        .clk(clk),
        .rst(rst),
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
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .RD_M(RD_M),
        .PCPlus4M(PCPlus4M),
        .WriteDataM(WriteDataM),
        .ALU_ResultM(ALU_ResultM),
        .ResultW(ResultW),
        .ForwardA_E(ForwardA_E),
        .ForwardB_E(ForwardB_E)
    );

    // Tạo xung clock 100ns (chu kỳ 100ns)
    always begin
        clk = 0;
        #50;  // Delay 50ns (nửa chu kỳ)
        clk = 1;
        #50;  // Delay 50ns (nửa chu kỳ)
    end

    // Test stimulus
    initial begin
        // Khởi tạo các giá trị ban đầu
        rst = 0;
        RegWriteE = 0;
        ALUSrcE = 0;
        MemWriteE = 0;
        ResultSrcE = 0;
        BranchE = 0;
        ALUControlE = 3'b000; // Default ALU operation
        RD1_E = 0;
        RD2_E = 0;
        Imm_Ext_E = 0;
        RD_E = 0;
        PCE = 0;
        PCPlus4E = 0;
        ResultW = 0;
        ForwardA_E = 2'b00;
        ForwardB_E = 2'b00;

        // Reset
        #100;
        rst = 1;

        // Test case 1: ADD operation
        RD1_E = 32'h00000010; // Operand A
        RD2_E = 32'h00000020; // Operand B
        ALUControlE = 3'b010; // ADD operation
        #100;

        // Test case 2: SUB operation
        RD1_E = 32'h00000030; // Operand A
        RD2_E = 32'h00000010; // Operand B
        ALUControlE = 3'b110; // SUB operation
        #100;

        // Test case 3: Branch taken
        BranchE = 1;
        RD1_E = 32'h00000010; // Operand A
        RD2_E = 32'h00000010; // Operand B (equal to A)
        ALUControlE = 3'b110; // SUB operation
        Imm_Ext_E = 32'h00000008; // Branch offset
        #100;

        // Test case 4: Forwarding from MEM stage
        ForwardA_E = 2'b10; // Forward ALU_ResultM to Src_A
        ForwardB_E = 2'b10; // Forward ALU_ResultM to Src_B
        #100;

        // Test case 5: Forwarding from WB stage
        ForwardA_E = 2'b01; // Forward ResultW to Src_A
        ForwardB_E = 2'b01; // Forward ResultW to Src_B
        #100;

        // Kết thúc simulation
        $finish;
    end

    // Monitoring
    initial begin
        $monitor("Time=%0t rst=%b ALUControlE=%b RD1_E=%h RD2_E=%h Src_A=%h Src_B=%h ResultE=%h ZeroE=%b PCSrcE=%b PCTargetE=%h",
                 $time, rst, ALUControlE, RD1_E, RD2_E, DUT.Src_A, DUT.Src_B, DUT.ResultE, DUT.ZeroE, PCSrcE, PCTargetE);
    end

    // Tạo file VCD để xem wave
    initial begin
        $dumpfile("execute_stage_tb.vcd");
        $dumpvars(0, Execute_Stage_tb);
    end

endmodule