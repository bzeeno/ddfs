`timescale 1ns / 1ps
module wave_rom
#(parameter DATA_WIDTH = 16, 
            ADDR_WIDTH = 10
)
(
    input  logic clk,
    input  logic [ADDR_WIDTH-1:0] addr,
    output logic [DATA_WIDTH-1:0] data_o
);

    // Signals
    logic [DATA_WIDTH-1:0] rom [0:2**ADDR_WIDTH-1];
    logic [DATA_WIDTH-1:0] data_reg;

    initial
        $readmemh("sine_rom.mem", rom);

    always_ff @(posedge clk)
    begin
        data_reg <= rom[addr];
    end

    assign data_o = data_reg;
    

endmodule
