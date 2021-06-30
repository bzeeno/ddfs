# ddfs
Direct Digital Frequency Synthesizer with FIR low-pass filter

Table of Contents
=================

* [Directory Structure](#directory-structure)
* [DDFS FIR System](#ddfs-fir-system)
      
# Directory Structure
<pre>
├── Design
|   ├── ddfs_fir_top.sv
|   |
│   ├── DDFS
│   │   └── ddfs.sv
│   ├── FIR
│   │   └── fir.sv
│   └── ROM
│       ├── sine_rom.mem
│       └── wave_rom.sv
├── Software
│   └── main.cpp
└── TestBench
    └── ddfs_tb.sv
</pre>

# DDFS FIR System
- The Direct digital frequency synthesizer (DDFS) and finite impulse response (FIR) filter system has an input clock of 100MHz. However, the FIR low-pass filter samples data at 10MHz, so a Mixed-Mode Clock Manager (MMCM) Module is instantiated to create a 10MHz clock for the FIR filter
- The system also takes the frequency control word for the carrier wave (fcw_c), the frequency control word for the offset frequency(fcw_off), and the phase offset as inputs
  - The frequency control words are calculated as follows: (f<sub>desired</sub> / f<sub>system</sub>) * 2<sup>N</sup>
  - Where the f<sub>desired</sub> is the desired frequency for either the carrier or offset and N is the width of the phase 
- The final input is the envelope for the wave
- The output is a 32-bit waveform
- The 16-bit pulse-code modulation (PCM) output of the ddfs module is an input to the FIR low-pass filter.
- The FIR filter outputs the final 32-bit waveform

## DDFS Module
- Inputs:
  - Frequency control word for the carrier wave
  - Offset frequency control word
  - Phase offset
  - envelope
- Output:
  - 16-bit PCM
- The DDFS module converts phases to amplitudes using a look-up table (LUT). The LUT for a sine wave is created in the main.cpp file.
  - The phase in this case is referring to the phases of the wave. The phase register holds the current phase and it is determined by continuously adding the frequency control word (which is the sum of the carrier frequency control word and the offset frequency control word). 
  - The 10 MSBs of the modulated phase are used as the address bits. (10 bits are used since this is the address width)
- The DDFS module is capable of modulating the carrier wave. It does so through the following equation: <math> A(t) * sin(2π(f<sub>c</sub> + f<sub>off</sub>) + pha<sub>off</sub>) </math>
  - Where, A(t) is the envelope, f<sub>c</sub> is the carrier frequency, f<sub>off</sub> is the offset frequency, and pha<sub>off</sub> is the offset phase.
## FIR Module
