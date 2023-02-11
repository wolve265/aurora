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

    typedef enum logic [2:0] {
        IDLE,
        ORDERED_SETS1,
        ORDERED_SETS2,
        ORDERED_SETS3,
        ORDERED_SETS4,
        DATA
    } state_e;

    state_e state, state_nxt;

    logic [1:0] counter_50MHz;
    logic clk_400MHz, clk_200MHz, clk_50MHz, clk_data_in;
    assign clk_400MHz = clk;
    assign clk_data_in = single_lane ? clk_50MHz : clk_200MHz;

    logic ctrl_enabled, ctrl_enabled_nxt;
    logic [MAX_LINKS-1:0] ctrl_out_nxt;
    logic [MAX_LINKS-1:0][ENCODER_DATA_IN_SIZE-1:0] data_out_nxt;

    logic send_idle, send_K, send_R, send_A;
    assign send_idle = (ordered_sets == I);

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            ctrl_out <= '0;
            data_out <= '0;
            ctrl_enabled <= '0;
            state <= IDLE;
        end else begin
            ctrl_out <= ctrl_out_nxt;
            data_out <= data_out_nxt;
            ctrl_enabled <= ctrl_enabled_nxt;
            state <= state_nxt;
        end
    end





    idle_generator i_idle_generator(
        .clk,
        .rst_n,
        .send_idle,
        .send_K,
        .send_A,
        .send_R
    );

    always_ff @(posedge clk_400MHz) begin : clk_200MHz_generator
        if (!rst_n) begin
            clk_200MHz <= 0;
        end else begin
            clk_200MHz <= ~clk_200MHz;
        end
    end : clk_200MHz_generator

    always_ff @(posedge clk_400MHz) begin : clk_50MHz_generator
        if (!rst_n) begin
            counter_50MHz <= 3;
            clk_50MHz <= 0;
        end else begin
            if (counter_50MHz == 3) begin
                clk_50MHz <= ~clk_50MHz;
                counter_50MHz <= 0;
            end else begin
                counter_50MHz <= counter_50MHz+1;
            end
        end
    end : clk_50MHz_generator

endmodule
