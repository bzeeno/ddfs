`timescale 1ns / 1ps
module ddfs
#(parameter PHASE_WIDTH = 32,
            ADDR_WIDTH  = 10
)
(
    input logic clk, reset,
    input logic [PHASE_WIDTH-1:0] fcw_c, fcw_off, pha_off, // frequency control word for carry freq, for offset freq, phase offset
    input logic [15:0] env,                                // envelope
    output logic signed [15:0] pcm_o,                      // Pulse Code Modulation (PCM) output 
    output logic pulse_o                                   // Pulse output
);
    // Signal declarations
    logic [PHASE_WIDTH-1:0] fcw;                        // freq control word
    logic [PHASE_WIDTH-1:0] pha_reg, pha_next, pha_mod; // phase register, next val, and modulated phase
    logic [15:0] amp;                                   // amplitude from phase to amplitude LUT
    logic [ADDR_WIDTH-1:0] lut_addr;                               // phase to amplitude LUT address
    logic signed [15:0] pcm_reg;                               // Pulse Code Modulation register
    logic signed [31:0] amp_mod;                        // modulated amplitude

    // Phase to Amplitude LUT
    wave_rom sin_rom( .clk(clk), .addr(lut_addr), .data_o(amp) );

    // phase and output registers
    always_ff @(posedge clk, posedge reset)
    begin
        if(reset)
        begin
            pha_reg <= 'b0;
            pcm_reg <= 'b0;
        end
        
        else
        begin
            pha_reg <= pha_next;
            pcm_reg <= amp_mod[29:14]; // amp_mod is in Q18.14 format => By trimming 2 MSBs and 14 LSBs we're left with a 16-bit integer
        end
    end

    // frequency control word
    assign fcw = fcw_c + fcw_off;

    // phase next
    assign pha_next = pha_reg + fcw;

    // phase modulation
    assign pha_mod = pha_reg + pha_off;

    // phase to amplitude LUT addr calculation
    assign lut_addr = pha_mod[PHASE_WIDTH-1:PHASE_WIDTH-ADDR_WIDTH]; // ADDR_WIDTH MSBs of modulated phase

    // amplitude modulation
    // env will be artificially limited from [-1,+1] 
    // so, amp_mod will not need 2 MSBs 
    assign amp_mod = $signed(amp) * $signed(env); // amp (Q16.0) | env (Q2.14) => amp_mod (Q18.14)

    // outputs
    assign pcm_o = $signed(pcm_reg);
    assign pulse_o = pha_reg[PHASE_WIDTH-1];

endmodule
