`timescale 1ns / 1ps

module fir (
    input logic clk, reset,
    input logic signed [15:0] fir_data_i,
    output logic signed [31:0] fir_data_o
);

    logic signed [15:0] tap0, tap1, tap2, tap3, tap4, tap5, tap6, tap7, tap8, tap9, tap10, tap11, tap12, tap13, tap14;
    logic signed [15:0] buff0, buff1, buff2, buff3, buff4, buff5, buff6, buff7, buff8, buff9, buff10, buff11, buff12, buff13, buff14;
    logic signed [31:0] mul1, mul2, mul3, mul4, mul5, mul6, mul7, mul8, mul9, mul10, mul11, mul12, mul13, mul14;
    logic signed [31:0] acc0, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10, acc11, acc12, acc13;
    logic enable_fir;

    assign tap0  = -365;
    assign tap1  = -158;
    assign tap2  = 1117;
    assign tap3  = 609;
    assign tap4  = -2678;
    assign tap5  = -674;
    assign tap6  = 10185;
    assign tap7  = 17299;
    assign tap8  = 10185;
    assign tap9  = -674;
    assign tap10 = -2678;
    assign tap11 = 609;
    assign tap12 = 1117;
    assign tap13 = -158;
    assign tap14 = -365;

    // set enable flags once buffer is full for first time after reset
    always @(posedge clk)
    begin
        if (reset)
        begin
            enable_fir <= 1'b0;
        end 

        else
        begin
            enable_fir <= 1'b1;
        end
    end

    /***************************** FIR *****************************/
    // Buffers
    always @(posedge clk or posedge reset)
    begin
        if (reset)
        begin
            fir_data_o <= 32'd0;
        end

        else if(enable_fir)
        begin
            buff0  <= fir_data_i;
            acc0   <= buff0 * tap0;

            buff1  <= buff0;
            mul1   <= buff1 * tap1;
            acc1   <= acc0 + mul1;

            buff2  <= buff1;
            mul2   <= buff2 * tap2;
            acc2   <= acc1 + mul2;

            buff3  <= buff2;
            mul3   <= buff3 * tap3;
            acc3   <= acc2 + mul3;

            buff4  <= buff3;
            mul4   <= buff4 * tap4;
            acc4   <= acc3 + mul4;

            buff5  <= buff4;
            mul5   <= buff5 * tap5;
            acc5   <= acc4 + mul5;

            buff6  <= buff5;
            mul6   <= buff6 * tap6;
            acc6   <= acc5 + mul6;

            buff7  <= buff6;
            mul7   <= buff7 * tap7;
            acc7   <= acc6 + mul7;

            buff8  <= buff7;
            mul8   <= buff8 * tap8;
            acc8   <= acc7 + mul8;

            buff9  <= buff8;
            mul9   <= buff9 * tap9;
            acc9   <= acc8 + mul9;

            buff10 <= buff9;
            mul10  <= buff10 * tap10;
            acc10  <= acc9 + mul10;

            buff11 <= buff10;
            mul11  <= buff11 * tap11;
            acc11  <= acc10 + mul11;

            buff12 <= buff11;
            mul12  <= buff12 * tap12;
            acc12  <= acc11 + mul12;

            buff13 <= buff12;
            mul13  <= buff13 * tap13;
            acc13  <= acc12 + mul13;

            buff14 <= buff13;
            mul14  <= buff14 * tap14;
            fir_data_o  <= acc13 + mul14;
        end

    end

    /***************************************************************/


endmodule
