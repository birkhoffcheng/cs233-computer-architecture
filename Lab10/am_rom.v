module adding_machine_memory (data, addr);
   output [31:0]    data;
   input  [29:0]    addr;
   
   //declare size words of width bits for storage
   reg [31:0]       memWords [0:255];  
   reg [31:0]       i;          // for initialization

   assign #2 data = memWords[addr[7:0]];   // output the data in the memory 
   
   // whenever addr changes, the word it points to is put
   // on the data lines
   
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
        $readmemh("things_to_add.data.dat", memWords);
     end
   
endmodule // adding_machine_memory
