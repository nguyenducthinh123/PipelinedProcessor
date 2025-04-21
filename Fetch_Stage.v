module Fetch_Stage(
    input clk, rst,
    input PCSrcE,
    input [31:0] PCTargetE,
    input PCWrite,                  // để dừng PC khi có stall
    input IF_ID_Write,             // để dừng ghi IF/ID register khi stall
    output [31:0] InstrD,
    output [31:0] PCD, PCPlus4D
);

    // Interim wires
    wire [31:0] PCF, PC_F, PCPlus4F;
    wire [31:0] InstrF;

    // IF/ID pipeline registers
    reg [31:0] InstrF_reg;
    reg [31:0] PCF_reg, PCPlus4F_reg;

    // Mux chọn PC_F: PC + 4 hay branch target
    Mux PC_MUX (
        .a(PCPlus4F),
        .b(PCTargetE),
        .s(PCSrcE),
        .c(PC_F)
    ); // PCTargetE means PC + offset

    // PC Module (đã thêm PCWrite)
    PC_Module Program_Counter (
        .clk(clk),
        .rst(rst),
        .PCWrite(PCWrite),
        .PC(PCF),
        .PC_Next(PC_F)
    );

    // Instruction Memory
    Instruction_Memory IMEM (
        .rst(rst),
        .A(PCF),
        .RD(InstrF)
    );

    // PC Adder
    PC_Adder PC_adder (
        .a(PCF),
        .b(32'h00000004),
        .c(PCPlus4F)
    );

    // IF/ID Pipeline Register logic (ghi khi IF_ID_Write = 1)
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            InstrF_reg     <= 32'h00000000;
            PCF_reg        <= 32'h00000000;
            PCPlus4F_reg   <= 32'h00000000;
        end else if (IF_ID_Write) begin
            InstrF_reg     <= InstrF;
            PCF_reg        <= PCF;
            PCPlus4F_reg   <= PCPlus4F;
        end
    end

    // Output assign
    assign InstrD     = InstrF_reg;
    assign PCD        = PCF_reg;
    assign PCPlus4D   = PCPlus4F_reg;

endmodule
