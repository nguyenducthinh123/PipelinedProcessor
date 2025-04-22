module Main_Decoder(Op,RegWrite,ImmSrc,ALUSrc,MemWrite,MemRead,ResultSrc,Branch,ALUOp);
    input [6:0]Op;
    output RegWrite,ALUSrc,MemWrite,MemRead,ResultSrc,Branch;
    output [1:0]ImmSrc,ALUOp;

    assign RegWrite = (Op == 7'b0000011 | Op == 7'b0110011 | Op == 7'b0010011 ) ? 1'b1 :
                                                              1'b0 ; // I-Load, R-Type, I-Type register write enable = 1
    assign ImmSrc = (Op == 7'b0100011) ? 2'b01 : 
                    (Op == 7'b1100011) ? 2'b10 :    
                                         2'b00 ; // I-Type immediate source = 0, S-Type immediate source = 1, B-Type immediate source = 2
    assign ALUSrc = (Op == 7'b0000011 | Op == 7'b0100011 | Op == 7'b0010011) ? 1'b1 :
                                                            1'b0 ; // I-Load, S-Type, I-Type ALU source = 1
    assign MemWrite = (Op == 7'b0100011) ? 1'b1 :
                                           1'b0 ; // S-Type memory write enable = 1
    assign ResultSrc = (Op == 7'b0000011) ? 1'b1 :
                                            1'b0 ; // I-Load result source = 1, R-Type result source = 0
    assign Branch = (Op == 7'b1100011) ? 1'b1 :
                                         1'b0 ; // B-Type branch enable = 1
    assign ALUOp = (Op == 7'b0110011) ? 2'b10 :
                   (Op == 7'b1100011) ? 2'b01 :
                                        2'b00 ; // R-Type ALU operation = 2, B-Type ALU operation = 1, I-Type ALU operation = 0

    assign MemRead = (Op == 7'b0000011) ? 1'b1 : 1'b0;   // Load -> Need to read memory

endmodule