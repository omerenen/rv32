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


module hazard_unit(
        input  [4:0]  rs_1_e_i,
        input  [4:0]  rs_2_e_i,
        input  [4:0]  rd_e_i,
        input  [4:0]  rs_1_d_i,
        input  [4:0]  rs_2_d_i,
        
        input          pc_src_e_i,
        input          result_src_e_i,

        input  [4:0]  rd_m_i,
        input  [4:0]  rd_w_i,
        input          we_reg_file_m_i,
        input          we_reg_file_w_i,
        
        output         stall_f_o,
        output         stall_d_o,
        output         flush_d_o,
        output         flush_e_o,

        output  [1:0]  forward_1e_o,
        output  [1:0]  forward_2e_o

    );

    
    reg     lw_stall;

    reg [1:0] forward_1e;
    reg [1:0] forward_2e;


    always @(*) begin
        if(((rs_1_e_i == rd_m_i) & we_reg_file_m_i) & (rs_1_e_i != 0)) begin
            forward_1e = 2'b10;
        end else if(((rs_1_e_i == rd_w_i) & we_reg_file_w_i) & (rs_1_e_i != 0)) begin
            forward_1e = 2'b01;
        end else begin 
            forward_1e = 2'b00;
        end
    end

    always @(*) begin
        if(((rs_2_e_i == rd_m_i) & we_reg_file_m_i) & (rs_2_e_i != 0)) begin
            forward_2e = 2'b10;
        end else if(((rs_2_e_i == rd_w_i) & we_reg_file_w_i) & (rs_2_e_i != 0)) begin
            forward_2e = 2'b01;
        end else begin 
            forward_2e = 2'b00;
        end
    end

    always @(*) begin
        lw_stall = result_src_e_i & ((rs_1_d_i == rd_e_i) | (rs_1_d_i == rd_e_i));
    end

    // forwarding 
    assign forward_1e_o = forward_1e;
    assign forward_2e_o = forward_2e;


    // load hazards
    assign stall_f_o = lw_stall;
    assign stall_d_o = lw_stall;


    // flushes
    assign flush_d_o = pc_src_e_i;
    assign flush_e_o = lw_stall | pc_src_e_i;




endmodule
