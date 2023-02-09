`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02.01.2023 18:23:02
// Design Name:
// Module Name: aurora_pkg
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


package aurora_pkg;

    parameter MAX_LINKS = 4;
    parameter MAX_LINKS_SIZE = 2; // log2(MAX_LINKS)
    parameter AXI_DATA_SIZE = 64;
    parameter ENCODED_DATA_SIZE = 10;
    parameter INTERMEDIATE_DATA_SIZE = 8;

    parameter ORDERED_SETS_NUM = 13;
    parameter ORDERED_SETS_SIZE = 4; // log2(ORDERED_SETS_NUM)


    typedef enum logic [ORDERED_SETS_SIZE-1:0] {
        NONE, I, SP, SPA, VER, SCP, ECP, P, SUF, K, R, A, CC, SNF
    } ordered_sets_e;

endpackage
