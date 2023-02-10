`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02.01.2023 18:23:02
// Design Name:
// Module Name: data_controller
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

module data_controller(
    input logic clk,
    input logic rst_n,
    input logic single_lane, // FIXME: is it needed?
    input logic axi_valid,
    input logic axi_last,
    input logic [AXI_DATA_SIZE-1:0] axi_data,
    output ordered_sets_e ordered_sets,
    output logic [AXI_DATA_SIZE-1:0] data_out
    );

    typedef enum logic [1:0] {
        IDLE,
        STREAM,
        LAST
    } state_e;

    logic axi_valid_prev;
    state_e state, state_nxt;
    ordered_sets_e ordered_sets_nxt;
    logic [AXI_DATA_SIZE-1:0] data_out_nxt;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            ordered_sets <= NONE;
            data_out <= '0;
            axi_valid_prev <= '0;
        end else begin
            state <= state_nxt;
            ordered_sets <= ordered_sets_nxt;
            data_out <= data_out_nxt;
            axi_valid_prev <= axi_valid;
        end
    end

    always_comb begin
        state_nxt = state;
        ordered_sets_nxt = NONE;
        data_out_nxt = '0;

        case (state)
            IDLE: begin
                if (axi_valid & !axi_valid_prev) begin
                    ordered_sets_nxt = SCP;
                    state_nxt = STREAM;
                end
            end
            STREAM: begin
                data_out_nxt = axi_data;
                if (!axi_valid) begin
                    ordered_sets_nxt = I;
                end else if (axi_last) begin
                    state_nxt = LAST;
                end
            end
            LAST: begin
                ordered_sets_nxt = ECP;
                state_nxt = IDLE;
            end
            default: begin
                state_nxt = state;
            end
        endcase
    end

endmodule
