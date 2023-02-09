`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 08.02.2023 18:53:02
// Design Name:
// Module Name: idle_generator
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

module idle_generator (
    input logic clk,
    input logic rst_n,
    input logic send_idle,
    output logic send_K,
    output logic send_A,
    output logic send_R
    );

    logic [7:0] pseudo_random_integer;
    logic pseudo_random_bit;

    logic down_counter_rst;
    logic [4:0] down_counter_out;
    logic Acounter_eq_zero;
    logic send_idle_delayed;

    fibonacci_lfsr_7bit i_fibonacci_lfsr_7bit(
        .clk,
        .rst_n,
        .pseudo_random_bit,
        .pseudo_random_integer
    );

    down_counter i_down_counter(
        .clk,
        .rst_n(down_counter_rst),
        .load(Acounter_eq_zero),
        .data({1'b1, pseudo_random_integer[3:0]}),
        .count(down_counter_out)
    );

    assign down_counter_rst = !((send_idle & !send_idle_delayed) | !rst_n);
    assign Acounter_eq_zero = !down_counter_out;

    assign send_K = send_idle & send_idle_delayed & !Acounter_eq_zero & pseudo_random_bit;
    assign send_A = send_idle & send_idle_delayed & Acounter_eq_zero;
    assign send_R = send_idle & send_idle_delayed & !Acounter_eq_zero & !pseudo_random_bit;

    always_ff @(posedge clk) begin
        send_idle_delayed <= send_idle;
    end


endmodule
