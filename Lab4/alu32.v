`define ALU_ADDU   3'h0
`define ALU_ADD    3'h2
`define ALU_SUB    3'h3
`define ALU_AND    3'h4
`define ALU_OR     3'h5
`define ALU_NOR    3'h6
`define ALU_XOR    3'h7

////
//// mips_ALU: Performs all arithmetic and logical operations
////
//// out (output) - Final result
//// inA (input)  - Operand modified by the operation
//// inB (input)  - Operand used (in arithmetic ops) to modify inA
//// control (input) - Selects which operation is to be performed
////
module alu32(out, overflow, zero, negative, inA, inB, control);
    output [31:0] out;
    output        overflow, zero, negative;
    input  [31:0] inA, inB;
    input  [2:0]  control;

    assign out = (({32{(control == `ALU_AND)}} & (inA & inB)) |
        ({32{(control == `ALU_OR)}} & (inA | inB)) |
        ({32{(control == `ALU_XOR)}} & (inA ^ inB)) |
        ({32{(control == `ALU_NOR)}} & ~(inA | inB)) |
        ({32{(control == `ALU_ADD)}} & (inA + inB)) |
        ({32{(control == `ALU_ADDU)}} & (inA + inB)) |
        ({32{(control == `ALU_SUB)}} & (inA - inB)));
    assign zero = (out[31:18] == 14'b0) & (out[17:1] == 17'd0) & ~out[0];
    xor x1(negative, out[31], 1'b0);

    // we're just computing this here but we will not need this in the lab.
    assign overflow = ~control[2] & control[1] &
          ( (~control[0] & ~inA[31] & ~inB[31] &  out[31]) |
            (~control[0] &  inA[31] &  inB[31] & ~out[31]) |
            ( control[0] & ~inA[31] &  inB[31] &  out[31]) |
            ( control[0] &  inA[31] & ~inB[31] & ~out[31]) );

endmodule
