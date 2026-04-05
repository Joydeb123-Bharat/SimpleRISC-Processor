`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2026 14:46:46
// Design Name: 
// Module Name: ALU_EX
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// TO act as a wrapper for the ALU
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module ALU_EX(
    input [31:0] A,
    input [31:0] B,
    input clk,
    input rst,
    input [3:0] ALU_Ctrl,
    input div_start,
    output [31:0] Alu_out,  
    output [1:0] flags,     
    output Div_done,        
    output Div_busy         
    );
    wire [31:0] ao;
    wire [31:0] qo, rem;
    ALU alu(
        .A(A),
        .B(B),
        .ALU_Ctrl(ALU_Ctrl),
        .ALU_OUT(ao),
        .flags(flags) 
    );
    Divide dv(
        .clk(clk),
        .rst(rst),
        .start(div_start),
        .Dividend(A),
        .Divisor(B),
        .Quotient(qo),
        .Remainder(rem),
        .done(Div_done),
        .busy(Div_busy)
    );
    assign Alu_out = (ALU_Ctrl == 4'd4) ? qo : ((ALU_Ctrl == 4'd5) ? rem : ao); 
endmodule