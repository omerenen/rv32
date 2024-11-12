`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 25.09.2024 11:39:05
// Design Name:
// Module Name: program_counter
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


module program_counter(
        input               clk, en,
        input  [31:0]       pc_next_i,
        output [31:0]       pc_o
    );


    reg [31:0] pc_reg = 32'h80000000;
    
    always @(posedge clk) begin
        pc_reg <= en ? pc_next_i : pc_reg;
    end

    assign pc_o = pc_reg;


endmodule
