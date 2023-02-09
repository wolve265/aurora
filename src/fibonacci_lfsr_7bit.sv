`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 08.02.2023 20:15:32
// Design Name:
// Module Name: fibonacci_lfsr_7bit
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//  - Linear Feedback Shift Register from
//    https://airhdl.com/blog/2022/09/18/new-generator-linear-feedack-shift-register/
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module fibonacci_lfsr_7bit(
    input logic clk,
    input logic rst_n,
    output logic pseudo_random_bit,
    output logic [6:0] pseudo_random_integer
    );


    logic [6:0] data;
    logic feedback;

    assign feedback = ~(data[6] ^ data[5]);
    assign pseudo_random_bit = feedback;
    assign pseudo_random_integer = data;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            data <= '0;
        end else begin
            data <= {data[5:0], feedback};
        end
    end

endmodule
