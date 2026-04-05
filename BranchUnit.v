`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2026 15:03:22
// Design Name: 
// Module Name: BranchUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module BranchUnit(
    input [1:0] flags,
    input UB,
    input BGT,
    input BEQ,
    output BranchT
    );
    assign BranchT = UB | (flags[1] & BEQ) | (flags[0] & BGT);
endmodule
