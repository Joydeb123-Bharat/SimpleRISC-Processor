`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2026 21:09:00
// Design Name: 
// Module Name: RegBank
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// The main idea of this code is that the user must define the value of the register before using it
// So that it will behave properly else it will have garbage data in it. The main reason is to create a BRAM by remove
// rst signal and do synchronous operations. The register will working will depend on the programmer. 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RegBank(
    input clk,
    input [3:0] rs1,
    input [3:0] rs2,
    input W,
    input [3:0] rd,
    input [31:0] imm,
    output reg [31:0] A,
    output reg [31:0] B
    );
    reg [31 : 0] RB[0 : 15];
    always@(posedge clk)
    begin 
            if(W)
            begin
                RB[rd] <= imm;
            end
            else
            begin
                A <= (rs1 == 4'b0000) ? 32'b0 : RB[rs1];
                B <= (rs2 == 4'b0000) ? 32'b0 : RB[rs2];
            end
    end         
endmodule
