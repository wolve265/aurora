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
    input logic single_lane,
    input logic axi_valid,
    input logic axi_last,
    input logic [`AXI_DATA_SIZE-1:0] axi_data,
    output ordered_sets_e ordered_sets,
    output logic [`AXI_DATA_SIZE-1:0] data_out
    );

    typedef enum logic [2:0] {
        IDLE,
        FRAME_START,
        STREAM,
        PACKET_END,
        FRAME_END
    } state_e;

    state_e state, state_nxt;

    logic [3:0] data_counter, data_counter_nxt, data_counter_max;
    assign data_counter_max = single_lane ? `SYS_TO_SINGLE_LINE_CLK_RATIO : `SYS_TO_MULTI_LINE_CLK_RATIO;

    logic axi_valid_delayed;
    logic axi_last_delayed;
    logic [`AXI_DATA_SIZE-1:0] axi_data_delayed;

    ordered_sets_e ordered_sets_nxt;
    logic [`AXI_DATA_SIZE-1:0] data_out_nxt;

    delay #(
        .WIDTH(`AXI_DATA_SIZE+2),
        .CLK_DEL(3)
    ) i_delay (
        .clk,
        .rst_n,
        .din({axi_data, axi_valid, axi_last}),
        .dout({axi_data_delayed, axi_valid_delayed, axi_last_delayed})
    );

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            ordered_sets <= NONE;
            data_out <= '0;
            data_counter <= '0;
        end else begin
            state <= state_nxt;
            ordered_sets <= ordered_sets_nxt;
            data_out <= data_out_nxt;
            data_counter <= data_counter_nxt;
        end
    end

    always_comb begin
        state_nxt = state;
        ordered_sets_nxt = NONE;
        data_out_nxt = '0;
        data_counter_nxt = data_counter + 1;

        case (state)
            IDLE: begin
                ordered_sets_nxt = I;
                if (axi_valid) begin
                    state_nxt = FRAME_START;
                    data_counter_nxt = 0;
                end
            end
            FRAME_START: begin
                if (data_counter_nxt == 2) begin
                    state_nxt = STREAM;
                    data_counter_nxt = 0;
                end
                ordered_sets_nxt = SCP;
            end
            STREAM: begin
                data_out_nxt = axi_data_delayed;
                if (!axi_valid_delayed) begin
                    ordered_sets_nxt = I;
                    data_out_nxt = '0;
                end
                if (data_counter_nxt == data_counter_max) begin
                    data_counter_nxt = 0;
                    if (axi_last_delayed) begin
                        state_nxt = FRAME_END;
                    end
                end
            end
            FRAME_END: begin
                if (data_counter_nxt == 2) begin
                    state_nxt = IDLE;
                    if (axi_valid) begin
                        state_nxt = FRAME_START;
                        data_counter_nxt = 0;
                    end
                end
                ordered_sets_nxt = ECP;
            end
            default: begin
                state_nxt = state;
            end
        endcase
    end

endmodule
