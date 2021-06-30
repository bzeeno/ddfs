#include <stdio.h>
#include <iostream>
#include <iomanip>
#include <math.h>
#include <fstream>

using namespace std;

#define PI 3.14159265
#define AMPLITUDE 32767 // 2^15 - 1
#define NUM_SAMPLES 1024 // 1024 ROM addresses

int main() {
    double angle = 0.0;

    ofstream outfile; 
    outfile.open("sine_rom.mem");

    for (int i = 0; i<NUM_SAMPLES; i++) {
        outfile << setw(4) << setfill('0') << hex << int16_t(AMPLITUDE * sin(angle)) << "\n";
        angle += (2 * M_PI) / NUM_SAMPLES; // 2pi/num_samples. This breaks 1 period into NUM_SAMPLES
    }

    outfile.close();

    return 0;
}
