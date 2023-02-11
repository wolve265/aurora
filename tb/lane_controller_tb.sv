`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11.02.2023 15:07:34
// Design Name:
// Module Name: lane_controller_tb
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

module lane_controller_tb();
    logic clk_400MHz = 1'b0;
    logic clk_200MHz = 1'b0;
    logic clk_50MHz = 1'b0;
    logic rst_n = 1'b1;
    logic single_lane = '0;
    logic [MAX_LINKS_SIZE-1:0] lane_select = '0;
    logic [AXI_DATA_SIZE-1:0] data_in = '0;
    ordered_sets_e ordered_sets = NONE;
    logic [MAX_LINKS-1:0] ctrl_out;
    logic [MAX_LINKS-1:0][ENCODER_DATA_IN_SIZE-1:0] data_out;

    lane_controller i_lane_controller(
        .clk(clk_400MHz),
        .rst_n,
        .single_lane,
        .lane_select,
        .ordered_sets,
        .data_in,
        .ctrl_out(encoder_ctrl_in),
        .data_out(encoder_data_in)
    );

    always #2.5 clk_400MHz = ~clk_400MHz;
    always #5   clk_200MHz = ~clk_200MHz;
    always #20  clk_50MHz  = ~clk_50MHz;

    initial begin : reset_block
        #10;
        rst_n = 0;
        #10;
        rst_n = 1;
        #10;
    end : reset_block

    initial begin : stimulus
        int repeat_num;
        #30; // wait reset done
        #200;
        single_lane = 1;
    end : stimulus

endmodule
