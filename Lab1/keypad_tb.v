module keypad_test;

   reg a = 0, b = 0, c = 0;
   reg d = 0, e = 0, f = 0, g = 0;
   
   initial begin

      $dumpfile("kp.vcd");  
      $dumpvars(0,keypad_test);
      
      # 10  
	a = 1; d = 1;                // pressing 1
      # 10
	a = 0; b = 1;                // pressing 2
      # 10
	b = 0; c = 1;                // pressing 3
      # 10
	c = 0; d = 0;                
	a = 1; e = 1;                // pressing 4
      # 10
	a = 0; b = 1;                // pressing 5
      # 10
	b = 0; c = 1;                // pressing 6
      # 10
	c = 0; e = 0;                
	a = 1; f = 1;                // pressing 7
      # 10
	a = 0; b = 1;                // pressing 8
      # 10
	b = 0; c = 1;                // pressing 9
      # 10
	c = 0; f = 0;                
	b = 1; g = 1;                // pressing 0
      # 10 
	b = 0; g = 0;                // pressing nothing
      # 10 
      $finish;              // end the simulation
   end                      
   
   wire       valid;
   wire [3:0] number;
   keypad kp (valid, number, a, b, c, d, e, f, g);	

   wire [6:0] 	inputs;
   assign inputs = {{ a, b, c, d, e, f, g }};  // this is syntax for grouping signals together as a bus.
	       
   initial
     $monitor("At time %t, abcdefg = %x valid = %d number = %x",
              $time, inputs, valid, number);
endmodule // keypad_test
