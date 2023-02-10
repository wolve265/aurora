`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02.01.2023 18:23:02
// Design Name:
// Module Name: data_controller
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

module data_controller(
    input logic clk,
    input logic rst_n,
    input logic single_lane,
    input logic axi_valid,
    input logic axi_last,
    input logic [AXI_DATA_SIZE-1:0] axi_data,
    output ordered_sets_e ordered_sets,
    output logic [AXI_DATA_SIZE-1:0] data_out
    );
endmodule
