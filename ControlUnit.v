`timescale 1ns / 1ps

module ControlUnit(
    input clk,
    input rst,
    input Div_busy,
    input Div_done,
    input [4:0] opcode,
    input RorImm, 
    input ProStart, 
    output reg PC_W, 
    output reg Mem_isSt,
    output reg Mem_isLd,
    output reg RB_W, 
    output reg [3:0] Alu_Ctrl,
    output reg Div_start,
    output reg isCall,
    output reg isLd, 
    output reg sr1,
    output reg isRet,
    output isImm,
    output Beq, 
    output Bgt, 
    output UB,  
    
    output reg doneP 
    );
    localparam FETCH = 3'd0, DECODE = 3'd1, EXECUTE = 3'd2;
    localparam WAIT_DIVIDER = 3'd3, MEMORY = 3'd4, WRITEBACK = 3'd5, IDLE =3'd6;
    
    assign isImm = RorImm ? 1 : 0;
    
    // FIX: Instant combinational evaluation!
    assign Beq = (opcode == 5'd16);
    assign Bgt = (opcode == 5'd17);
    assign UB  = (opcode == 5'd18);

    reg [3:0] state;
    always@(posedge clk or posedge rst)
    begin
    if(rst)
        state <= IDLE;
    else
    begin
        case(state)
            IDLE:
            begin
                PC_W <= 0;
                Mem_isSt <= 0;
                Mem_isLd <= 0;
                Alu_Ctrl <= 0;
                Div_start <= 0;
                isCall <= 0;
                isLd <= 0;
                RB_W <= 0;
                sr1 <= 0;
                doneP <= 0;
                if(ProStart) state <= FETCH;
                else state <= state;
            end
            FETCH:
            begin
            if(~doneP)
            begin
                isLd <= 0;
                isCall <= 0;
                Mem_isLd <= 0;
                Mem_isSt <= 0;
                RB_W <= 0;
                PC_W <= 0;
                
                case(opcode)
                    5'b10100: sr1 <= 1;
                    default: sr1 <= 0;
                endcase
                
                if(opcode == 5'b10110) 
                    begin   
                        state <= IDLE;
                        doneP <= 1;
                    end
                else
                    state <= DECODE;
            end
            else
                state <= IDLE;
            end
            DECODE:
            begin
                state <= EXECUTE;
                if(opcode == 5'b10100) isRet <= 1;
                else isRet <= 0;
            end
            EXECUTE:
            begin
                 if (opcode == 5'd14 || opcode == 5'd15)
                     Alu_Ctrl <= 4'd0;
                 else
                     Alu_Ctrl <= opcode[3:0];

                 if((opcode[3:0] == 4'd4 || opcode[3:0] == 4'd5) && ~Div_done)
                 begin
                    Div_start <= 1;
                    state <= WAIT_DIVIDER;
                 end
                 else if(opcode == 5'd16 || opcode == 5'd17 || opcode == 5'd18)
                 begin
                    state <= FETCH;
                    PC_W <= 1;
                 end
                 else if(opcode == 5'd14 || opcode == 5'd15)
                 begin
                    state <= MEMORY; 
                    if(opcode == 5'd14)
                    begin
                        Mem_isLd <= 1;
                        isLd <= 1;
                    end
                    else if(opcode == 5'd15)
                        Mem_isSt <= 1;
                 end
                 else if(opcode == 5'b10011)
                 begin
                    isCall <= 1;
                    state <= WRITEBACK;
                 end
                 else
                    state <= WRITEBACK;  
            end
            WAIT_DIVIDER:
            begin
                Div_start <= 0;
                if(Div_done) state <= WRITEBACK;
                else state <= state;
            end
            MEMORY:
            begin
                if(opcode == 5'd14)
                begin
                    Mem_isLd <= 0;
                    isLd <= 1;
                    state <= WRITEBACK;
                end
                else if(opcode == 5'd15)
                begin
                    state <= FETCH;
                    PC_W <= 1;
                    Mem_isSt <= 0;
                end
                else
                begin
                    if(opcode == 5'b10011) isCall <= 1;
                    state <= WRITEBACK;
                end                 
            end
            WRITEBACK:
            begin
                PC_W <= 1;
                RB_W <= 1;
                state <= FETCH;
            end
            default: state <= IDLE;
        endcase      
    end
    end
endmodule