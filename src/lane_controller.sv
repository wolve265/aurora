`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09.01.2023 22:23:02
// Design Name:
// Module Name: lane_controller
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

module lane_controller(
    input logic clk,
    input logic rst_n,
    input logic single_lane,
    input logic [MAX_LINKS_SIZE-1:0] lane_select,
    input ordered_sets_e ordered_sets,
    input logic [AXI_DATA_SIZE-1:0] data_in,
    output logic [MAX_LINKS-1:0] ctrl_out,
    output logic [MAX_LINKS-1:0][ENCODER_DATA_IN_SIZE-1:0] data_out
    );

    logic send_idle, send_K, send_R, send_A;

    assign send_idle = (ordered_sets == I);

    idle_generator i_idle_generator(
        .clk,
        .rst_n,
        .send_idle,
        .send_K,
        .send_A,
        .send_R
    );

endmodule
