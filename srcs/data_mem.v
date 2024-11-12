`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 25.09.2024 11:23:35
// Design Name:
// Module Name: data_mem
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

module data_mem(
        input                   clk,
        input                   we_data_mem_i,
        input           [31:0]  a_data_mem_i,
        input           [31:0]  wd_data_mem_i,
        input           [2:0]   rw_type_dmem_i, //

        output  reg     [31:0]  rd_data_mem_o
    );

    reg [31:0] data_memory [`LOWER_DATA_MEM:`UPPER_DATA_MEM];

    integer file2;

    initial begin
        file2 = $fopen("C:/Users/omer.enen/Documents/vivado_projects/rv32i/rv32i.srcs/sources_1/imports/srcs/mem_logs2.txt", "w");
        $fwrite(file2, "OMER 4 KASIM");
    end


    always @(negedge clk) begin
        if(we_data_mem_i) begin


            $fwrite(file2, "%x 0x%x\n", a_data_mem_i, wd_data_mem_i);


            case (rw_type_dmem_i)
                3'b000: begin
                    //store byte
                    data_memory[a_data_mem_i[31:2]][7:0] <= wd_data_mem_i[7:0];
                end 

                3'b001: begin
                    //store half
                    data_memory[a_data_mem_i[31:2]][15:0] <= wd_data_mem_i[15:0];

                end 
                3'b010: begin
                    //store word
                    data_memory[a_data_mem_i[31:2]][31:0] <= wd_data_mem_i;
                end 
            
            default: data_memory[a_data_mem_i[31:2]][31:0] <= 32'b0;
            endcase   


        end
    end

    always @(*) begin
        if(!we_data_mem_i)
        begin
            case (rw_type_dmem_i)
            3'b000: begin
                //signext load byte
                rd_data_mem_o = {{24{data_memory[a_data_mem_i[31:2]][7]}}, data_memory[a_data_mem_i][7:0]};
            end 

            3'b001: begin
                //signext load half
                rd_data_mem_o = {{24{data_memory[a_data_mem_i[31:2]][15]}}, data_memory[a_data_mem_i][15:0]};

            end 
            3'b010: begin
                //load word
                rd_data_mem_o = data_memory[a_data_mem_i[31:2]];
            end 
            3'b100: begin
                rd_data_mem_o = {{24{1'b0}}, data_memory[a_data_mem_i[31:2]][7:0]};
            
            end 
            3'b101: begin
                
                rd_data_mem_o = {{24{1'b0}}, data_memory[a_data_mem_i[31:2]][15:0]};

            end 
            default: rd_data_mem_o = 32'b0;
            endcase   
        end
        
    end
    
    
    
    //assign rd_data_mem_o = (!we_data_mem_i) ? data_memory[a_data_mem_i] : 0;

     
    

endmodule
