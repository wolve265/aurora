`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02.01.2023 18:23:02
// Design Name:
// Module Name: channel_init
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

module channel_init (
    input logic clk,
    input logic rst_n,
    input logic single_lane,
    input logic simplex_aligned,
    input logic simplex_bonded,
    input logic simplex_verified,
    input logic simplex_reset,
    output ordered_sets_t ordered_sets,
    output logic init_finished
);

typedef enum logic [2:0] {
    RESET,
    INIT,
    BONDING,
    VERIFICATION,
    READY
} states_e;

ordered_sets_t ordered_sets_nxt;
states_e state, state_nxt;
logic init_finished_nxt;

always_ff @(posedge clk) begin
    if (!rst_n || simplex_reset) begin
        state <= RESET;
        ordered_sets <= ordered_sets_nxt;
        init_finished <= init_finished_nxt;
    end
    else begin
        state <= state_nxt;
        ordered_sets <= ordered_sets_nxt;
        init_finished <= init_finished_nxt;
    end
end

always_comb begin : StateMachine
    state_nxt = state;
    ordered_sets_nxt = 0;
    init_finished_nxt = 0;
    case(state)
        RESET: begin
            ordered_sets_nxt.SP = 1;
            state_nxt = INIT;
        end
        INIT: begin
            ordered_sets_nxt.SP = 1;
            if (simplex_aligned) begin
                if (single_lane) begin
                    state_nxt = VERIFICATION;
                end
                else begin
                    state_nxt = BONDING;
                end
            end
        end
        BONDING: begin
            ordered_sets_nxt.I = 1;
            if (simplex_bonded) begin
                state_nxt = VERIFICATION;
            end
        end
        VERIFICATION: begin
            ordered_sets_nxt.VER = 1;
            if (simplex_verified) begin
                state_nxt = READY;
            end
        end
        READY: begin
            init_finished_nxt = 1;
        end
        default: begin
            state_nxt = state;
        end
    endcase
end : StateMachine

endmodule
