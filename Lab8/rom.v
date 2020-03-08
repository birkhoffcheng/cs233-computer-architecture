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

module instruction_memory (data, addr);
   output [31:0]    data;
   input  [29:0]    addr;
   
   //declare size words of width bits for storage
   reg [31:0]       memWords [0:255];  
   reg [31:0]       kmemWords [0:255];  
   reg [31:0]       i;          // for initialization

   wire [31:0] tdata = memWords[addr[7:0]];
   wire [31:0] kdata = kmemWords[addr[7:0]];
   assign data = ~addr[29] ? tdata : kdata;
   
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
             kmemWords[i] = 0;
          end
        
        // read in the program from a file, mem.dat
        $readmemh("memory.text.dat", memWords);
        $readmemh("memory.ktext.dat", kmemWords);
     end
   
endmodule // instruction_memory

module data_mem(data_out, addr, data_in, mem_read, mem_write, clk, reset);
   parameter     // size of data segment
     data_start   = 32'h10000000,
     data_words   = 'h40000; /* 1 M */
   
   input         clk, reset;

   // Inputs and ouptuts: Port 1
   output [31:0] data_out;     // Memory read data
   input  [31:0] addr;         // Memory address
   input  [31:0] data_in;      // Memory write data
   input         mem_read;      // Read enable (active high)
   input         mem_write;     // Write enable (active high)

   wire [18:0] index;
   wire [31:0] d_out;

   // Memory segments
   reg [31:0]    data_seg[0:data_words-1];
   reg [31:0]    kdata_seg[0:data_words-1];

   // Verilog implementation stuff
   integer       i;

   always@(reset)
     if (reset == 1'b1)
       begin
         // Initialize memory (prevents x-pessimism problem)
         for(i = 0; i < data_words; i = i + 1)
           begin
             data_seg[i] = 32'hdeadbeef;
             kdata_seg[i] = 32'hdeadbeef;
           end

           // Grab initial memory values
           $readmemh("memory.data.dat", data_seg);
           $readmemh("memory.kdata.dat", kdata_seg);
       end

   assign index = addr[21:2];
   assign d_out = ~addr[31] ? data_seg[index] : kdata_seg[index];
   tristate t(data_out, d_out, mem_read);

   always @(posedge clk)
     if (reset == 1'b0)
       if (mem_write == 1'b1)
         if (~addr[31]) 
           data_seg[index] <= data_in;
         else
           kdata_seg[index] <= data_in;
   
endmodule // data_mem
