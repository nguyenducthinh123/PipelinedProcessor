module Fetch_Stage_tb();
    // Định nghĩa các tín hiệu test
    reg clk;
    reg rst;
    reg PCSrcE;
    reg [31:0] PCTargetE;
    wire [31:0] InstrD;
    wire [31:0] PCD;

    // Khởi tạo DUT
    Fetch_Stage DUT (
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .InstrD(InstrD),
        .PCD(PCD)
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
        PCSrcE = 0;
        PCTargetE = 32'h0;

        // Test case 1: Reset
        #200; // Đợi 2 chu kỳ clock
        rst = 1; // Bỏ reset
        
        // Test case 2: Normal sequential execution
        #300; // Đợi 3 chu kỳ clock
        // PC sẽ tự động tăng 4 sau mỗi chu kỳ
        
        // Test case 3: Branch taken
        PCSrcE = 1;
        PCTargetE = 32'h00000020; // Jump to address 0x20
        #100; // Đợi 1 chu kỳ clock
        
        // Test case 4: Return to sequential execution
        PCSrcE = 0;
        #300; // Đợi 3 chu kỳ clock
        
        // Test case 5: Another branch
        PCSrcE = 1;
        PCTargetE = 32'h00000040; // Jump to address 0x40
        #100; // Đợi 1 chu kỳ clock
        PCSrcE = 0;
        #200; // Đợi 2 chu kỳ clock

        // Test case 6: Reset during execution
        rst = 0;
        #100; // Đợi 1 chu kỳ clock
        rst = 1;
        #200; // Đợi 2 chu kỳ clock

        // Kết thúc simulation
        #500;
        $finish;
    end

    // Monitoring
    initial begin
        $monitor("Time=%0t rst=%b PCSrcE=%b PCTargetE=%h InstrD=%h PCD=%h",
                 $time, rst, PCSrcE, PCTargetE, InstrD, PCD);
    end

    // Tạo file VCD để xem wave
    initial begin
        $dumpfile("fetch_stage_tb.vcd");
        $dumpvars(0, Fetch_Stage_tb);
    end

endmodule