module Fetch_Stage_tb();

    // Định nghĩa các tín hiệu test
    reg clk;
    reg rst;
    reg PCSrcE;
    reg [31:0] PCTargetE;
    reg PCWrite;
    reg IF_ID_Write;
    wire [31:0] InstrD;
    wire [31:0] PCD, PCPlus4D;

    // Khởi tạo DUT
    Fetch_Stage DUT (
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .PCWrite(PCWrite),
        .IF_ID_Write(IF_ID_Write),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );

    // Tạo xung clock 100ns
    always begin
        clk = 0; #50;
        clk = 1; #50;
    end

    // Test stimulus
    initial begin
        // Khởi tạo ban đầu
        rst = 0;
        PCSrcE = 0;
        PCTargetE = 32'h0;
        PCWrite = 1;
        IF_ID_Write = 1;

        // Test case 1: Reset ban đầu
        #200;
        rst = 1;

        // Test case 2: Normal sequential
        #300;

        // Test case 3: Branch taken
        PCSrcE = 1;
        PCTargetE = 32'h00000020;
        #100;

        // Ngay sau branch → Reset
        rst = 0;
        #100;
        rst = 1;

        // Test case 4: Normal sau reset
        PCSrcE = 0;
        #200;

        // Test case 5: Stall PC (PCWrite = 0)
        PCWrite = 0;
        #100;
        PCWrite = 1;

        // Test case 6: Stall IF/ID register
        IF_ID_Write = 0;
        #100;
        IF_ID_Write = 1;

        // Test case 7: Another branch
        PCSrcE = 1;
        PCTargetE = 32'h00000040;
        #100;
        PCSrcE = 0;
        #200;

        // Kết thúc mô phỏng
        #500;
        $finish;
    end

    // Monitoring
    initial begin
        $monitor("Time=%0t rst=%b PCWrite=%b IF_ID_Write=%b PCSrcE=%b PCTargetE=%h InstrD=%h PCD=%h",
                 $time, rst, PCWrite, IF_ID_Write, PCSrcE, PCTargetE, InstrD, PCD);
    end

    // Ghi file waveform
    initial begin
        $dumpfile("fetch_stage_tb.vcd");
        $dumpvars(0, Fetch_Stage_tb);
    end

endmodule
