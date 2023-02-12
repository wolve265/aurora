`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09.02.2023 22:23:02
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
    input logic [`MAX_LINKS_SIZE-1:0] lane_select,
    input ordered_sets_e ordered_sets,
    input logic [`AXI_DATA_SIZE-1:0] data_in,
    output logic [`MAX_LINKS-1:0] ctrl_out,
    output logic [`MAX_LINKS-1:0][`ENCODER_DATA_IN_SIZE-1:0] data_out
    );

    ordered_sets_e idle_ordered_sets;
    logic idle_enabled, send_idle, send_K, send_R, send_A;
    assign idle_enabled = (ordered_sets == I) | (single_lane == 0 & (ordered_sets == SCP | ordered_sets == ECP));
    assign send_idle = (ordered_sets == I);
    assign idle_ordered_sets = send_K ? K : send_R ? R : send_A ? A : NONE;

    logic [`AXI_DATA_SIZE-1:0] data_to_send;
    assign data_to_send = send_idle ? idle_ordered_sets : ordered_sets ? ordered_sets : data_in;

    logic [3:0] counter, counter_nxt, data_counter_max;
    assign data_counter_max = single_lane ? `SYS_TO_SINGLE_LINE_CLK_RATIO : `SYS_TO_MULTI_LINE_CLK_RATIO;

    logic [`MAX_LINKS-1:0] ctrl_out_nxt;
    logic [`MAX_LINKS-1:0][`ENCODER_DATA_IN_SIZE-1:0] data_out_nxt;

    idle_generator i_idle_generator(
        .clk,
        .rst_n,
        .send_idle(idle_enabled),
        .send_K,
        .send_A,
        .send_R
    );

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            ctrl_out <= '0;
            data_out <= '0;
            counter <= '0;
        end else begin
            ctrl_out <= ctrl_out_nxt;
            data_out <= data_out_nxt;
            counter <= counter_nxt;
        end
    end

    always_comb begin
        ctrl_out_nxt = '0;
        data_out_nxt = '0;
        counter_nxt = counter + 1;

        if (single_lane) begin : single_lane_block
            if (ordered_sets) begin : single_lane_ordered_sets
                data_out_nxt[lane_select] = data_to_send[counter*`ENCODER_DATA_IN_SIZE+:`ENCODER_DATA_IN_SIZE];

                if (ordered_sets[`ENCODER_DATA_IN_SIZE:0] == `K28_5 && counter > 0) begin
                    ctrl_out_nxt[lane_select] = 0;
                end else begin
                    ctrl_out_nxt[lane_select] = 1;
                end

                if (counter_nxt == `ORDERED_SEQUENCE_MAX_LEN
                || !data_to_send[counter_nxt*`ENCODER_DATA_IN_SIZE+:`ENCODER_DATA_IN_SIZE]) begin
                    counter_nxt = '0;
                end
            end : single_lane_ordered_sets
            else begin : single_lane_data
                data_out_nxt[lane_select] = data_to_send[counter*`ENCODER_DATA_IN_SIZE+:`ENCODER_DATA_IN_SIZE];
                if (counter_nxt == data_counter_max) begin
                    counter_nxt = '0;
                end
            end : single_lane_data
        end : single_lane_block
        else begin : multi_lane_block
            if (ordered_sets) begin : multi_lane_ordered_sets
                data_out_nxt[0] = data_to_send[counter*`ENCODER_DATA_IN_SIZE+:`ENCODER_DATA_IN_SIZE];
                data_out_nxt[1] = data_to_send[counter*`ENCODER_DATA_IN_SIZE+:`ENCODER_DATA_IN_SIZE];
                data_out_nxt[2] = data_to_send[counter*`ENCODER_DATA_IN_SIZE+:`ENCODER_DATA_IN_SIZE];
                data_out_nxt[3] = data_to_send[counter*`ENCODER_DATA_IN_SIZE+:`ENCODER_DATA_IN_SIZE];

                if (ordered_sets == SCP) begin
                    data_out_nxt[0] = idle_ordered_sets;
                    data_out_nxt[1] = idle_ordered_sets;
                    data_out_nxt[2] = idle_ordered_sets;
                    data_out_nxt[3] = data_to_send[counter*`ENCODER_DATA_IN_SIZE+:`ENCODER_DATA_IN_SIZE];
                    ctrl_out_nxt[3] = 1;
                end else if (ordered_sets == ECP) begin
                    data_out_nxt[0] = data_to_send[counter*`ENCODER_DATA_IN_SIZE+:`ENCODER_DATA_IN_SIZE];
                    data_out_nxt[1] = idle_ordered_sets;
                    data_out_nxt[2] = idle_ordered_sets;
                    data_out_nxt[3] = idle_ordered_sets;
                    ctrl_out_nxt[0] = 1;
                end else if (ordered_sets[`ENCODER_DATA_IN_SIZE:0] == `K28_5 && counter > 0) begin
                    ctrl_out_nxt = '0;
                end else begin
                    ctrl_out_nxt = '1;
                end

                if (counter_nxt == `ORDERED_SEQUENCE_MAX_LEN
                || !data_to_send[counter_nxt*`ENCODER_DATA_IN_SIZE+:`ENCODER_DATA_IN_SIZE]) begin
                    counter_nxt = '0;
                end
            end : multi_lane_ordered_sets
            else begin : multi_lane_data
                data_out_nxt[0] = data_to_send[(counter*`MAX_LINKS+0)*`ENCODER_DATA_IN_SIZE+:`ENCODER_DATA_IN_SIZE];
                data_out_nxt[1] = data_to_send[(counter*`MAX_LINKS+1)*`ENCODER_DATA_IN_SIZE+:`ENCODER_DATA_IN_SIZE];
                data_out_nxt[2] = data_to_send[(counter*`MAX_LINKS+2)*`ENCODER_DATA_IN_SIZE+:`ENCODER_DATA_IN_SIZE];
                data_out_nxt[3] = data_to_send[(counter*`MAX_LINKS+3)*`ENCODER_DATA_IN_SIZE+:`ENCODER_DATA_IN_SIZE];
                if (counter_nxt == data_counter_max) begin
                    counter_nxt = '0;
                end
            end : multi_lane_data
        end : multi_lane_block
    end

endmodule
