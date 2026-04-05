`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2026 21:05:13
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// The main idea of the ALU is that it must be combinational logic in order to account for the extra step
// taken in the Register Bank
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALU_Ctrl,
    output reg [31:0] ALU_OUT,
    output reg [1:0] flags
    );
    localparam ADD=4'd0, SUB=4'd1, CMP=4'd2, MUL=4'd3, DIV=4'd4, MOD=4'd5, AND=4'd6, OR=4'd7, NOT=4'd8, LSL=4'd9, LSR=4'd10, ASR=4'd11, MOV=4'd12;
    always@(*)
    begin
    flags = 0;
    ALU_OUT = 0;
        case(ALU_Ctrl)
            ADD: ALU_OUT = A + B;
            SUB: ALU_OUT = A - B;
            CMP: 
                begin
                    if(A == B)
                    flags[1] = 1;
                    else if(A > B)
                    flags[0] = 1;
                    else
                    flags = 0;
                end
            MUL: ALU_OUT = A * B;
            AND: ALU_OUT = A & B;
            OR: ALU_OUT = A | B;
            NOT: ALU_OUT = ~A;
            LSL: ALU_OUT = A << B;
            LSR: ALU_OUT = A >> B;
            ASR: ALU_OUT = $signed(A) >>> B;
            MOV: ALU_OUT = B;
            default: 
                begin
                    flags = 0;
                    ALU_OUT = 0;
                end
          endcase
     end
endmodule
