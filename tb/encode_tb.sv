`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07.02.2023 19:07:34
// Design Name:
// Module Name: encode_tb
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

// import aurora_pkg::*;

module encode_tb();
    logic clk = 1'b0;
    logic rst_n = 1'b1;

    logic [7:0]  data_i;
    logic        ctrl_i;
    logic        disp_i;  // 0 = neg disp; 1 = pos disp
    logic        disp_o;
    logic [9:0]  data_o;

    encode_8b10b i_encode_8b10b ( // parameter G_OREG=1
        .clk_i(clk),
        .rst_n_i(rst_n),
        .data_i,
        .ctrl_i,
        .disp_i,
        .data_o,
        .disp_o
    );

    always #2.5 clk = ~clk;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            disp_i <= 1;
        end else begin
            disp_i <= disp_o;
        end
    end

    initial begin
        #10;
        rst_n = 0;
        #10;
        rst_n = 1;
        // D19.7
        data_i = 'b111_10011;
        ctrl_i = 0;
        @(posedge clk);
        // FIXME: check why or don't work with assert
        assert(data_o == 'b110010_1110 || data_o == 'b110010_0001);

        #10;
        // K30.7
        data_i = 'b111_11110;
        ctrl_i = 1;
        @(posedge clk);
        // FIXME: check why or don't work with assert
        assert(data_o == 'b011110_1000 || data_o == 'b100001_0111);

    end

endmodule
