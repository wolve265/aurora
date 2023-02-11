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
    input logic rst_n,
    input logic single_lane,
    output logic clk_out
    );

    logic [1:0] counter, counter_init;
    // N/2-1  | clk_in / N
    //   3    | clk_in / 8
    //   0    | clk_in / 2
    assign counter_init = single_lane ? 3 : 0;

    always_ff @(posedge clk_in) begin
        if (!rst_n) begin
            counter <= counter_init;
            clk_out <= 0;
        end else begin
            if (counter == counter_init) begin
                clk_out <= ~clk_out;
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule
