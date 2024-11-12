`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.09.2024 08:09:14
// Design Name: 
// Module Name: rv32i
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

module rv32i(
    input clk
    );

    wire            zero_flag;
    wire    [6:0]   op_code;
    wire    [2:0]   funct3;
    wire            funct7;

    wire           pc_src;
    wire   [1:0]   result_src;
    wire           we_dmem;
    wire   [3:0]   alu_cont;
    wire   [1:0]   alu_src;
    wire   [2:0]   imm_src;
    wire           we_reg_file;
    wire   [2:0]   rw_type_dmem;
    wire           pc_target_s;
    wire           result_src_e_0;


    wire           we_reg_file_m;
    wire           stall_f;
    wire           stall_d;
    wire           flush_d;
    wire           flush_e;

    wire   [1:0]   forward_1e;
    wire   [1:0]   forward_2e;

    wire   [4:0]  rs_1_e;
    wire   [4:0]  rs_2_e;
    wire   [4:0]  rd_e;
    wire   [4:0]  rs_1_d;
    wire   [4:0]  rs_2_d;
    wire   [4:0]  rd_m;
    wire   [4:0]  rd_w;

    data_path DATA_PATH(
        .clk(clk),
        .pc_src_i(pc_src),
        .result_src_i(result_src),
        .we_dmem_i(we_dmem),   
        .alu_cont_i(alu_cont),
        .alu_src_i(alu_src),
        .imm_src_i(imm_src),
        .we_reg_file_i(we_reg_file),
        .rw_type_dmem_i(rw_type_dmem),
        .pc_target_s_i(pc_target_s),

        .zero_flag_o(zero_flag),
        .op_code_o(op_code),
        .funct3_o(funct3),
        .funct7_o(funct7),

        .stall_f_i(stall_f),
        .stall_d_i(stall_d),
        .flush_d_i(flush_d),
        .flush_e_i(flush_e),
        .forward_1e_i(forward_1e),
        .forward_2e_i(forward_2e),
        .rs_1_e_o(rs_1_e),
        .rs_2_e_o(rs_2_e),
        .rd_e_o(rd_e),
        .rs_1_d_o(rs_1_d),
        .rs_2_d_o(rs_2_d),
        .rd_m_o(rd_m),
        .rd_w_o(rd_w)

    );

    control_unit CONTROL_UNIT(
        .clk(clk),
        .zero_flag_i(zero_flag),
        .op_code_i(op_code),
        .funct3_i(funct3),
        .funct7_i(funct7),
        .flush_e_i(flush_e),
        .pc_target_s_o(pc_target_s),
        .pc_src_o(pc_src),
        .result_src_o(result_src),
        .we_dmem_o(we_dmem),   
        .alu_cont_o(alu_cont),
        .alu_src_o(alu_src),
        .imm_src_o(imm_src),
        .we_reg_file_o(we_reg_file),
        .rw_type_dmem_o(rw_type_dmem),
        .we_reg_file_m_o(we_reg_file_m),
        .result_src_e_0_o(result_src_e_0)
    );
   

    hazard_unit HAZARD_UNIT(
        .rs_1_e_i(rs_1_e),
        .rs_2_e_i(rs_2_e),
        .rd_e_i(rd_e),
        .rs_1_d_i(rs_1_d),
        .rs_2_d_i(rs_2_d),
        .stall_f_o(stall_f),
        .stall_d_o(stall_d),
        .flush_d_o(flush_d),
        .flush_e_o(flush_e),
        .forward_1e_o(forward_1e),
        .forward_2e_o(forward_2e),

        .pc_src_e_i(pc_src),
        .result_src_e_i(result_src_e_0),
        .rd_m_i(rd_m),
        .rd_w_i(rd_w),
        .we_reg_file_m_i(we_reg_file_m),
        .we_reg_file_w_i(we_reg_file)

      
    );
  




endmodule
