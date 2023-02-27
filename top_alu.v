`timescale 1ns / 1ps

module top_alu(reset,din,p1,p2,p3,p4,p5,lower_bits,higher_bits,clk,out);
  input reset;
  input p1,p2,p3,p4,p5;
  input lower_bits,higher_bits;   // lower_bits for lsb bits and the other one for higher bits
  input clk;
  input  [7:0] din;
  output reg [15:0]out;
  reg  [7:0]instruction_1;
  reg  [7:0]instruction_2;
  reg  [7:0]instruction_3;
  reg  [7:0]instruction_4; 
  wire [31:0]instruction_set;
  
  
  wire [5:0]     func_code;
  wire [4:0]     rd;
  wire [4:0]     rs2;
  wire [4:0]     rs1;
  wire [5:0]     opcode;
  wire [31:0]  num1,num2;
  reg  [31:0] temp;

always @(posedge clk)
  begin
    if(reset==1) begin
      instruction_1[7:0]<=0;
      instruction_2[7:0]<=0;
      instruction_3[7:0]<=0;
      instruction_4[7:0]<=0;

  end
  
  else if (p1==1'b1) begin
    instruction_1[7:0]<=(din);  
    end
  else if (p2==1'b1) begin
    instruction_2[7:0]<=(din);   
    end
  else if (p3==1'b1) begin
    instruction_3[7:0]<=(din);  
    end
  else if (p4==1'b1)begin
    instruction_4[7:0]<=(din);    
    end
    end
  
  assign instruction_set={instruction_4,instruction_3,instruction_2,instruction_1};
  
  parameter     A = 6'b000000; //ADD  0
  parameter     B = 6'b000001; //SUB  1
  parameter     C = 6'b000010; //AND  2
  parameter     D = 6'b000011; //OR   3
  parameter     E = 6'b000100; //XOR  4
  parameter     F = 6'b000101; //SLL  5
  parameter     G = 6'b000110; //SRL  6
  parameter     H = 6'b000111; //SRA  7
  parameter     I = 6'b001000; //ROL  8
  parameter     J = 6'b001001; //ROR  9
  parameter     K = 6'b001010; //SLT 10
  parameter     L = 6'b001011; //SGT 11
  parameter     M = 6'b001100; //SLE 12
  parameter     N = 6'b001101; //SGE 13
  parameter     O = 6'b001110; //UGT 14
  parameter     P = 6'b001111; //ULT 15
  parameter     Q = 6'b010000; //ULE 16
  parameter     R = 6'b010001; //UGE 17
  
  wire [5:0] state;
  wire signed [31:0] s_num1, s_num2;

  
  assign func_code = instruction_set[5:0];
  assign rd        = instruction_set[15:11];
  assign rs2       = instruction_set[20:16];
  assign rs1       = instruction_set[25:21];
  assign opcode    = instruction_set[31:26];

  Reg_File r1(out,rd,rs1,rs2,1'b1,1'b1,p5,num1,num2);

  assign s_num1 = num1;
  assign s_num2 = num2;
  
  assign state = func_code;
  always @(p5) begin
  
    case( state )
      A: begin
        temp <= num1+num2;
      end
      B: begin
        temp <= num1-num2;
      end
      C: begin
        temp <= num1 & num2;
      end
      D: begin
        temp <= num1 | num2;
      end
      E: begin
        temp <= num1 ^ num2;
      end
      F: begin
        temp <= num1 << num2;
      end
      G: begin
        temp <= num1 >> num2;
      end
      H: begin
        temp <= num1 >>> num2;
      end
      I: begin
          temp <= (num1<<num2) | (num1>>(32-num2));
      end
      J: begin
            temp <= (num1>>num2) | (num1<<(32-num2));
      end
      K: begin
        temp <= (s_num1 < s_num2)? 32'b1:32'b0;
      end
      L: begin
        temp <=  (s_num1 > s_num2)? 32'b1:32'b0;
      end
      M: begin
        temp <=  (s_num1 <= s_num2)? 32'b1:32'b0;
      end
      N: begin
        temp <=  (s_num1 >= s_num2)? 32'b1:32'b0;
      end
      O: begin
        temp <=  (num1 > num2)? 32'b1:32'b0;

      end
      P: begin
        temp <= (num1 < num2)? 32'b1:32'b0;

      end
      Q: begin
        temp <= (num1 <= num2)? 32'b1:32'b0;

      end
      R: begin
        temp <= (num1 >= num2)? 32'b1:32'b0;

      end
      
    endcase
      if(higher_bits==1'b1) begin
      out = temp[31:16];
      end
      else if (lower_bits==1'b1) begin
      out = temp[15:0];  
      end
    end
  
endmodule
