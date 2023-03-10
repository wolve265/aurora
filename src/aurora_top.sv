`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02.01.2023 18:18:28
// Design Name:
// Module Name: aurora_top
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

module aurora_top (
    input logic clk,
    input logic rst_n,
    input logic single_lane,
    input logic [`MAX_LINKS_SIZE-1:0] lane_select,
    input logic axi_valid,
    input logic axi_last,
    input logic [`AXI_DATA_SIZE-1:0] axi_data,
    input logic simplex_aligned,
    input logic simplex_bonded,
    input logic simplex_verified,
    input logic simplex_reset,
    output logic [`MAX_LINKS-1:0][`ENCODER_DATA_OUT_SIZE-1:0] data_out
    );

    logic channel_init_finished;
    ordered_sets_e channel_init_ordered_sets;

    ordered_sets_e data_controller_ordered_sets;

    logic [`AXI_DATA_SIZE-1:0] lane_controller_data_in;
    ordered_sets_e lane_controller_ordered_sets;

    logic [`MAX_LINKS-1:0][`ENCODER_DATA_IN_SIZE-1:0] encoder_data_in;
    logic [`MAX_LINKS-1:0] encoder_ctrl_in;
    logic [`MAX_LINKS-1:0] disp_i, disp_o;

    assign lane_controller_ordered_sets = (
        channel_init_finished ? data_controller_ordered_sets : channel_init_ordered_sets
    );

    channel_initializer i_channel_initializer(
        .clk,
        .rst_n,
        .single_lane,
        .simplex_aligned,
        .simplex_bonded,
        .simplex_verified,
        .simplex_reset,
        .ordered_sets(channel_init_ordered_sets),
        .init_finished(channel_init_finished)
    );

    data_controller i_data_controller(
        .clk,
        .rst_n,
        .single_lane,
        .axi_valid,
        .axi_last,
        .axi_data,
        .ordered_sets(data_controller_ordered_sets),
        .data_out(lane_controller_data_in)
    );

    lane_controller i_lane_controller(
        .clk,
        .rst_n,
        .single_lane,
        .lane_select,
        .ordered_sets(lane_controller_ordered_sets),
        .data_in(lane_controller_data_in),
        .ctrl_out(encoder_ctrl_in),
        .data_out(encoder_data_in)
    );

    encoder i_encoder(
        .clk,
        .rst_n,
        .ctrl_in(encoder_ctrl_in),
        .data_in(encoder_data_in),
        .data_out
    );

endmodule
