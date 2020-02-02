////////////////////////////////////////////////////////////////////////
//
// Module: regfile
//
// Description:
//   A behavioral MIPS register file.  R0 is hardwired to zero.
//   Given that you won't write behavioral code, don't worry if you don't
//   understand how this works;  We have to use behavioral code (as
//   opposed to the structural code you are writing), because of the
//   latching by the the register file.
//
module regfile (rsData, rtData,
                rsNum, rtNum, rdNum, rdData,
                rdWriteEnable, clock, reset);

   output [31:0] rsData, rtData;
   input  [4:0]  rsNum, rtNum, rdNum;
   input  [31:0] rdData;
   input         rdWriteEnable, clock, reset;

   reg    [31:0] r[0:31];
   integer       i;

   always@(reset)
     if(reset == 1'b1)
       begin
          r[0] <= 32'b0;
          for(i = 1; i <= 31; i = i + 1)
            r[i] <= 32'h00000000;
       end

   assign #1 rsData = r[rsNum];
   assign #1 rtData = r[rtNum];

   wire [31:0] #1 internal_rdData = rdData;     // set up and hold time
   always@(posedge clock)
     begin
        if((reset == 1'b0) && (rdWriteEnable == 1'b1) && (rdNum != 5'b0))
          r[rdNum] <= internal_rdData;
     end

endmodule // regfile_3port

/// Comparator: Compares two values, A and B
//  lt: A 1 bit signal if A is less than B
//  ne: A 1 bit signal if A is not equal to B
module comparator(lt, ne, A, B);
  parameter
     width = 32;

  output    lt, ne;
  input     [(width-1):0] A, B;
  assign lt = A < B;
  assign ne = A != B;
endmodule
