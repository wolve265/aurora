`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02.01.2023 19:14:17
// Design Name:
// Package Name: axi_stream_if
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

interface axi_stream_if;

    logic valid;
    logic last;
    logic [63:0] data;

    modport slave (
        input valid,
        input last,
        input data
    );

    modport master (
        output valid,
        output last,
        output data
    );

endinterface : axi_stream_if
