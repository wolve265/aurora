`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 10.02.2023 16:07:34
// Design Name:
// Module Name: data_controller_tb
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

module data_controller_tb();
    logic clk = 1'b0;
    logic clk_data;
    logic rst_n = 1'b1;
    logic single_lane = '0;
    logic axi_valid = '0;
    logic axi_last = '0;
    logic [`AXI_DATA_SIZE-1:0] axi_data = '0;
    ordered_sets_e ordered_sets;
    logic [`AXI_DATA_SIZE-1:0] data_out;

    clock_divider i_clock_divider(
        .clk_in(clk),
        .single_lane,
        .clk_out(clk_data)
    );

    data_controller i_data_controller(
        .clk,
        .rst_n,
        .single_lane,
        .axi_valid,
        .axi_last,
        .axi_data,
        .ordered_sets,
        .data_out
    );

    always #2.5 clk = ~clk;

    initial begin : reset_block
        rst_n = 0;
        #10;
        rst_n = 1;
        #10;
    end : reset_block

    initial begin : stimulus
        int repeat_num;
        #20; // wait reset done

        // 200MHz
        @(negedge clk_data);
        single_lane = 0;
        repeat_num = 1;
        for (int i = 0; i<2; i++) begin
            // two 200MHz cycles are needed between any two messages
            @(negedge clk_data);
            if (i == 1) begin
                repeat_num = 7;
            end
            for (int j = 0; j<repeat_num; j++) begin
                @(negedge clk_data);
                axi_data = 64'hDEADB00DDEADB00D;
                axi_valid = 1;
                if (j >= 2 && j <= 4) begin
                    axi_valid = 0;
                end
            end
            axi_last = 1;
            @(negedge clk_data);
            axi_data = '0;
            axi_valid = 0;
            axi_last = 0;
        end

        #100;
        @(negedge clk);

        // 50MHz
        single_lane = 1;
        repeat_num = 1;
        for (int i = 0; i<2; i++) begin
            // half 50MHz cycles are needed between any two messages (got one)
            if (i == 1) begin
                repeat_num = 7;
            end
            for (int j = 0; j<repeat_num; j++) begin
                @(negedge clk_data);
                axi_data = 64'hDEADB00DDEADB00D;
                axi_valid = 1;
                if (j >= 2 && j <= 4) begin
                    axi_valid = 0;
                end
            end
            axi_last = 1;
            @(negedge clk_data);
            axi_data = '0;
            axi_valid = 0;
            axi_last = 0;
        end
    end : stimulus

endmodule
