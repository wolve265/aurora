`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07.01.2023 19:07:34
// Design Name:
// Module Name: aurora_top_tb
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

module aurora_top_tb();
    logic clk = 1'b0;
    logic clk_data;
    logic rst_n = 1'b1;
    logic single_lane = 0;
    logic [`MAX_LINKS_SIZE-1:0] lane_select = 0;
    logic axi_valid = 0;
    logic axi_last = 0;
    logic [`AXI_DATA_SIZE-1:0] axi_data = '0;
    logic simplex_aligned = 0;
    logic simplex_bonded = 0;
    logic simplex_verified = 0;
    logic simplex_reset = 0;
    logic [`MAX_LINKS-1:0][`ENCODER_DATA_OUT_SIZE-1:0] data_out;

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

    initial begin : reset_block
        rst_n = 0;
        #10;
        rst_n = 1;
        #10;
    end : reset_block

    initial begin
        single_lane = 1;
        lane_select = 2;
        #20; // wait reset done
        repeat(5)
            @(negedge clk);
        simplex_aligned = 1;
        repeat(5)
            @(negedge clk);
        simplex_verified = 1;

        // TODO: data generation
    end

endmodule
