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
    input logic clk_data,
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
    logic [0:ORDERED_SEQUENCE_MAX_LEN-1][ENCODER_DATA_IN_SIZE-1:0] ordered_sets_array;
    assign ordered_sets_array = ordered_sets;

    logic ctrl_enabled, ctrl_enabled_nxt;
    logic [MAX_LINKS-1:0] ctrl_out_nxt;
    logic [MAX_LINKS-1:0][ENCODER_DATA_IN_SIZE-1:0] data_out_nxt;

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

    always_comb begin
        state_nxt = state;
        ctrl_enabled_nxt = ctrl_enabled;
        ctrl_out_nxt = ctrl_enabled ? '1 : '0;
        data_out_nxt = '0;
        case (state)
            IDLE: begin
                if (ordered_sets_array) begin
                    ctrl_enabled_nxt = 1;
                    state_nxt = ORDERED_SETS1;
                end
            end
            ORDERED_SETS1: begin
                data_out_nxt[lane_select] = ordered_sets_array[0];
                if (ordered_sets_array[0] == K28_5) begin
                    ctrl_enabled_nxt = 0;
                end
                if (ordered_sets_array[1]) begin
                    state_nxt = ORDERED_SETS2;
                end else begin
                    state_nxt = IDLE;
                end
            end
            ORDERED_SETS2: begin
                data_out_nxt[lane_select] = ordered_sets_array[1];
                if (ordered_sets_array[2]) begin
                    state_nxt = ORDERED_SETS3;
                end else begin
                    state_nxt = IDLE;
                end
            end
            ORDERED_SETS3: begin
                data_out_nxt[lane_select] = ordered_sets_array[2];
                if (ordered_sets_array[3]) begin
                    state_nxt = ORDERED_SETS4;
                end else begin
                    state_nxt = IDLE;
                end
            end
            ORDERED_SETS4: begin
                data_out_nxt[lane_select] = ordered_sets_array[3];
                state_nxt = IDLE;
            end
            DATA: begin
                // TODO:
            end
            default: begin
                state_nxt = state;
            end
        endcase
    end

endmodule
