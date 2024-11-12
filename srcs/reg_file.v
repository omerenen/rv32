`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 25.09.2024 11:23:54
// Design Name:
// Module Name: reg_file
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


module reg_file(
        input           clk, we_reg_file_i,
        input   [4:0]   a1_reg_file_i,
        input   [4:0]   a2_reg_file_i,
        input   [4:0]   a3_reg_file_i,
        input   [31:0]  wd_reg_file_i,
        output  [31:0]  rd1_reg_file_o,
        output  [31:0]  rd2_reg_file_o
    );


    reg [31:0] register_file [0:31];

    /* 
    initial begin
        register_file[0] = 32'd0;
        for (integer i = 0 ; i<32 ; i = i+1 ) begin
            register_file[i] =32'd0;
        end
    end */

    integer file;

    initial begin
        file = $fopen("C:/Users/omer.enen/Documents/vivado_projects/rv32i/rv32i.srcs/sources_1/imports/srcs/logs.txt", "w");
    
    end
 
    always @(negedge clk) begin

        if(we_reg_file_i && (a3_reg_file_i != 5'd0)) begin
            register_file[a3_reg_file_i] <= wd_reg_file_i;
            $fwrite(file, "x%-2d 0x%x\n", a3_reg_file_i, wd_reg_file_i);

        end
    end

    assign rd1_reg_file_o = register_file[a1_reg_file_i];
    assign rd2_reg_file_o = register_file[a2_reg_file_i];



endmodule
