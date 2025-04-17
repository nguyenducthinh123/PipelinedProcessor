module Writeback_Stage_tb();
    // Định nghĩa các tín hiệu test
    reg clk;
    reg rst;
    reg [1:0] ResultSrcW;
    reg [31:0] PCPlus4W, ALU_ResultW, ReadDataW;

    wire [31:0] ResultW;

    // Khởi tạo DUT (Device Under Test)
    Writeback_Stage DUT (
        .clk(clk),
        .rst(rst),
        .ResultSrcW(ResultSrcW),
        .PCPlus4W(PCPlus4W),
        .ALU_ResultW(ALU_ResultW),
        .ReadDataW(ReadDataW),
        .ResultW(ResultW)
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
        ResultSrcW = 2'b00;
        PCPlus4W = 0;
        ALU_ResultW = 0;
        ReadDataW = 0;

        // Reset
        #100;
        rst = 1;

        // Test case 1: Write ALU result to register
        ResultSrcW = 2'b00; // Chọn ALU_ResultW
        ALU_ResultW = 32'h12345678; // Giá trị ALU
        #100;

        // Test case 2: Write memory data to register
        ResultSrcW = 2'b01; // Chọn ReadDataW
        ReadDataW = 32'hDEADBEEF; // Giá trị đọc từ bộ nhớ
        #100;

        // Test case 3: Write PC+4 to register (for JAL instruction)
        ResultSrcW = 2'b10; // Chọn PCPlus4W
        PCPlus4W = 32'h00000010; // Giá trị PC+4
        #100;

        // Test case 4: Reset during execution
        rst = 0;
        #100;
        rst = 1;
        #100;

        // Kết thúc simulation
        $finish;
    end

    // Monitoring
    initial begin
        $monitor("Time=%0t rst=%b ResultSrcW=%b PCPlus4W=%h ALU_ResultW=%h ReadDataW=%h ResultW=%h",
                 $time, rst, ResultSrcW, PCPlus4W, ALU_ResultW, ReadDataW, ResultW);
    end

    // Tạo file VCD để xem wave
    initial begin
        $dumpfile("writeback_stage_tb.vcd");
        $dumpvars(0, Writeback_Stage_tb);
    end

endmodule