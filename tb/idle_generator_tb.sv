`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09.02.2023 15:07:34
// Design Name:
// Module Name: idle_generator_tb
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

module idle_generator_tb();
    logic clk = 1'b0;
    logic rst_n = 1'b1;
    logic send_idle = 0;
    logic send_K;
    logic send_A;
    logic send_R;

    idle_generator i_idle_generator (
        .clk,
        .rst_n,
        .send_idle,
        .send_K,
        .send_A,
        .send_R
    );

    always #2.5 clk = ~clk;

    initial begin : reset_block
        #10;
        rst_n = 0;
        #10;
        rst_n = 1;
        #10;
    end : reset_block

    initial begin : stimulus
        #30; // wait reset done
        send_idle = 1;
        #2000;
    end : stimulus

endmodule
