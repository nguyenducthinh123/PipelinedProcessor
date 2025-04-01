module tb();

    reg clk = 0, rst, PCSrcE;
    reg [31:0] PCTargetE;
    wire [31:0] InstrD, PCD, PCPlus4D;

    Fetch_Stage dut (
        .clk(clk), 
        .rst(rst), 
        .PCSrcE(PCSrcE), 
        .PCTargetE(PCTargetE), 
        .InstrD(InstrD), 
        .PCD(PCD), 
        .PCPlus4D(PCPlus4D) 
    );

    always begin
        clk = ~clk;
        #50;
    end

    initial begin
        rst <= 1'b0;
        #200;
        rst <= 1'b1;
        PCSrcE <= 1'b0;
        PCTargetE <= 32'h00000000;
        #500
        $finish;
    end    

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
    end
endmodule    