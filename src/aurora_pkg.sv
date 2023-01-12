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

    typedef struct packed {
        logic I;
        logic SP;
        logic SPA;
        logic VER;
        logic SCP;
        logic ECP;
        logic P;
        logic SUF;
        logic K;
        logic R;
        logic A;
        logic CC;
        logic SNF;
    } ordered_sets_t;

endpackage