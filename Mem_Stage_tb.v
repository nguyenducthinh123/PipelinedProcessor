module Mem_Stage_tb();
    // Định nghĩa các tín hiệu test
    reg clk;
    reg rst;
    reg RegWriteM, MemWriteM, ResultSrcM;
    reg [4:0] RD_M;
    reg [31:0] PCPlus4M, WriteDataM, ALU_ResultM;

    wire RegWriteW, ResultSrcW;
    wire [4:0] RD_W;
    wire [31:0] PCPlus4W, ALU_ResultW, ReadDataW;

    // Khởi tạo DUT (Device Under Test)
    Mem_Stage DUT (
        .clk(clk),
        .rst(rst),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .RD_M(RD_M),
        .PCPlus4M(PCPlus4M),
        .WriteDataM(WriteDataM),
        .ALU_ResultM(ALU_ResultM),
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW),
        .RD_W(RD_W),
        .PCPlus4W(PCPlus4W),
        .ALU_ResultW(ALU_ResultW),
        .ReadDataW(ReadDataW)
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
        RegWriteM = 0;
        MemWriteM = 0;
        ResultSrcM = 0;
        RD_M = 0;
        PCPlus4M = 0;
        WriteDataM = 0;
        ALU_ResultM = 0;

        // Reset
        #100;
        rst = 1;

        // Test case 1: Write to memory
        MemWriteM = 1;
        ALU_ResultM = 32'h00000010; // Địa chỉ bộ nhớ
        WriteDataM = 32'hDEADBEEF; // Dữ liệu ghi vào bộ nhớ
        #100;

        // Test case 2: Read from memory
        MemWriteM = 0;
        ResultSrcM = 1; // Chọn dữ liệu từ bộ nhớ
        ALU_ResultM = 32'h00000010; // Địa chỉ bộ nhớ
        #100;

        // Test case 3: Pass ALU result
        ResultSrcM = 0; // Chọn kết quả ALU
        ALU_ResultM = 32'h12345678; // Giá trị ALU
        #100;

        // Test case 4: Update pipeline registers
        RegWriteM = 1;
        RD_M = 5'h05; // Thanh ghi đích
        PCPlus4M = 32'h00000020; // Giá trị PC+4
        ALU_ResultM = 32'h87654321; // Giá trị ALU
        #100;

        // Kết thúc simulation
        $finish;
    end

    // Monitoring
    initial begin
        $monitor("Time=%0t rst=%b MemWriteM=%b ResultSrcM=%b ALU_ResultM=%h WriteDataM=%h ReadDataW=%h ALU_ResultW=%h",
                 $time, rst, MemWriteM, ResultSrcM, ALU_ResultM, WriteDataM, ReadDataW, ALU_ResultW);
    end

    // Tạo file VCD để xem wave
    initial begin
        $dumpfile("mem_stage_tb.vcd");
        $dumpvars(0, Mem_Stage_tb);
    end

endmodule