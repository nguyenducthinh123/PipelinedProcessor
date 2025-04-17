module Instruction_Memory(rst,A,RD);

  input rst;
  input [31:0]A;
  output [31:0]RD;

  reg [31:0] mem [1023:0]; // mảng 1024 phần tử, mỗi phần tử lưu được một lệnh (4 byte).
  
  assign RD = (rst == 1'b0) ? {32{1'b0}} : mem[A[31:2]]; // do mỗi lệnh 4 byte, để truy cập đúng cần chia địa chỉ byte cho 4

  initial begin
    $readmemh("memfile.hex",mem);
  end
  
endmodule