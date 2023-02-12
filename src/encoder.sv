`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12.02.2023 20:18:28
// Design Name:
// Module Name: encoder
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

module encoder (
    input logic clk,
    input logic rst_n,
    input logic [`MAX_LINKS-1:0] ctrl_in,
    input logic [`MAX_LINKS-1:0][`ENCODER_DATA_IN_SIZE-1:0] data_in,
    output logic [`MAX_LINKS-1:0][`ENCODER_DATA_OUT_SIZE-1:0] data_out
    );

    logic [`MAX_LINKS-1:0] disp_i, disp_o;

    genvar i;
    generate
        for(i = 0; i < `MAX_LINKS; i++) begin
            encode_8b10b i_encode_8b10b(
                .clk_i(clk),
                .rst_n_i(rst_n),
                .ctrl_i(ctrl_in[i]),
                .disp_i(disp_i[i]),
                .data_i(data_in[i]),
                .data_o(data_out[i]),
                .disp_o(disp_o[i])
            );

            always_ff @(posedge clk) begin
                if (!rst_n) begin
                    disp_i[i] <= 1;
                end else begin
                    disp_i[i] <= disp_o[i];
                end
            end
        end
    endgenerate

endmodule
