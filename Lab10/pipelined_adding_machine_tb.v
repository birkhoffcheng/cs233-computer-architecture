module test;
   /* Make a regular pulsing clock. */
   reg       clk = 0;
   always #2 clk = !clk;
   integer     i;
   wire [31:0] out;

   reg          reset = 1, done = 0;

   pipelined_adding_machine pam(out, clk, reset);

   initial begin
      $dumpfile("pam.vcd");
      $dumpvars(0, test);
      # 13 reset = 0;
      # 50 done = 1;
      $finish;
   end

  initial
     $monitor("At time %t, reset = %d index = %h, out = %h",
              $time, reset, pam.Counter.q, out);

endmodule // test
