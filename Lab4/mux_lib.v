module mux2v(out, A, B, sel);

    parameter
        width = 32;
    
    output [width-1:0] out;
    input  [width-1:0] A, B;
    input              sel;

    wire [width-1:0] temp1 = ({width{(!sel)}} & A);
    wire [width-1:0] temp2 = ({width{(sel)}} & B);
    assign out = temp1 | temp2;

endmodule // mux2v

module mux3v(out, A, B, C, sel);

    parameter
        width = 32;
    
    output [width-1:0] out;
    input  [width-1:0] A, B, C;
    input  [1:0]       sel;
    wire   [width-1:0] wAB;
    
    mux2v #(width) mAB (wAB, A, B, sel[0]);
    mux2v #(width) mfinal (out, wAB, C, sel[1]);

endmodule // mux3v

module mux4v(out, A, B, C, D, sel);

    parameter
        width = 32;
    
    output [width-1:0] out;
    input  [width-1:0] A, B, C, D;
    input  [1:0]       sel;
    wire   [width-1:0] wAB, wCD;
    
    mux2v #(width) mAB (wAB, A, B, sel[0]);
    mux2v #(width) mCD (wCD, C, D, sel[0]);
    mux2v #(width) mfinal (out, wAB, wCD, sel[1]);

endmodule // mux4v

module mux16v(out, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, sel);

    parameter
        width = 32;
    
    output [width-1:0] out;
    input  [width-1:0] A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P;
    input  [3:0]       sel;

    wire [width-1:0]   wAB, wCD, wEF, wGH, wIJ, wKL, wMN, wOP;
    wire [width-1:0]   wABCD, wEFGH, wIJKL, wMNOP;
    wire [width-1:0]   wABCDEFGH, wIJKLMNOP;
    
    mux2v #(width)  mAB (wAB, A, B, sel[0]);
    mux2v #(width)  mCD (wCD, C, D, sel[0]);
    mux2v #(width)  mEF (wEF, E, F, sel[0]);
    mux2v #(width)  mGH (wGH, G, H, sel[0]);
    mux2v #(width)  mIJ (wIJ, I, J, sel[0]);
    mux2v #(width)  mKL (wKL, K, L, sel[0]);
    mux2v #(width)  mMN (wMN, M, N, sel[0]);
    mux2v #(width)  mOP (wOP, O, P, sel[0]);

    mux2v #(width)  mABCD (wABCD, wAB, wCD, sel[1]);
    mux2v #(width)  mEFGH (wEFGH, wEF, wGH, sel[1]);
    mux2v #(width)  mIJKL (wIJKL, wIJ, wKL, sel[1]);
    mux2v #(width)  mMNOP (wMNOP, wMN, wOP, sel[1]);

    mux2v #(width)  mABCDEFGH (wABCDEFGH, wABCD, wEFGH, sel[2]);
    mux2v #(width)  mIJKLMNOP (wIJKLMNOP, wIJKL, wMNOP, sel[2]);
    
    mux2v #(width)  mfinal (out, wABCDEFGH, wIJKLMNOP, sel[3]);

endmodule // mux16v

module mux32v(out, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, 
              A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, sel);

    parameter
        width = 32;
    
    output [width-1:0] out;
    input  [width-1:0] a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p;
    input  [width-1:0] A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P;
    input  [4:0]       sel;
    wire   [width-1:0] wUPPER, wlower;

    mux16v #(width) m0(wlower, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, sel[3:0]);
    mux16v #(width) m1(wUPPER, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, sel[3:0]);
    mux2v  #(width) mfinal (out, wlower, wUPPER, sel[4]);
   
endmodule // mux32v
