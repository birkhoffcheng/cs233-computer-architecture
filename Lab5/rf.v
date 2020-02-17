// register: A register which may be reset to an arbirary value
//
// q      (output) - Current value of register
// d      (input)  - Next value of register
// clk    (input)  - Clock (positive edge-sensitive)
// enable (input)  - Load new value? (yes = 1, no = 0)
// reset  (input)  - Asynchronous reset    (reset = 1)
//
module register(q, d, clk, enable, reset);

    parameter
        width = 32,
        reset_value = 0;

    output [(width-1):0] q;
    reg    [(width-1):0] q;
    input  [(width-1):0] d;
    input  clk, enable, reset;

    always @(reset)
        if (reset == 1'b1)
            q <= reset_value;

    always @(posedge clk)
        if ((reset == 1'b0) && (enable == 1'b1))
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
    input   [4:0] rsNum, rtNum, rdNum;
    input  [31:0] rdData;
    input         rdWriteEnable, clock, reset;
    
    reg signed [31:0] r [0:31];
    integer i;

    always @(reset)
        if (reset == 1'b1)
        begin
            for(i = 0; i <= 31; i = i + 1)
                r[i] <= 0;
        end

    assign rsData = r[rsNum];
    assign rtData = r[rtNum];

    always @(posedge clock)
    begin
        if ((reset == 1'b0) && (rdWriteEnable == 1'b1) && (rdNum != 5'b0))
            r[rdNum] <= rdData;
    end

endmodule // regfile
