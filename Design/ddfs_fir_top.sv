`timescale 1ns / 1ps

module ddfs_fir_top
#(parameter PHASE_WIDTH = 32,
            ADDR_WIDTH  = 10
)
(
    input logic clk_in, reset,
    input logic [PHASE_WIDTH-1:0] fcw_c_i, fcw_off_i, pha_off_i, // frequency control word for carry freq, for offset freq, phase offset
    input logic [15:0] env_i,                                      // envelope
    output logic signed [31:0] waveform_o                        // waveform out
);

    logic clk, clk_10MHz; // 100MHz sys clock, 10MHz clock for fir filter
    logic signed [15:0] pcm_w;

    ddfs #(.PHASE_WIDTH(PHASE_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) ddfs_unit (
        .clk(clk), .reset(reset),
        .fcw_c(fcw_c_i), .fcw_off(fcw_off_i), .pha_off(pha_off_i), 
        .env(env_i),                                
        .pcm_o(pcm_w),                       
        .pulse_o()                                   
    );

    clk_10MHz_gen mmcm_unit
    (
        // Clock out ports
        .clk_10MHz(clk_10MHz),     // output clk_10MHz
        .clk(clk),                 // output clk
        // Status and control signals
        .reset(reset), // input reset
        .locked(),       // output locked
        // Clock in ports
        .clk_in(clk_in) // input clk_in
    );      


    fir fir_unit (
        .clk(clk_10MHz), .reset(reset),
        .fir_data_i(pcm_w),
        .fir_data_o(waveform_o)
    );

endmodule
