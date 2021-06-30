`timescale 1ns / 1ps

module fir (
    input logic clk, reset,
    input logic signed [15:0] fir_data_i,
    output logic signed [31:0] fir_data_o
);

    logic signed [15:0] tap0, tap1, tap2, tap3, tap4, tap5, tap6, tap7, tap8, tap9, tap10, tap11, tap12, tap13, tap14;
    logic signed [15:0] buff0, buff1, buff2, buff3, buff4, buff5, buff6, buff7, buff8, buff9, buff10, buff11, buff12, buff13, buff14;
    logic signed [31:0] mul0, mul1, mul2, mul3, mul4, mul5, mul6, mul7, mul8, mul9, mul10, mul11, mul12, mul13, mul14;
    logic signed [31:0] acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10, acc11, acc12, acc13, acc14;
    logic enable_fir;

    // Filter coefficients for 15 tap low-pass fir filter sampling at 10MHz 
    // passband: 0    - 1MHz
    // Stopband: 2MHz - 5MHz
    assign tap0  = -413;
    assign tap1  = -886;
    assign tap2  = -1021;
    assign tap3  = -110;
    assign tap4  = 2180;
    assign tap5  = 5360;
    assign tap6  = 8183;
    assign tap7  = 9315;
    assign tap8  = 8183;
    assign tap9  = 5360;
    assign tap10 = 2180;
    assign tap11 = -110;
    assign tap12 = -1021;
    assign tap13 = -886;
    assign tap14 = -413;


    // set enable flags once buffer is full for first time after reset
    always @(posedge clk, posedge reset)
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
        if (reset == 1)
        begin
            buff0  <= 0;
            mul0   <= 0;

            buff1  <= 0;
            mul1   <= 0;

            buff2  <= 0;
            mul2   <= 0;

            buff3  <= 0;
            mul3   <= 0;

            buff4  <= 0;
            mul4   <= 0;

            buff5  <= 0;
            mul5   <= 0;

            buff6  <= 0;
            mul6   <= 0;

            buff7  <= 0;
            mul7   <= 0;

            buff8  <= 0;
            mul8   <= 0;

            buff9  <= 0;
            mul9   <= 0;

            buff10 <= 0;
            mul10  <= 0;

            buff11 <= 0;
            mul11  <= 0;

            buff12 <= 0;
            mul12  <= 0;

            buff13 <= 0;
            mul13  <= 0;

            buff14 <= 0;
            mul14  <= 0;

        end

        else if (enable_fir)
        begin
            buff0  <= fir_data_i;
            mul0   <= buff0 * tap0;

            buff1  <= buff0;
            mul1   <= buff1 * tap1;

            buff2  <= buff1;
            mul2   <= buff2 * tap2;

            buff3  <= buff2;
            mul3   <= buff3 * tap3;

            buff4  <= buff3;
            mul4   <= buff4 * tap4;

            buff5  <= buff4;
            mul5   <= buff5 * tap5;

            buff6  <= buff5;
            mul6   <= buff6 * tap6;

            buff7  <= buff6;
            mul7   <= buff7 * tap7;

            buff8  <= buff7;
            mul8   <= buff8 * tap8;

            buff9  <= buff8;
            mul9   <= buff9 * tap9;

            buff10 <= buff9;
            mul10  <= buff10 * tap10;

            buff11 <= buff10;
            mul11  <= buff11 * tap11;

            buff12 <= buff11;
            mul12  <= buff12 * tap12;

            buff13 <= buff12;
            mul13  <= buff13 * tap13;

            buff14 <= buff13;
            mul14  <= buff14 * tap14;
        end

    end

    always_comb 
    begin
        acc1   = mul0 + mul1;
        acc2   = acc1 + mul2;
        acc3   = acc2 + mul3;
        acc4   = acc3 + mul4;
        acc5   = acc4 + mul5;
        acc6   = acc5 + mul6;
        acc7   = acc6 + mul7;
        acc8   = acc7 + mul8;
        acc9   = acc8 + mul9;
        acc10  = acc9 + mul10;
        acc11  = acc10 + mul11;
        acc12  = acc11 + mul12;
        acc13  = acc12 + mul13;
        acc14  = acc13 + mul14;
    end

    assign fir_data_o = acc14;

    /***************************************************************/


endmodule
