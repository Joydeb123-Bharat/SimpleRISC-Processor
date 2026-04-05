`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2026 21:09:00
// Design Name: 
// Module Name: SimpleRISC
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
module SimpleRISC(
    input clk,
    input rst,
    input ProStart,
    output doneP
    );
    //Declearation
    reg [31:0] PC; 
    wire [31:0] NPC; 
    wire [31:0] Alu_result; 
    wire div_busy, div_done; 
    wire [31:0] branchT, inst, imm; 
    wire PC_W, Mem_isSt, Mem_isLd, RB_W, Div_start, isCall, isLd, sr1, isRet, isImm, Beq, Bgt, UB; 
    wire [1:0] alu_flags; 
    wire [3:0] Alu_Ctrl;
    wire [31:0] RB_A, RB_B, RB_Din; 
    wire [31:0] dmem_out;
    wire [31:0] alu_B;
    wire [3:0] rs1_addr; 
    reg [1:0] status_flags;
    always @(posedge clk or posedge rst) begin
        if(rst) status_flags <= 2'b00;
        else if(inst[31:27] == 5'd2 && RB_W) 
            status_flags <= alu_flags;
    end
    wire true_Bgt = (inst[31:27] == 5'd17);
    wire true_Beq = (inst[31:27] == 5'd16);
    wire true_UB  = (inst[31:27] == 5'd18);
    wire take_branch = true_UB | (status_flags[1] & true_Beq) | (status_flags[0] & true_Bgt);
    wire [3:0] rs2_addr;
    // Routing Logic
    assign rs2_addr = (inst[31:27] == 5'd15) ? inst[25:22] : inst[17:14];
    assign NPC = isRet ? RB_A : (take_branch ? branchT : PC + 4);
    assign alu_B = isImm ? imm : RB_B;
    assign RB_Din = isCall ? NPC : (isLd ? dmem_out : Alu_result);
    assign rs1_addr = sr1 ? 4'b1111 : inst[21:18];
    // PC Update
    always @(posedge clk or posedge rst) begin
        if(rst) PC <= 32'b0;
        else if(PC_W) PC <= NPC;
    end
    // Instantiations
    IMEM imem(.clk(clk), .PC(PC), .Inst(inst));
    ImmBTaG imgen(.Inst(inst), .PC(PC), .T(branchT), .Imm(imm));
    RegBank rb(
        .clk(clk), .rs1(rs1_addr), .rs2(rs2_addr), .W(RB_W),
        .rd(inst[25:22]), .imm(RB_Din), .A(RB_A), .B(RB_B)
    );
    ALU_EX ex_unit(
        .A(RB_A), .B(alu_B), .clk(clk), .rst(rst), .ALU_Ctrl(Alu_Ctrl),
        .div_start(Div_start), .Alu_out(Alu_result), .flags(alu_flags),     
        .Div_done(div_done), .Div_busy(div_busy)         
    );
    DMEM dmem(
        .clk(clk), .isSt(Mem_isSt), .isLd(Mem_isLd), .Add(Alu_result),     
        .DataIn(RB_B), .DataOut(dmem_out)    
    );
    BranchUnit branch_eval(
        .flags(status_flags), .UB(UB), .BGT(Bgt), .BEQ(Beq), 
        .BranchT() 
    );   
    ControlUnit brain(
        .clk(clk), .rst(rst), .Div_busy(div_busy), .Div_done(div_done),
        .opcode(inst[31:27]), .RorImm(inst[26]), .ProStart(ProStart),
        .PC_W(PC_W), .Mem_isSt(Mem_isSt), .Mem_isLd(Mem_isLd), .RB_W(RB_W),
        .Alu_Ctrl(Alu_Ctrl), .Div_start(Div_start), .isCall(isCall), .isLd(isLd),
        .sr1(sr1), .isRet(isRet), .isImm(isImm), .Beq(Beq), .Bgt(Bgt), .UB(UB), .doneP(doneP)
    );
endmodule