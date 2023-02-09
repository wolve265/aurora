`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 08.02.2023 19:07:34
// Design Name:
// Module Name: ordered_sets_encoder_tb
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

module ordered_sets_encoder_tb();
    logic clk = 1'b0;
    logic rst_n = 1'b1;
    ordered_sets_t ordered_sets = '0;
    logic [INTERMEDIATE_DATA_SIZE-1:0] encoded_sequence;

    ordered_sets_encoder i_ordered_sets_encoder(
        .clk,
        .rst_n,
        .ordered_sets,
        .encoded_sequence
    );

    always #2.5 clk = ~clk;

    initial begin
        #10;
        rst_n = 0;
        #10;
        rst_n = 1;
        ordered_sets = 1;
        for (int i = 0; i<13 ; i++) begin
            #25;
            ordered_sets = ordered_sets << 1;
        end
        #25;
    end

endmodule
