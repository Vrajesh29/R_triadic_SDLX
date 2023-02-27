`timescale 1ns / 1ps

module Reg_File(data_in,rd,RS1, RS2, read, WE, clk, num1, num2);
  input  [31:0] data_in;
  input  [4:0]  RS1;
  input  [4:0]  RS2;
  input  [4:0]  rd;
  input  read,WE,clk;
  output [31:0] num1;
  output [31:0] num2;

  reg    [31:0] memory_array[31:0];
  reg    [31:0] out_data1;
  reg    [31:0] out_data2;
  wire  clk_out;
  
  always@(posedge clk)
    begin
      memory_array[5'b00000] = 32'b00000000000000000000000000000000;
      memory_array[5'b00001] = 32'b00000000000000000000000000000001;
      memory_array[5'b00010] = 32'b00000000000000000000000000000010;
      memory_array[5'b00011] = 32'b00000000000000000000000000000011;
      memory_array[5'b00100] = 32'b00000000000000000000000000000100;
      memory_array[5'b00101] = 32'b00000000000000000000000000000101;
      memory_array[5'b00110] = 32'b00000000000000000000000000000110;
      memory_array[5'b00111] = 32'b00000000000000000000000000000111;
      memory_array[5'b01000] = 32'b00000000000000000000000010001000;
      memory_array[5'b01001] = 32'b00000000000000000000000001001001;
      // It should okay if the below if condition is not used.
      if(read)                         
        begin
          out_data1 = memory_array[RS1];
          out_data2 = memory_array[RS2];
        end
    end
  assign num1 = out_data1;
  assign num2 = out_data2;
  always@(posedge clk)
    begin
      if(WE)
        begin
          memory_array[rd] = data_in;
        end
      end
endmodule

