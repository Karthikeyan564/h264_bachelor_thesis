#include <verilated.h>          // Defines common routines
#include <iostream>             // Need std::std::cout
#include "VRGB2YCbCr.h"               // From Verilating "top.v"
#include <verilated_vcd_c.h>	
VRGB2YCbCr *top;                      // Instantiation of model

uint64_t main_time = 0;       // Current simulation time


double sc_time_stamp() {        
    return main_time;                                   
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);   // Remember args
    Verilated::mkdir("obj_dir/logs");
    top = new VRGB2YCbCr;             // Create model
    #if VM_TRACE			// If verilator was invoked with --trace
        Verilated::traceEverOn(true);	// Verilator must compute traced signals
        VL_PRINTF("Enabling waves...\n");
        VerilatedVcdC* tfp = new VerilatedVcdC;
        top->trace(tfp, 99);	// Trace 99 levels of hierarchy
        tfp->open ("obj_dir/logs/vcd_dump.vcd");	// Open the dump file
    #endif
    // Do not instead make VRGB2YCbCr as a file-scope static
    // variable, as the "C++ static initialization order fiasco"
    // may cause a crash

    top->rst = 0;           // Set some inputs
    top->R = 0xAB;
    top->G = 0xFF;
    top->B = 0xCD;

    while (!Verilated::gotFinish()) {
        if (main_time > 10) {
            top->rst = 1;   // Deassert reset
        }
        if ((main_time % 10) == 1) {
            top->clk = 1;       // Toggle clock
        }
        if ((main_time % 10) == 6) {
            top->clk = 0;
        }
        top->eval();            // Evaluate model
        #if VM_TRACE
            tfp->dump(main_time);	// Create waveform trace for this timestamp
        #endif
        VL_PRINTF ("[%" VL_PRI64 "d] clk=%x rst=%x Y=%x Cb=%x Cr=%x\n",
		main_time, top->clk, top->rst, top->Y, top->Cb, top->Cr);
        main_time++;            // Time passes...
    }

    top->final();               // Done simulating

    #if VM_TRACE
        if (tfp) tfp->close();
    #endif
    delete top;
}