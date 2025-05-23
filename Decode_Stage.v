module Decode_Stage(
    clk, rst, Flush,
    InstrD, PCD, PCPlus4D,
    RegWriteW, RDW, ResultW,
    RegWriteE, ALUSrcE, MemWriteE, MemReadE, ResultSrcE,
    BranchE, ALUControlE,
    RD1_E, RD2_E, Imm_Ext_E,
    RD_E, RS1_E, RS2_E,
    PCE, PCPlus4E
);

    // I/O Declaration
    input clk, rst, Flush, RegWriteW;
    input [31:0] InstrD, PCD, PCPlus4D;
    input [4:0] RDW;
    input [31:0] ResultW;

    output RegWriteE, ALUSrcE, MemWriteE, MemReadE, ResultSrcE, BranchE;
    output [2:0] ALUControlE;
    output [31:0] RD1_E, RD2_E, Imm_Ext_E;
    output [4:0] RD_E, RS1_E, RS2_E;
    output [31:0] PCE, PCPlus4E;

    // Internal Wires
    wire RegWriteD, ALUSrcD, MemWriteD, MemReadD, ResultSrcD, BranchD;
    wire [1:0] ImmSrcD;
    wire [2:0] ALUControlD;
    wire [31:0] RD1_D, RD2_D, Imm_Ext_D;

    // Pipeline Registers
    reg RegWriteD_r, ALUSrcD_r, MemWriteD_r, MemReadD_r, ResultSrcD_r, BranchD_r;
    reg [2:0] ALUControlD_r;
    reg [31:0] RD1_D_r, RD2_D_r, Imm_Ext_D_r;
    reg [4:0] RD_D_r, RS1_D_r, RS2_D_r;
    reg [31:0] PCD_r, PCPlus4D_r;

    // Control Unit
    Control_Unit_Top control (
        .Op(InstrD[6:0]),
        .RegWrite(RegWriteD),
        .ImmSrc(ImmSrcD),
        .ALUSrc(ALUSrcD),
        .MemWrite(MemWriteD),
        .MemRead(MemReadD),
        .ResultSrc(ResultSrcD),
        .Branch(BranchD),
        .funct3(InstrD[14:12]),
        .funct7(InstrD[31:25]),
        .ALUControl(ALUControlD)
    );

    // Register File
    Register_File rf (
        .clk(clk),
        .rst(rst),
        .WE3(RegWriteW),
        .WD3(ResultW),
        .A1(InstrD[19:15]),
        .A2(InstrD[24:20]),
        .A3(RDW),
        .RD1(RD1_D),
        .RD2(RD2_D)
    );

    // Immediate Extend
    Sign_Extend extension (
        .In(InstrD),
        .Imm_Ext(Imm_Ext_D),
        .ImmSrc(ImmSrcD)
    );

    // ID/EX Register Logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            RegWriteD_r    <= 1'b0;
            ALUSrcD_r      <= 1'b0;
            MemWriteD_r    <= 1'b0;
            MemReadD_r     <= 1'b0;
            ResultSrcD_r   <= 1'b0;
            BranchD_r      <= 1'b0;
            ALUControlD_r  <= 3'b000;
            RD1_D_r        <= 32'h00000000;
            RD2_D_r        <= 32'h00000000;
            Imm_Ext_D_r    <= 32'h00000000;
            RD_D_r         <= 5'b00000;
            RS1_D_r        <= 5'b00000;
            RS2_D_r        <= 5'b00000;
            PCD_r          <= 32'h00000000;
            PCPlus4D_r     <= 32'h00000000;
        end else if (Flush) begin
            RegWriteD_r    <= 1'b0;
            ALUSrcD_r      <= 1'b0;
            MemWriteD_r    <= 1'b0;
            MemReadD_r     <= 1'b0;
            ResultSrcD_r   <= 1'b0;
            BranchD_r      <= 1'b0;
            ALUControlD_r  <= 3'b000;
            // dữ liệu giữ nguyên
        end else begin
            RegWriteD_r    <= RegWriteD;
            ALUSrcD_r      <= ALUSrcD;
            MemWriteD_r    <= MemWriteD;
            MemReadD_r     <= MemReadD;
            ResultSrcD_r   <= ResultSrcD;
            BranchD_r      <= BranchD;
            ALUControlD_r  <= ALUControlD;

            RD1_D_r        <= RD1_D;
            RD2_D_r        <= RD2_D;
            Imm_Ext_D_r    <= Imm_Ext_D;
            RD_D_r         <= InstrD[11:7];
            RS1_D_r        <= InstrD[19:15];
            RS2_D_r        <= InstrD[24:20];
            PCD_r          <= PCD;
            PCPlus4D_r     <= PCPlus4D;
        end
    end

    // Output Assignments
    assign RegWriteE   = RegWriteD_r;
    assign ALUSrcE     = ALUSrcD_r;
    assign MemWriteE   = MemWriteD_r;
    assign MemReadE    = MemReadD_r;
    assign ResultSrcE  = ResultSrcD_r;
    assign BranchE     = BranchD_r;
    assign ALUControlE = ALUControlD_r;

    assign RD1_E       = RD1_D_r;
    assign RD2_E       = RD2_D_r;
    assign Imm_Ext_E   = Imm_Ext_D_r;
    assign RD_E        = RD_D_r;
    assign RS1_E       = RS1_D_r;
    assign RS2_E       = RS2_D_r;
    assign PCE         = PCD_r;
    assign PCPlus4E    = PCPlus4D_r;

endmodule
