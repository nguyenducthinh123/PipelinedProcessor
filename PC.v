module PC_Module(clk, rst, PCWrite, PC_Next, PC);
    input clk, rst, PCWrite;
    input [31:0] PC_Next;
    output reg [31:0] PC;

    always @(posedge clk) begin
        if (!rst)
            PC <= 32'b0;
        else if (PCWrite)
            PC <= PC_Next;
        // else giữ nguyên PC (stall)
    end
endmodule
