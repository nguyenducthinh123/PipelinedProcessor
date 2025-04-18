module hazard_unit_tb();
    // Định nghĩa các tín hiệu test
    reg rst;
    reg RegWriteM, RegWriteW;
    reg [4:0] RD_M, RD_W, Rs1_E, Rs2_E;
    wire [1:0] ForwardAE, ForwardBE;

    // Khởi tạo DUT (Device Under Test)
    hazard_unit DUT (
        .rst(rst),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .RD_M(RD_M),
        .RD_W(RD_W),
        .Rs1_E(Rs1_E),
        .Rs2_E(Rs2_E),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE)
    );

    // Test stimulus
    initial begin
        // Khởi tạo các giá trị ban đầu
        rst = 0;
        RegWriteM = 0;
        RegWriteW = 0;
        RD_M = 5'b00000;
        RD_W = 5'b00000;
        Rs1_E = 5'b00000;
        Rs2_E = 5'b00000;

        // Reset
        #100;
        rst = 1;

        // Test case 1: No forwarding (default case)
        RegWriteM = 0;
        RegWriteW = 0;
        RD_M = 5'b00000;
        RD_W = 5'b00000;
        Rs1_E = 5'b00001;
        Rs2_E = 5'b00010;
        #100;

        // Test case 2: Forward from MEM stage to Rs1_E
        RegWriteM = 1;
        RD_M = 5'b00001; // MEM stage writes to Rs1_E
        Rs1_E = 5'b00001;
        #100;

        // Test case 3: Forward from WB stage to Rs2_E
        RegWriteM = 0;
        RegWriteW = 1;
        RD_W = 5'b00010; // WB stage writes to Rs2_E
        Rs2_E = 5'b00010;
        #100;

        // Test case 4: Forward from both MEM and WB stages
        RegWriteM = 1;
        RegWriteW = 1;
        RD_M = 5'b00011; // MEM stage writes to Rs1_E
        RD_W = 5'b00100; // WB stage writes to Rs2_E
        Rs1_E = 5'b00011;
        Rs2_E = 5'b00100;
        #100;

        // Test case 5: No forwarding due to reset
        rst = 0;
        #100;

        // Kết thúc simulation
        $finish;
    end

    // Monitoring
    initial begin
        $monitor("Time=%0t rst=%b RegWriteM=%b RegWriteW=%b RD_M=%b RD_W=%b Rs1_E=%b Rs2_E=%b ForwardAE=%b ForwardBE=%b",
                 $time, rst, RegWriteM, RegWriteW, RD_M, RD_W, Rs1_E, Rs2_E, ForwardAE, ForwardBE);
    end

    // Tạo file VCD để xem wave
    initial begin
        $dumpfile("hazard_unit_tb.vcd");
        $dumpvars(0, hazard_unit_tb);
    end

endmodule