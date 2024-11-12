`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 25.09.2024 11:23:54
// Design Name:
// Module Name: inst_mem
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

module inst_mem(
        input   [31:0]  i_adress_i,
        output  [31:0]  i_read_o
    );

    reg [31:0] instruction_memory [`LOWER_INST_MEM:`UPPER_INST_MEM];


    initial begin
        $readmemh("/home/omer/Documents/digital_design/rv32/rv32.srcs/sources_1/imports/rv32ipipeline/instructions.mem", instruction_memory);
    end

    assign i_read_o = instruction_memory[i_adress_i[31:2]];

endmodule
