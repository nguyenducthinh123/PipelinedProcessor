module fetch_cycle_tb();

    // Khai báo các tín hiệu
    reg clk, rst, PCSrcE;
    reg [31:0] PCTargetE;
    wire [31:0] InstrD, PCD, PCPlus4D;

    // Tạo tín hiệu clock
    always begin
        #50 clk = ~clk; // Chu kỳ clock là 100 đơn vị thời gian
    end

    // Điều khiển tín hiệu reset
    initial begin
        clk = 0;
        rst = 0; // Kích hoạt reset
        PCSrcE = 0; // Không nhảy (branch)
        PCTargetE = 32'h00000000; // Đặt giá trị mặc định cho PCTargetE
        #100;
        rst = 1; // Tắt reset, bắt đầu hoạt động bình thường
    end

    // Kết nối module fetch_cycle
    fetch_cycle dut (
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );

    // Theo dõi kết quả
    initial begin
        $monitor("Time: %0t | InstrD: %h | PCD: %h | PCPlus4D: %h", 
                 $time, InstrD, PCD, PCPlus4D);

        // Test nhảy (branch)
        #300;
        PCSrcE = 1; // Kích hoạt nhảy
        PCTargetE = 32'h00000020; // Đặt địa chỉ nhảy
        #100;
        PCSrcE = 0; // Tắt nhảy

        #500;
        $finish; // Kết thúc mô phỏng
    end

endmodule