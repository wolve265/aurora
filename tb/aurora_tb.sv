`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07.01.2023 19:07:34
// Design Name:
// Module Name: aurora_tb
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

import aurora_pkg::*;

module aurora_tb();
    logic clk = 1'b0;
    logic rst_n = 1'b1;
    logic single_lane = 1'b1;
    logic [MAX_LINKS_SIZE-1:0] lane_select = 2'b01;
    logic axi_valid,
    logic axi_last,
    logic [AXI_DATA_SIZE-1:0] axi_data,
    logic simplex_aligned,
    logic simplex_bonded,
    logic simplex_verified,
    logic simplex_reset,
    logic [MAX_LINKS-1:0][ENCODED_DATA_SIZE-1:0] data_out;

    aurora_top i_aurora_top(
        .clk,
        .rst_n,
        .single_lane,
        .lane_select,
        .axi_valid,
        .axi_last,
        .axi_data,
        .simplex_aligned,
        .simplex_bonded,
        .simplex_verified,
        .simplex_reset,
        .data_out
    );

    always #2.5 clk = ~clk;

endmodule
