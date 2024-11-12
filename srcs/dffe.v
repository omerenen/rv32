`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2024 13:54:51
// Design Name: 
// Module Name: hazard_unit
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


module dffe #(parameter WIDTH = 32)(
    input   [WIDTH-1:0]  data_i,
    input                clk, rst, enable_i,
    output  [WIDTH-1:0]  data_o
    );

    reg [WIDTH-1:0] reg_ff;

    initial begin
        reg_ff = 0;
    end

    always @(posedge clk ) begin
        if(rst) begin
            reg_ff <= 0;
        end else begin
            if(enable_i) begin
                reg_ff <= data_i;
            end
        end
    end

    assign data_o  = reg_ff;
endmodule
