`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02.01.2023 19:14:17
// Design Name:
// Package Name: simplex_operations_if
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


interface simplex_operations_if;

    logic aligned;
    logic bonded;
    logic verified;
    logic reset;

    modport TX (
        input aligned,
        input bonded,
        input verified,
        input reset
    );

    modport RX (
        output aligned,
        output bonded,
        output verified,
        output reset
    );

endinterface : simplex_operations_if
