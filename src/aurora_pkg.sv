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
    parameter ENCODER_DATA_IN_SIZE = 8;
    parameter ENCODER_DATA_OUT_SIZE = 10;

    parameter ORDERED_SEQUENCE_MAX_LEN = 4;


    // | Special|   Bits    |     RD-     |     RD+     |
    // |  Code  | HGF EDCBA | abcdef ghij | abcdef ghij |
    // |------------------------------------------------|
    // |  K23.7 | 111_10111 | 111010 1000 | 000101 0111 |
    // |  K27.7 | 111_11011 | 110110 1000 | 001001 0111 |
    // |  K28.0 | 000_11100 | 001111 0100 | 110000 1011 |
    // |  K28.2 | 010_11100 | 001111 0101 | 110000 1010 |
    // |  K28.3 | 011_11100 | 001111 0011 | 110000 1100 |
    // |  K28.4 | 100_11100 | 001111 0010 | 110000 1101 |
    // |  K28.5 | 101_11100 | 001111 1010 | 110000 0101 |
    // |  K28.6 | 110_11100 | 001111 0110 | 110000 1001 |
    // |  K29.7 | 111_11101 | 101110 1000 | 010001 0111 |
    // |  K30.7 | 111_11110 | 011110 1000 | 100001 0111 |

    parameter logic [7:0]
        D08_7 = 111_01000,
        D10_2 = 010_01010,
        D12_1 = 001_01100,
        K23_7 = 111_10111,
        K27_7 = 111_11011,
        K28_0 = 000_11100,
        K28_2 = 010_11100,
        K28_3 = 011_11100,
        K28_4 = 100_11100,
        K28_5 = 101_11100,
        K28_6 = 110_11100,
        K29_7 = 111_11101,
        K30_7 = 111_11110;


    typedef enum logic [ORDERED_SEQUENCE_MAX_LEN*ENCODER_DATA_IN_SIZE-1:0] {
        NONE    = '0,   // just none
        I       = 'b01, // idle must be generated pseudo-randomly
        SP      = {K28_5, D10_2, D10_2, D10_2},
        SPA     = {K28_5, D12_1, D12_1, D12_1},
        VER     = {K28_5, D08_7, D08_7, D08_7},
        SCP     = {K28_2, K27_7},
        ECP     = {K29_7, K30_7},
        P_SUF   = {K28_4},
        K       = {K28_5},
        R       = {K28_0},
        A       = {K28_3},
        CC      = {K23_7, K23_7},
        SNF     = {K28_6}
    } ordered_sets_e;

endpackage
