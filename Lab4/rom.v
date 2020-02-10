////////////////////////////////////////////////////////////////////////
//
// Module: rom
//
// Author: Jared Smolens
//
// Description:
//  Reads a file named 'memory.dat' for 32-bit binary MIPS instructions.
//  Will read up to 256 instructions.
//
////////////////////////////////////////////////////////////////////////
//
// You shouldn't need to edit this file
// 
////////////////////////////////////////////////////////////////////////

module instruction_memory(data, addr);
    output [31:0] data; // output the data in the memory 
    input  [29:0] addr;
    
    //declare size words of width bits for storage
    reg [31:0] memWords [0:255];  
    
    reg [31:0] i; // for initialization
    
    // whenever addr changes, the word it points to is put
    // on the data lines
    assign data = memWords[addr[7:0]];
    
    initial
    begin
        // this is the memory initialization routine
        // it happens once on startup...
        // note! this is not synthesizable

        // set memory to zero
        for (i = 0 ; i < 256 ; i = i + 1 )
        begin
            memWords[i] = 0;
        end

        // read in the program from a file, mem.dat
        $readmemh("memory.text.dat", memWords);
    end
   
endmodule // instruction_memory
