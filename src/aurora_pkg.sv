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

`ifndef AURORA_PKG
`define AURORA_PKG

package aurora_pkg;

    `define MAX_LINKS 4
    `define MAX_LINKS_SIZE 2 // log2(MAX_LINKS)
    `define AXI_DATA_SIZE 64
    `define ENCODER_DATA_IN_SIZE 8
    `define ENCODER_DATA_OUT_SIZE 10

    `define SYS_TO_SINGLE_LINE_CLK_RATIO 8
    `define SYS_TO_MULTI_LINE_CLK_RATIO 2

    `define ORDERED_SEQUENCE_MAX_LEN 4
    `define ORDERED_SEQUENCE_SIZE `ORDERED_SEQUENCE_MAX_LEN * `ENCODER_DATA_IN_SIZE


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

    `define D08_7 8'b111_01000
    `define D10_2 8'b010_01010
    `define D12_1 8'b001_01100
    `define K23_7 8'b111_10111
    `define K27_7 8'b111_11011
    `define K28_0 8'b000_11100
    `define K28_2 8'b010_11100
    `define K28_3 8'b011_11100
    `define K28_4 8'b100_11100
    `define K28_5 8'b101_11100
    `define K28_6 8'b110_11100
    `define K29_7 8'b111_11101
    `define K30_7 8'b111_11110


    typedef enum logic [`ORDERED_SEQUENCE_SIZE-1:0] {
        NONE    = '0,   // just none
        I       = 'b01, // idle must be generated pseudo-randomly
        SP      = {    `D10_2, `D10_2, `D10_2, `K28_5},
        SPA     = {    `D12_1, `D12_1, `D12_1, `K28_5},
        VER     = {    `D08_7, `D08_7, `D08_7, `K28_5},
        SCP     = {'0, `K27_7, `K28_2},
        ECP     = {'0, `K30_7, `K29_7},
        P_SUF   = {'0, `K28_4},
        K       = {'0, `K28_5},
        R       = {'0, `K28_0},
        A       = {'0, `K28_3},
        CC      = {'0, `K23_7, `K23_7},
        SNF     = {'0, `K28_6}
    } ordered_sets_e;

endpackage

`endif
