module test;
   /* Make a regular pulsing clock. */
   reg       clk = 0;
   always #6 clk = !clk;
   integer   i;

   reg       reset = 1, done = 0;

   pipelined_machine pm(clk, reset);

   initial begin
      $dumpfile("pm.vcd");
      $dumpvars(0, test); // dump all variables except memories
          for (i = 0 ; i < 32 ; i = i + 1)
             $dumpvars(1, pm.rf.r[i]); // dump all register values

      # 7 reset = 0;
      # 400 done = 1;
   end

   wire [31:0] PC = { pm.PC_reg.q, 2'b00 };
   initial
     $monitor("At time %t, reset = %d pc = %h, inst = %h",
              $time, reset, PC, pm.imem.data);

   // periodically check for the end of simulation.  When it happens
   // dump the register file contents.
   always @(negedge clk)
     begin
        if (done === 1'b1)
        begin
           $display ( "Dumping register state: " );
           $display ( "  Register :  hex-value (  dec-value )" );
           for (i = 0 ; i < 32 ; i = i + 1)
              $display ( "%d: 0x%x ( %d )", i, pm.rf.r[i], pm.rf.r[i]);

           $display ( "\nDumping memory state: " );
           $display ( "   Address :  hex-value (  dec-value )" );
           for (i = 16384 ; i < 16389 ; i = i + 1)
              $display ( " 0x%x: 0x%x ( %d )", 32'h10000000 + (i << 2), pm.data_memory.data_seg[i], pm.data_memory.data_seg[i]);

           $display ( "Done.  Simulation ending." );
           $finish;
        end
     end


endmodule // test
