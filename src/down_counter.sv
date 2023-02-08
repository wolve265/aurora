`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 08.02.2023 19:15:32
// Design Name:
// Module Name: down_counter
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

module down_counter(
    input logic clk,
    input logic load,
    input logic [4:0] data,
    output logic [4:0] count
    );

    always_ff @(posedge clk) begin
        if (load) begin
            count <= data;
        end else begin
            count <= count - 1;
        end
    end

endmodule
