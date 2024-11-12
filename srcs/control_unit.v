`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.09.2024 08:28:07
// Design Name: 
// Module Name: control_unit
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



module control_unit(
        input            clk,
        input            zero_flag_i,
        input    [6:0]   op_code_i,
        input    [2:0]   funct3_i,
        input            funct7_i,
        input            flush_e_i,
        output           pc_target_s_o,
        output           pc_src_o,
        output   [1:0]   result_src_o,
        output           we_dmem_o,   
        output   [3:0]   alu_cont_o, //
        output   [1:0]   alu_src_o,
        output   [2:0]   imm_src_o,
        output           we_reg_file_o,
        output           result_src_e_0_o,
        output           we_reg_file_m_o,
        output   [2:0]   rw_type_dmem_o

    );
    

    wire    [1:0]   alu_op;
    wire            branch;
    wire            jump;

    // decode 
    wire            we_reg_file_d;
    wire    [1:0]   result_src_d;
    wire            we_dmem_d;
    wire            jump_d;
    wire            branch_d;
    wire            pc_target_s_d;

    wire    [3:0]   alu_cont_d;
    wire    [1:0]   alu_src_d;



    // execute
    wire            we_reg_file_e;
    wire    [1:0]   result_src_e;
    wire            we_dmem_e;
    wire            jump_e;
    wire            branch_e;
    wire    [2:0]   rw_type_dmem_e;

    // memory
    wire            we_reg_file_m;
    wire    [1:0]   result_src_m;




    // decode   -> execute registers
    dffe #(1) we_reg_file_de(
        .clk(clk),
        .rst(flush_e_i),
        .enable_i(1),
        .data_i(we_reg_file_d),
        .data_o(we_reg_file_e)
    );

    dffe #(2) result_src_de(
        .clk(clk),
        .rst(flush_e_i),
        .enable_i(1),
        .data_i(result_src_d),
        .data_o(result_src_e)
    );

    dffe #(1) we_data_mem_de(
        .clk(clk),
        .rst(flush_e_i),
        .enable_i(1),
        .data_i(we_dmem_d),
        .data_o(we_dmem_e)
    );

    dffe #(1) jump_de(
        .clk(clk),
        .rst(flush_e_i),
        .enable_i(1),
        .data_i(jump_d),
        .data_o(jump_e)
    );

    dffe #(1) branch_de(
        .clk(clk),
        .rst(flush_e_i),
        .enable_i(1),
        .data_i(branch_d),
        .data_o(branch_e)
    );

    dffe #(4) alu_cont_de(
        .clk(clk),
        .rst(flush_e_i),
        .enable_i(1),
        .data_i(alu_cont_d),
        .data_o(alu_cont_o)
    );

    dffe #(2) alu_src_de(
        .clk(clk),
        .rst(flush_e_i),
        .enable_i(1),
        .data_i(alu_src_d),
        .data_o(alu_src_o)
    );
    

    dffe #(2) pc_target_s_de(
        .clk(clk),
        .rst(flush_e_i),
        .enable_i(1),
        .data_i(pc_target_s_d),
        .data_o(pc_target_s_o)
    );

    dffe #(3) rw_type_dmem_de(
        .clk(clk),
        .rst(flush_e_i),
        .enable_i(1),
        .data_i(funct3_i),
        .data_o(rw_type_dmem_e)
    );



    // execute  -> memory registers

    dff #(1) we_reg_file_em(
        .clk(clk),
        .data_i(we_reg_file_e),
        .data_o(we_reg_file_m)
    );

    dff #(2) result_src_em(
        .clk(clk),
        .data_i(result_src_e),
        .data_o(result_src_m)
    );

    dff #(1) we_data_mem_em(
        .clk(clk),
        .data_i(we_dmem_e),
        .data_o(we_dmem_o)
    );

    dff #(3) rw_type_dmem_em(
        .clk(clk),
        .data_i(rw_type_dmem_e),
        .data_o(rw_type_dmem_o)
    );



    // memory   -> write registers

     dff #(1) we_reg_file_mw(
        .clk(clk),
        .data_i(we_reg_file_m),
        .data_o(we_reg_file_o)
    );

    dff #(2) result_src_mw(
        .clk(clk),
        .data_i(result_src_m),
        .data_o(result_src_o)
    );


    // ----------------

    main_decoder MAIN_DECODER(
        .op_code_i(op_code_i),
        .branch_o(branch_d),
        .jump_o(jump_d),
        .result_src_o(result_src_d),
        .we_dmem_o(we_dmem_d),
        .alu_src_o(alu_src_d),
        .imm_src_o(imm_src_o),
        .pc_target_s_o(pc_target_s_d),
        .we_reg_file_o(we_reg_file_d),
        .alu_op_o(alu_op)
    );

    alu_decoder ALU_DECODER(
        .alu_op_i(alu_op),
        .op_code_5_i(op_code_i[5]),
        .funct3_i(funct3_i),
        .funct7_5_i(funct7_i),
        .alu_cont_o(alu_cont_d)
    );

    assign pc_src_o = (zero_flag_i  &   branch_e) | jump_e;
    assign result_src_e_0_o = result_src_e[0];
    assign we_reg_file_m_o = we_reg_file_m;
    
endmodule
