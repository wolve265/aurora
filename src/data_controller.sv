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


module data_controller(
    input logic clk,
    input logic rst_n,
    input logic single_lane,
    input logic [MAX_LINKS_SIZE-1:0] lane_select,
    input logic channel_init_finished,
    input ordered_sets_t ordered_sets,
    input logic axi_valid,
    input logic axi_last,
    input logic [AXI_DATA_SIZE-1:0] axi_data,
    output logic [MAX_LINKS-1:0][INTERMEDIATE_DATA_SIZE-1:0] data_out
    );
endmodule
