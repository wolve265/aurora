`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07.02.2023 22:23:02
// Design Name:
// Module Name: ordered_sets_encoder
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
//  - This module always waits for the end of current sequence, then loads next one.
//
//////////////////////////////////////////////////////////////////////////////////

import aurora_pkg::*;

module ordered_sets_encoder (
    input logic clk,
    input logic rst_n,
    input ordered_sets_e ordered_sets,
    output logic [INTERMEDIATE_DATA_SIZE-1:0] encoded_sequence
    );

    localparam MAX_SEQUENCE_LEN = 4;

    logic [MAX_SEQUENCE_LEN*INTERMEDIATE_DATA_SIZE-1:0] encoded_sequence_buffer, encoded_sequence_buffer_nxt;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            encoded_sequence_buffer <= '0;
        end else begin
            encoded_sequence_buffer <= encoded_sequence_buffer_nxt;
        end
    end

    assign encoded_sequence = encoded_sequence_buffer[INTERMEDIATE_DATA_SIZE-1:0];

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

    always_comb begin
        encoded_sequence_buffer_nxt = '0;

        // if there is something to be shifted, then shift
        if (encoded_sequence_buffer[MAX_SEQUENCE_LEN*INTERMEDIATE_DATA_SIZE-1:INTERMEDIATE_DATA_SIZE]) begin
            encoded_sequence_buffer_nxt = encoded_sequence_buffer >> INTERMEDIATE_DATA_SIZE;
        // otherwise load next data based on input
        end else begin
            case (ordered_sets)
                I: begin
                    // TODO: Idle generator
                end
                SP: begin
                    encoded_sequence_buffer_nxt = 'b010_01010_010_01010_010_01010_101_11100;
                end
                SPA: begin
                    encoded_sequence_buffer_nxt = 'b001_01100_001_01100_001_01100_101_11100;
                end
                VER: begin
                    encoded_sequence_buffer_nxt = 'b111_01000_111_01000_111_01000_101_11100;
                end
                SCP: begin
                    encoded_sequence_buffer_nxt = 'b111_11011_010_11100;
                end
                ECP: begin
                    encoded_sequence_buffer_nxt = 'b111_11110_111_11101;
                end
                P, SUF: begin
                    encoded_sequence_buffer_nxt = 'b100_11100;
                end
                K: begin
                    encoded_sequence_buffer_nxt = 'b101_11100;
                end
                R: begin
                    encoded_sequence_buffer_nxt = 'b000_11100;
                end
                A: begin
                    encoded_sequence_buffer_nxt = 'b011_11100;
                end
                CC: begin
                    encoded_sequence_buffer_nxt = 'b111_10111_111_10111;
                end
                SNF: begin
                    encoded_sequence_buffer_nxt = 'b110_11100;
                end
                default: begin
                    encoded_sequence_buffer_nxt = '0;
                end
            endcase
        end
    end

endmodule
