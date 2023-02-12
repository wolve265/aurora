`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11.02.2023 18:23:02
// Design Name:
// Module Name: clock_divider
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

module clock_divider(
    input logic clk_in,
    input logic single_lane,
    output logic clk_out
    );

    logic _clk = 0;
    logic [1:0] counter = 0;
    logic [1:0] counter_init;

    // N/2-1  | clk_in / N
    //   3    | clk_in / 8
    //   0    | clk_in / 2
    localparam SINGLE_LANE_COUNTER_INIT = `SYS_TO_SINGLE_LINE_CLK_RATIO/2-1;
    localparam MULTI_LANE_COUNTER_INIT = `SYS_TO_MULTI_LINE_CLK_RATIO/2-1;
    assign counter_init = single_lane ? SINGLE_LANE_COUNTER_INIT : MULTI_LANE_COUNTER_INIT;
    assign clk_out = _clk;

    always_ff @(posedge clk_in) begin
        if (counter == counter_init) begin
            _clk <= ~_clk;
            counter <= 0;
        end else begin
            _clk <= _clk;
            counter <= counter + 1;
        end
    end

endmodule
