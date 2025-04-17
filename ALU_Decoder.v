module ALU_Decoder(ALUOp,funct3,funct7,op,ALUControl);

    input [1:0]ALUOp;
    input [2:0]funct3;
    input [6:0]funct7,op;
    output [2:0]ALUControl;

    assign ALUControl = (ALUOp == 2'b00) ? 3'b000 :
                        (ALUOp == 2'b01) ? 3'b001 :
                        ((ALUOp == 2'b10) & (funct3 == 3'b000) & ({op[5],funct7[5]} == 2'b11)) ? 3'b001 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b000) & ({op[5],funct7[5]} != 2'b11)) ? 3'b000 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b010)) ? 3'b101 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b110)) ? 3'b011 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b111)) ? 3'b010 : 
                                                                  3'b000 ;
    // ALUControl = (ALUOp == 2'b00) ? 3'b000 : // Load/Store -> Add
    //               (ALUOp == 2'b01) ? 3'b001 : // Branch -> Subtract
    //               (ALUOp == 2'b10) ? ((funct3 == 3'b000) & ({op[5],funct7[5]} == 2'b11)) ? 3'b001 : // R-type -> Subtract
    //                                   ((funct3 == 3'b000) & ({op[5],funct7[5]} != 2'b11)) ? 3'b000 : // R-type -> Add
    //                                   ((funct3 == 3'b010)) ? 3'b101 : // R-type -> Set on Less Than
    //                                   ((funct3 == 3'b110)) ? 3'b011 : // R-type -> OR
    //                                   ((funct3 == 3'b111)) ? 3'b010 : // R-type -> AND
    //                                   3'b000 : // Default                                                                  
endmodule