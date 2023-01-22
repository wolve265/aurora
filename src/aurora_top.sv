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

module aurora_top(
    input logic clk,
    input logic rst_n,
    input logic single_lane,
    input logic [MAX_LINKS_SIZE-1:0] lane_select,
    axi_stream_if.slave axi_stream,
    input logic simplex_aligned,
    input logic simplex_bonded,
    input logic simplex_verified,
    input logic simplex_reset,
    output logic [MAX_LINKS-1:0][ENCODED_DATA_SIZE-1:0] data_out
    );

    logic channel_init_finished;
    ordered_sets_t ordered_sets;
    logic [MAX_LINKS-1:0][INTERMEDIATE_DATA_SIZE-1:0] intermediate_data;

    channel_init i_channel_init(
        .clk,
        .rst_n,
        .single_lane,
        .simplex_aligned
        .simplex_bonded
        .simplex_verified
        .simplex_reset
        .ordered_sets,
        .init_finished(channel_init_finished)
    );

    data_controller i_data_controller(
        .clk,
        .rst_n,
        .single_lane,
        .lane_select,
        .channel_init_finished,
        .ordered_sets,
        .axi_stream,
        .tx_data(intermediate_data)
    );

    genvar i;
    generate
        for(i = 0; i < MAX_LINKS; i++)begin
            encode_8b10b i_encode_8b10b(
                .clk_i(clk),
                .rst_n_i(rst_n),
                .ctrl_i(),
                .disp_i(1'b0),
                .data_i(intermediate_data[i]),
                .data_o(data_out[i]),
                .disp_o()
            );
        end
    endgenerate

endmodule
