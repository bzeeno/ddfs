`timescale 1ns / 1ps
module ddfs_tb;

    parameter PHASE_WIDTH = 32;
    parameter ADDR_WIDTH  = 10;
    const integer START_FREQ  = 21474836 - 7730941;              // 0.5 MHz
    const integer STOP_FREQ   = 214748364;                       // 5 MHz
    const integer INC_VAL     = (STOP_FREQ - START_FREQ) / 25;   // increment value 

    logic clk, reset; 
    logic [PHASE_WIDTH-1:0] fcw_c, fcw_off, pha_off; // fcw_c = (f_carrier/f_sys) * 2^PHASE_WIDTH
    logic [15:0] env;
    // logic signed [15:0] pcm_o;
    logic signed [31:0] waveform_o;

    // slow clock  
    const integer max_count = 100; // T_count/2 = (f_sys_clk / f_start) / 2 = (100Mhz / 0.5Mhz) / 2 = 384615 / 2
    logic slow_clk; // f = 260Hz
    integer count;

    assign fcw_off = 'd0;
    assign pha_off = 'd0;
    assign env = 16'h4000; // +1.0 in Q2.14 format

    /*
    initial 
    begin 
        fcw_c = 8589934;  // 200 kHz
        count = 0;
        reset = 1; #40;
        slow_clk = 1;
        reset = 0; 
    end
    always 
    begin
        clk = 1; #5;
        clk = 0; #5;
    end

    ddfs_fir_top #(.PHASE_WIDTH(PHASE_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) ddfs_fir_dut (
        .clk(clk), .reset(reset),
        .fcw_c_i(fcw_c), .fcw_off_i(fcw_off), .pha_off_i(pha_off),   // frequency control word for carry freq, for offset freq, phase offset
        .env_i(env),                                             // envelope
        .waveform_o(waveform_o)                                         // Pulse Code Modulation (PCM) output 
    );

   */

    initial 
    begin 
        fcw_c = START_FREQ; 
        count = 0;
        slow_clk = 1;
        reset = 1; #40;
        reset = 0; 
    end
     
    // Generate a 100Mhz (10ns) clock 
    always 
    begin
        clk = 1; #5;
        clk = 0; #5;

        // increment count
        count = count + 1;

        if (count == max_count) // if half period, then invert slow_clk 
        begin
            slow_clk = ~slow_clk;
            count = 0;
        end
    end
    
    always @(posedge slow_clk)
    begin

        if(fcw_c <= STOP_FREQ)
            fcw_c = fcw_c + INC_VAL;
        else
            fcw_c = START_FREQ;

    end
    
    ddfs_fir_top #(.PHASE_WIDTH(PHASE_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) ddfs_fir_dut (
        .clk_in(clk), .reset(reset),
        .fcw_c_i(fcw_c), .fcw_off_i(fcw_off), .pha_off_i(pha_off),   // frequency control word for carry freq, for offset freq, phase offset
        .env_i(env),                                             // envelope
        .waveform_o(waveform_o)                                         // Pulse Code Modulation (PCM) output 
    );
     

endmodule

