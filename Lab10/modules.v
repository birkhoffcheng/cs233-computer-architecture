// register: A register which may be reset to an arbirary value
//
// q      (output) - Current value of register
// d      (input)  - Next value of register
// clk    (input)  - Clock (positive edge-sensitive)
// enable (input)  - Load new value? (yes = 1, no = 0)
// reset  (input)  - Synchronous reset    (reset = 1)
//
module register(q, d, clk, enable, reset);

   parameter
            width = 32,
            reset_value = 0;

   output [(width-1):0] q;
   reg    [(width-1):0] q;
   input  [(width-1):0] d;
   input                clk, enable, reset;

   always@(posedge clk)
     if (reset == 1'b1)
       q <= reset_value;
     else if (enable == 1'b1)
       q <= d;

endmodule // register

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
            r[i] <= 32'h10010000;
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

`define ALU_ADD    3'h0
`define ALU_SUB    3'h1
`define ALU_AND    3'h2
`define ALU_OR     3'h3
`define ALU_SLT    3'h4

////
//// mips_ALU: Performs all arithmetic and logical operations
////
//// out (output) - Final result
//// inA (input)  - Operand modified by the operation
//// inB (input)  - Operand used (in arithmetic ops) to modify inA
//// control (input) - Selects which operation is to be performed
////
module alu32(out, zero, control, inA, inB);
   output [31:0] out;
   output        zero;
   input  [2:0] control;
   input signed [31:0] inA, inB;

   assign #2 out = (({32{(control == `ALU_AND)}} & (inA & inB)) |
                    ({32{(control == `ALU_OR)}} & (inA | inB)) |
                    ({32{(control == `ALU_SLT)}} & {31'b0, (inA < inB)}) |
                    ({32{(control == `ALU_ADD)}} & (inA + inB)) |
                    ({32{(control == `ALU_SUB)}} & (inA - inB)));
   assign #1 zero = (inA[31:0] == inB[31:0]);
endmodule

module adder30(out, in1, in2);
   output [29:0] out;
   input [29:0] in1, in2;

   assign #2 out = in1 + in2;
endmodule


module mips_decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst, 
                   opcode, funct);

   output [2:0] ALUOp;
   output       RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst;
   input  [5:0] opcode, funct;
   wire         op0, nop;
   
   
   assign RegWrite = ~MemWrite & ~BEQ & ~nop;
   assign #2 BEQ = (opcode == `OP_BEQ);
   assign ALUSrc = MemRead | MemWrite;
   assign #2 MemRead = (opcode == `OP_LW);
   assign #2 MemWrite = (opcode == `OP_SW);
   assign MemToReg = MemRead;
   assign RegDst = ~MemRead;
             
   assign op0 = (opcode == `OP_OTHER0);
   assign #2 nop = op0 && (funct == 5'b0);
   
   // don't write this kind of code at home!
   assign #2 ALUOp = (( {4{op0 & (funct == `OP0_ADD)}} & `ALU_ADD) |
                      ( {4{op0 & (funct == `OP0_SUB)}} & `ALU_SUB) |
                      ( {4{op0 & (funct == `OP0_AND)}} & `ALU_AND) |
                      ( {4{op0 & (funct == `OP0_OR)}}  & `ALU_OR ) |
                      ( {4{op0 & (funct == `OP0_SLT)}} & `ALU_SLT) |
                      ( {4{(opcode == `OP_LW)}} & `ALU_ADD) |
                      ( {4{(opcode == `OP_SW)}} & `ALU_ADD));

endmodule // mips_decode
   
