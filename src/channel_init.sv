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
    simplex_operations_if.TX simplex_operations,
    output ordered_sets_t ordered_sets,
    output logic init_finished
    );

    enum logic [2:0] {
        RESET,
        INIT,
        BONDING,
        VERIFICATION,
        READY
    } states_e;
endmodule