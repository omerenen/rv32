`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.09.2024 08:41:54
// Design Name: 
// Module Name: main_decoder
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


module main_decoder(
    input         [6:0]   op_code_i,
    output  reg           branch_o,
    output  reg           jump_o,
    output  reg   [1:0]   result_src_o,
    output  reg           pc_target_s_o,
    output  reg           we_dmem_o,
    output  reg   [1:0]   alu_src_o,
    output  reg   [2:0]   imm_src_o,
    output  reg           we_reg_file_o,
    output  reg   [1:0]   alu_op_o
    );
    
    always @(*) begin
        branch_o        = 3'b000;
        jump_o          = 3'b000;
        result_src_o    = 3'b000;
        we_dmem_o       = 3'b000;
        alu_src_o       = 2'b00;
        imm_src_o       = 3'b000;
        we_reg_file_o   = 3'b000;
        alu_op_o        = 3'b000;
        
        case (op_code_i)
            `OPCODE_J_TYPE_JAL: begin
                branch_o        = 1'b0;
                jump_o          = 1'b1;
                result_src_o    = 2'b10;
                we_dmem_o       = 1'b0;
                //alu_src_o       = 1'b1;
                pc_target_s_o   = 1'b0;
                imm_src_o       = 3'b100;
                we_reg_file_o   = 1'b1;
                //alu_op_o        = 2'b00;   
            end
            `OPCODE_R_TYPE: begin
                branch_o        = 1'b0;
                jump_o          = 1'b0;
                result_src_o    = 2'b00;
                we_dmem_o       = 1'b0;
                alu_src_o       = 2'b00;
                pc_target_s_o    = 1'b0;
                //imm_src_o       = xx;
                we_reg_file_o   = 1'b1;
                alu_op_o        = 2'b10;
            end
            `OPCODE_I_TYPE_IMM: begin
                branch_o        = 1'b0;
                jump_o          = 1'b0;
                result_src_o    = 2'b00;
                we_dmem_o       = 1'b0;
                alu_src_o       = 2'b01;
                pc_target_s_o   = 1'b0;
                imm_src_o       = 3'b000;
                we_reg_file_o   = 1'b1;
                alu_op_o        = 2'b10;
            end
            `OPCODE_I_TYPE_LOAD: begin
                branch_o        = 1'b0;
                jump_o          = 1'b0;
                result_src_o    = 2'b01;
                we_dmem_o       = 1'b0;
                alu_src_o       = 2'b01;
                pc_target_s_o   = 1'b0;
                imm_src_o       = 3'b000;
                we_reg_file_o   = 1'b1;
                alu_op_o        = 2'b00;
            end
            `OPCODE_I_TYPE_JALR: begin
                branch_o        = 1'b0;
                jump_o          = 1'b1;
                result_src_o    = 2'b10;
                we_dmem_o       = 1'b0;
                //alu_src_o       = 1'b1;
                pc_target_s_o   = 1'b1;
                imm_src_o       = 3'b000;
                we_reg_file_o   = 1'b1;
                //alu_op_o        = 2'b00;
            end
            `OPCODE_U_TYPE_AUIPC: begin
                branch_o        = 1'b0;
                jump_o          = 1'b0;
                result_src_o    = 2'b00;
                we_dmem_o       = 1'b0;
                alu_src_o       = 2'b11;
                pc_target_s_o   = 1'b0;
                imm_src_o       = 3'b011;
                we_reg_file_o   = 1'b1;
                alu_op_o        = 2'b00;
            end
            `OPCODE_U_TYPE_LUI: begin //???
                branch_o        = 1'b0;
                jump_o          = 1'b0;
                result_src_o    = 2'b00;
                we_dmem_o       = 1'b0;
                alu_src_o       = 2'b01;
                pc_target_s_o   = 1'b0;
                imm_src_o       = 3'b011;
                we_reg_file_o   = 1'b1;
                alu_op_o        = 2'b00;
            end
            `OPCODE_S_TYPE: begin
                branch_o        = 1'b0;
                jump_o          = 1'b0;
                //result_src_o    = 2'b00;
                we_dmem_o       = 1'b1;
                alu_src_o       = 2'b01;
                pc_target_s_o   = 1'b0;
                imm_src_o       = 3'b001;
                we_reg_file_o   = 1'b0;
                alu_op_o        = 2'b00;  
            end
            `OPCODE_B_TYPE: begin
                branch_o        = 1'b1;
                jump_o          = 1'b0;
                //result_src_o    = 2'b00;
                we_dmem_o       = 1'b0;
                alu_src_o       = 2'b00;
                pc_target_s_o   = 1'b0;
                imm_src_o       = 3'b010;
                we_reg_file_o   = 1'b0;
                alu_op_o        = 2'b11;             
            end
            default: begin
                branch_o        = 3'b000;
                jump_o          = 3'b000;
                result_src_o    = 3'b000;
                we_dmem_o       = 3'b000;
                alu_src_o       = 2'b00;
                imm_src_o       = 3'b000;
                we_reg_file_o   = 3'b000;
                alu_op_o        = 3'b000;
            end
        endcase
    end
endmodule
