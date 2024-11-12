`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.09.2024 14:19:11
// Design Name: 
// Module Name: imm_ext
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


module imm_ext(
    input   [31:0]  imm_ext_i,
    input   [2:0]   imm_src_i,
    output  [31:0]  imm_ext_o
    );

    
    /*
    000 -> I TYPE
    001 -> S TYPE
    010 -> B TYPE
    011 -> U TYPE
    100 -> J Type
    */

    assign imm_ext_o =  (imm_src_i == 3'b000) ? {{20{imm_ext_i[31]}}, imm_ext_i[31:20]}:
                        (imm_src_i == 3'b001) ? {{20{imm_ext_i[31]}}, imm_ext_i[31:25], imm_ext_i[11:7]} :
                        (imm_src_i == 3'b010) ? {{20{imm_ext_i[31]}}, imm_ext_i[7], imm_ext_i[30:25], imm_ext_i[11:8], 1'b0} :
                        (imm_src_i == 3'b011) ? {{imm_ext_i[31:12]}, {12{1'b0}}} :
                        (imm_src_i == 3'b100) ? {{12{imm_ext_i[31]}}, imm_ext_i[19:12], imm_ext_i[20], imm_ext_i[30:21], 1'b0} :

                        32'd0;
    
endmodule
