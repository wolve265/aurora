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
    logic clk_400MHz = 1'b0;
    logic clk_200MHz = 1'b0;
    logic clk_50MHz = 1'b0;
    logic rst_n = 1'b1;
    logic single_lane = '0;
    logic axi_valid = '0;
    logic axi_last = '0;
    logic [AXI_DATA_SIZE-1:0] axi_data = '0;
    ordered_sets_e ordered_sets;
    logic [AXI_DATA_SIZE-1:0] data_out;

    data_controller i_data_controller(
        .clk(clk_400MHz),
        .rst_n,
        .single_lane,
        .axi_valid,
        .axi_last,
        .axi_data,
        .ordered_sets,
        .data_out
    );

    always #2.5 clk_400MHz = ~clk_400MHz;
    always #5   clk_200MHz = ~clk_200MHz;
    always #20  clk_50MHz  = ~clk_50MHz;

    initial begin : reset_block
        #10;
        rst_n = 0;
        #10;
        rst_n = 1;
        #10;
    end : reset_block

    initial begin : stimulus
        int repeat_num;
        #30; // wait reset done

        // 200MHz
        single_lane = 0;
        repeat_num = 1;
        for (int i = 0; i<2; i++) begin
            // two 200MHz cycles are needed between any two messages
            @(posedge clk_200MHz);
            if (i == 1) begin
                repeat_num = 7;
            end
            for (int j = 0; j<repeat_num; j++) begin
                @(posedge clk_200MHz);
                axi_data = 64'hDEADB00DDEADB00D;
                axi_valid = 1;
                if (j >= 2 && j <= 4) begin
                    axi_valid = 0;
                end
            end
            axi_last = 1;
            @(posedge clk_200MHz);
            axi_data = '0;
            axi_valid = 0;
            axi_last = 0;
        end

        // 50MHz
        single_lane = 1;
        repeat_num = 1;
        for (int i = 0; i<2; i++) begin
            // none 50MHz cycles are needed between any two messages
            if (i == 1) begin
                repeat_num = 7;
            end
            for (int j = 0; j<repeat_num; j++) begin
                @(posedge clk_50MHz);
                axi_data = 64'hDEADB00DDEADB00D;
                axi_valid = 1;
                if (j >= 2 && j <= 4) begin
                    axi_valid = 0;
                end
            end
            axi_last = 1;
            @(posedge clk_50MHz);
            axi_data = '0;
            axi_valid = 0;
            axi_last = 0;
        end
    end : stimulus

endmodule