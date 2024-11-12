`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 25.09.2024 14:32:55
// Design Name:
// Module Name: alu
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

module alu(
        input   signed        [31:0]   alu_src_a_i,
        input   signed        [31:0]   alu_src_b_i,
        input               [3:0]    alu_control_i,
        output  reg         [31:0]   alu_result_o,
        output  reg                  alu_zero_flag_o
    );




    always @(*) begin
        case (alu_control_i)
            `ADD         : alu_result_o = (alu_src_a_i) + (alu_src_b_i);
            `SUB         : alu_result_o = (alu_src_a_i) - (alu_src_b_i);
            `AND         : alu_result_o = alu_src_a_i & alu_src_b_i;
            `OR          : alu_result_o = alu_src_a_i | alu_src_b_i;
            `XOR         : alu_result_o = alu_src_a_i ^ (alu_src_b_i);
            `SLL         : alu_result_o = alu_src_a_i << alu_src_b_i;
            `SRL         : alu_result_o = alu_src_a_i >> alu_src_b_i;
            `SRA         : alu_result_o = $signed(alu_src_a_i) >>> alu_src_b_i[4:0] ;
            `LT          : begin
                alu_zero_flag_o = (alu_src_a_i < (alu_src_b_i)) ? 1: 0 ;
                alu_result_o = (alu_src_a_i < (alu_src_b_i)) ? 1: 0 ;
            end
            `LTU          : begin
                alu_zero_flag_o = ($unsigned(alu_src_a_i) < (alu_src_b_i)) ? 1: 0 ;

                alu_result_o = ($unsigned(alu_src_a_i) < (alu_src_b_i)) ? 1: 0 ;

            end
            `EQ          : begin
                alu_zero_flag_o = (alu_src_a_i == alu_src_b_i) ? 1: 0 ;
            end
            `NEQ         : begin
                alu_zero_flag_o = (alu_src_a_i != alu_src_b_i) ? 1: 0 ;
            end
            `GTE         : begin
                alu_zero_flag_o = (alu_src_a_i >= alu_src_b_i) ? 1: 0 ;
            end
            `GTEU         : begin
                alu_zero_flag_o = ($unsigned(alu_src_a_i) >= alu_src_b_i) ? 1: 0 ;
            end

            default: begin
                alu_zero_flag_o = 0;
                alu_result_o = 32'b0;
            end 

        endcase
    end




endmodule
