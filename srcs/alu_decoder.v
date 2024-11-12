`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.09.2024 08:41:54
// Design Name: 
// Module Name: alu_decoder
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

`include "constants.vh"

module alu_decoder(
    input        [1:0]      alu_op_i,
    input                   op_code_5_i,
    input        [2:0]      funct3_i,
    input                   funct7_5_i,
    output  reg  [3:0]      alu_cont_o
    );

    wire [1:0] opcode_funct_7;
    assign opcode_funct_7 = {op_code_5_i, funct7_5_i};
    
    always @(*) begin
        case (alu_op_i)
            2'b00: alu_cont_o = `ADD;
            2'b01: alu_cont_o = `SUB;
            2'b10: begin
                case (funct3_i)
                    3'b000: alu_cont_o = (opcode_funct_7 == 2'b11) ? `SUB : `ADD;
                    3'b001: alu_cont_o = `SLL;
                    3'b010: alu_cont_o = `LT;
                    3'b011: alu_cont_o = `LTU;
                    3'b100: alu_cont_o = `XOR;
                    3'b101: alu_cont_o = (funct7_5_i == 1'b1) ? `SRA : `SRL;
                    3'b110: alu_cont_o = `OR;
                    3'b111: alu_cont_o = `AND;
                    default: alu_cont_o = 4'b0000;
                endcase
            end
            2'b11: begin
                case (funct3_i)
                    3'b000: alu_cont_o = `EQ;
                    3'b001: alu_cont_o = `NEQ;
                    3'b100: alu_cont_o = `LT;
                    3'b101: alu_cont_o = `GTE;
                    3'b110: alu_cont_o = `LTU;
                    3'b111: alu_cont_o = `GTEU;
                    default: alu_cont_o = 4'b0000;
                endcase
            end
            default: alu_cont_o = 4'b0000;
        endcase
    end

   
endmodule
