`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 25.09.2024 11:37:01
// Design Name:
// Module Name: data_path
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


module data_path(
        input           clk,
        //control unit
        input           pc_src_i,
        input   [1:0]   result_src_i,
        input           we_dmem_i,   
        input   [3:0]   alu_cont_i,
        input   [1:0]   alu_src_i,
        input   [2:0]   imm_src_i,
        input           we_reg_file_i,
        input   [2:0]   rw_type_dmem_i,
        input           pc_target_s_i,

        output          zero_flag_o,
        output  [6:0]   op_code_o,
        output  [2:0]   funct3_o,
        output          funct7_o,


        //hazard unit
        input           stall_f_i,
        input           stall_d_i,
        input           flush_d_i,
        input           flush_e_i,
        input   [1:0]   forward_1e_i,
        input   [1:0]   forward_2e_i,

        output  [4:0]  rs_1_e_o,
        output  [4:0]  rs_2_e_o,
        output  [4:0]  rd_e_o,

        output  [4:0]  rs_1_d_o,
        output  [4:0]  rs_2_d_o,
        output  [4:0]  rd_m_o,
        output  [4:0]  rd_w_o
    );


    wire    [31:0]  instruction_f;
    wire    [31:0]  instruction_d;

    wire    [31:0]  pc_o_f;
    wire    [31:0]  pc_o_d;
    wire    [31:0]  pc_o_e;

    wire    [31:0]  pcplus4_d;
    wire    [31:0]  pcplus4_e;
    wire    [31:0]  pcplus4_m;
    wire    [31:0]  pcplus4_w;

    wire    [31:0]  write_data_m;

    wire    [31:0]  pc_next_i; 
    wire    [31:0]  alu_src_a;
    wire    [31:0]  alu_src_b;

    wire    [31:0]  imm_ext_o;
    wire    [31:0]  imm_ext_o_d;
    wire    [31:0]  imm_ext_o_e;


    wire    [31:0]  pc_target;
    wire    [31:0]  alu_result_e;
    wire    [31:0]  alu_result_m;
    wire    [31:0]  alu_result_w;

    wire    [31:0]  read_data_m;
    wire    [31:0]  read_data_w;

    wire    [31:0]  rd1_reg_file_d;
    wire    [31:0]  rd2_reg_file_d;
    wire    [31:0]  rd1_reg_file_e;
    wire    [31:0]  rd2_reg_file_e;

    wire    [31:0]  rd1_reg_file_e_fwd;
    wire    [31:0]  rd2_reg_file_e_fwd; 

    
    wire    [4:0]  rs1_e;
    wire    [4:0]  rs2_e;
    wire    [4:0]  rd_e;
    wire    [4:0]  rd_m;
    wire    [4:0]  rd_w;



    wire    [31:0]  result_read_data_w;



    // fetch -> decode registers
    dffe #(32) instruction_fd(
        .clk(clk),
        .rst(flush_d_i),
        .enable_i(!stall_d_i),
        .data_i(instruction_f),
        .data_o(instruction_d)
    );


    dffe #(32) pc_fd(
        .clk(clk),
        .rst(flush_d_i),
        .enable_i(!stall_d_i),
        .data_i(pc_o_f),
        .data_o(pc_o_d)
    );


    dffe #(32) pcplus4_fd(
        .clk(clk),
        .rst(flush_d_i),
        .enable_i(!stall_d_i),
        .data_i(pc_o_f + 4),
        .data_o(pcplus4_d)
    );


    // decode -> execute registers

    dffe #(32) RD1_de(
        .clk(clk),
        .rst(flush_e_i),
        .enable_i(1),
        .data_i(rd1_reg_file_d),
        .data_o(rd1_reg_file_e)
    );


    dffe #(32) RD2_de(
        .clk(clk),
        .rst(flush_e_i),
        .enable_i(1),
        .data_i(rd2_reg_file_d),
        .data_o(rd2_reg_file_e)
    );


    dffe #(32) pc_de(
        .clk(clk),
        .rst(flush_e_i),
        .enable_i(1),
        .data_i(pc_o_d),
        .data_o(pc_o_e)
    );


    
    dffe #(5) rs1_de(
        .clk(clk),
        .rst(flush_e_i),
        .enable_i(1),
        .data_i(instruction_d[19:15]),
        .data_o(rs1_e)
    );

    dffe #(5) rs2_de(
        .clk(clk),
        .rst(flush_e_i),
        .enable_i(1),
        .data_i(instruction_d[24:20]),
        .data_o(rs2_e)
    );
    

    dffe #(5) rd_de(
        .clk(clk),
        .rst(flush_e_i),
        .enable_i(1),
        .data_i(instruction_d[11:7]),
        .data_o(rd_e)
    );
    

    dffe #(32) immext_de(
        .clk(clk),
        .rst(flush_e_i),
        .enable_i(1),
        .data_i(imm_ext_o_d),
        .data_o(imm_ext_o_e)
    );

    dffe #(32) pcplus4_de(
        .clk(clk),
        .rst(flush_e_i),
        .enable_i(1),
        .data_i(pcplus4_d),
        .data_o(pcplus4_e)
    );



    // execute -> memory registers
    dff #(32) alu_result_em(
        .clk(clk),
        .data_i(alu_result_e),
        .data_o(alu_result_m)
    );

    dff #(32) write_data_em(
        .clk(clk),
        .data_i(rd2_reg_file_e_fwd),
        .data_o(write_data_m)
    );

    dff #(5) rd_em(
        .clk(clk),
        .data_i(rd_e),
        .data_o(rd_m)
    );
    

    dff #(32) pcplus4_em(
        .clk(clk),
        .data_i(pcplus4_e),
        .data_o(pcplus4_m)
    );


    // memory -> wb registers

    dff #(32) dmem_mw(
        .clk(clk),
        .data_i(read_data_m),
        .data_o(read_data_w)
    );

    dff #(32) alu_result_mw(
        .clk(clk),
        .data_i(alu_result_m),
        .data_o(alu_result_w)
    );

    dff #(5) rd_mw(
        .clk(clk),
        .data_i(rd_m),
        .data_o(rd_w)
    );
    

    dff #(32) pcplus4_mw(
        .clk(clk),
        .data_i(pcplus4_m),
        .data_o(pcplus4_w)
    );



    // general modules
    program_counter PC(
            .clk(clk),
            .en(!(stall_f_i)),
            .pc_next_i(pc_next_i), 
            .pc_o(pc_o_f)
        );

    inst_mem INSTRUCTION_MEMORY(
            .i_adress_i(pc_o_f),
            .i_read_o(instruction_f)
        );

    reg_file REGISTER_FILE(
            .clk(clk),
            .we_reg_file_i(we_reg_file_i), 
            .a1_reg_file_i(instruction_d[19:15]),
            .a2_reg_file_i(instruction_d[24:20]), 
            .a3_reg_file_i(rd_w), 
            .wd_reg_file_i(result_read_data_w),
            .rd1_reg_file_o(rd1_reg_file_d),
            .rd2_reg_file_o(rd2_reg_file_d) 
        );

    imm_ext IMMEDIATE_EXTENDED( 
            .imm_src_i(imm_src_i),
            .imm_ext_i(instruction_d),
            .imm_ext_o(imm_ext_o_d)
        );

    alu ALU(
            .alu_src_a_i(alu_src_a),
            .alu_src_b_i(alu_src_b),
            .alu_control_i(alu_cont_i), 
            .alu_zero_flag_o(zero_flag_o), 
            .alu_result_o(alu_result_e)
        );


    data_mem DATA_MEMORY(
            .clk(clk),
            .we_data_mem_i(we_dmem_i), 
            .a_data_mem_i(alu_result_m),
            .rw_type_dmem_i(rw_type_dmem_i),
            .wd_data_mem_i(write_data_m),
            .rd_data_mem_o(read_data_m)
        );


    //forwarding 

    assign rd1_reg_file_e_fwd   =   (forward_1e_i == 2'b00) ? rd1_reg_file_e            : 
                                    (forward_1e_i == 2'b01) ? result_read_data_w        :
                                    (forward_1e_i == 2'b10) ? alu_result_m              :
                                    32'b0;          

    assign rd2_reg_file_e_fwd   =   (forward_2e_i == 2'b00) ? rd2_reg_file_e            : 
                                    (forward_2e_i == 2'b01) ? result_read_data_w        :
                                    (forward_2e_i == 2'b10) ? alu_result_m              :
                                    32'b0;      

    //-------------------------------------------

    assign op_code_o                =   instruction_d[6:0];
    assign funct3_o                 =   instruction_d[14:12];
    assign funct7_o                 =   instruction_d[30];
    assign alu_src_a                =   (alu_src_i[1]) ? pc_o_e : rd1_reg_file_e_fwd;   // ???
    assign alu_src_b                =   (alu_src_i[0]) ? imm_ext_o_e : rd2_reg_file_e_fwd;  
    assign pc_target                =    pc_target_s_i ? (imm_ext_o_e + alu_src_a) : (imm_ext_o_e + pc_o_e );



    assign result_read_data_w       =   (result_src_i == 2'b00) ? alu_result_w : 
                                        (result_src_i == 2'b01) ? read_data_w :
                                        (result_src_i == 2'b10) ? pcplus4_w :
                                        32'b0;


    assign pc_next_i            =   pc_src_i ? pc_target  : (pc_o_f + 4) ;

  



    // outs for hazard unit
    assign rs_1_e_o = rs1_e;
    assign rs_2_e_o = rs2_e;
    assign rd_e_o   = rd_e;
    assign rd_m_o   = rd_m;
    assign rd_w_o   = rd_w;


    assign rs_1_d_o = instruction_d[19:15];
    assign rs_2_d_o = instruction_d[24:20];




    /*integer file;
    initial begin
        file = $fopen("C:/Users/omer.enen/Documents/vivado_projects/rv32i/rv32i.srcs/sources_1/imports/srcs/logs.txt", "w");
    
    end

    integer space_c;
    always @(negedge clk ) begin
        if(instruction[11:7] > 9)
        begin
            space_c = 1;
        end else begin
            space_c =2;
        end


        case (op_code_o)
            `OPCODE_R_TYPE: begin
                if(instruction[11:7] > 9)
                begin
                    $fwrite(file, "core   0: 3 0x%x (0x%x) x%-2d %2s%x\n", pc_o, instruction, instruction[11:7], "0x", alu_result);

                end else begin
                    $fwrite(file, "core   0: 3 0x%x (0x%x) x%-1d %3s%x\n", pc_o, instruction, instruction[11:7], "0x", alu_result);

                end

            end

            `OPCODE_I_TYPE_IMM: begin
                if(instruction[11:7] ==0)begin
                    $fwrite(file, "core   0: 3 0x%x (0x%x)\n", pc_o, instruction);
                end else begin
                    if(instruction[11:7] > 9)
                    begin
                        $fwrite(file, "core   0: 3 0x%x (0x%x) x%-2d %2s%x\n", pc_o, instruction, instruction[11:7], "0x", alu_result);

                    end else begin
                        $fwrite(file, "core   0: 3 0x%x (0x%x) x%-1d %3s%x\n", pc_o, instruction, instruction[11:7], "0x", alu_result);

                    end
                end
            end

            `OPCODE_I_TYPE_LOAD: begin
                if(instruction[11:7] ==0)begin
                    $fwrite(file, "core   0: 3 0x%x (0x%x)\n", pc_o, instruction);
                end else begin
                    if(instruction[11:7] > 9)
                    begin
                        $fwrite(file, "core   0: 3 0x%x (0x%x) x%-2d %2s%x mem 0x%x\n", pc_o, instruction, instruction[11:7], "0x", result_read_data,  alu_result);

                    end else begin
                        $fwrite(file, "core   0: 3 0x%x (0x%x) x%-1d %3s%x mem 0x%x\n", pc_o, instruction, instruction[11:7], "0x", result_read_data, alu_result);

                    end
                end
            end

            `OPCODE_I_TYPE_JALR: begin
                if(instruction[11:7] ==0)begin
                    $fwrite(file, "core   0: 3 0x%x (0x%x)\n", pc_o, instruction);
                end else begin
                    if(instruction[11:7] > 9)
                    begin
                        $fwrite(file, "core   0: 3 0x%x (0x%x) x%-2d %2s%x\n", pc_o, instruction, instruction[11:7], "0x", result_read_data);

                    end else begin
                        $fwrite(file, "core   0: 3 0x%x (0x%x) x%-1d %3s%x\n", pc_o, instruction, instruction[11:7], "0x", result_read_data);

                    end
                    
                end
            end

            `OPCODE_U_TYPE_AUIPC: begin
                $fwrite(file, "core   0: 3 0x%x (0x%x) x%-1d %3s%x\n", pc_o, instruction, instruction[11:7], "0x", alu_result);
            end

            `OPCODE_U_TYPE_LUI: begin
                $fwrite(file, "core   0: 3 0x%x (0x%x) x%-1d %3s%x\n", pc_o, instruction, instruction[11:7], "0x", alu_result);
            end

            `OPCODE_S_TYPE: begin
                $fwrite(file, "core   0: 3 0x%x (0x%x) mem 0x%x 0x%x\n", pc_o, instruction, alu_result, rd2_reg_file_d);
            end

            `OPCODE_B_TYPE: begin
                $fwrite(file, "core   0: 3 0x%x (0x%x)\n", pc_o, instruction);
            end

            `OPCODE_J_TYPE_JAL: begin
                if(instruction[11:7] ==0)begin
                    $fwrite(file, "core   0: 3 0x%x (0x%x)\n", pc_o, instruction);
                end else begin
                    $fwrite(file, "core   0: 3 0x%x (0x%x) x%-1d %3s%x\n", pc_o, instruction, instruction[11:7], "0x", result_read_data);
                end
            end

            default: begin
                    $fwrite(file, "core   0: 3 0x%x (0x%x) x%-1d %3s%x\n", pc_o, instruction, instruction[11:7], "0x", alu_result);
            end

        endcase
   end*/
endmodule
