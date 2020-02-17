// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC;  

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg( /* connect signals */);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im( /* connect signals */ );

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf ( /* connect signal wires */);

    /* add other modules */

endmodule // full_machine
