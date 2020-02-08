module reg_writer(done, regnum, direction, go, clock, reset);

	input direction, go;
	input clock, reset;

	output done;
	output [4:0] regnum;

	wire sGarbage, sStart, sUp1, sUp2, sUp3, sUp4, sDown1, sDown2, sDown3, sDown4, sDone;	

	wire sGarbage_next = reset | sGarbage & ~go;
	wire sStart_next = ~reset & (sStart | sGarbage | sDone) & go;

	wire sUp1_next = ~reset & sStart & direction & ~go & ~sGarbage & ~sUp1 & ~sUp2 & ~sUp3 & ~sUp4 & ~sDown1 & ~sDown2 & ~sDown3 & ~sDown4 & ~sDone;
	wire sUp2_next = ~reset & sUp1 & ~sGarbage & ~sStart & ~sUp2 & ~sUp3 & ~sUp4 & ~sDown1 & ~sDown2 & ~sDown3 & ~sDown4 & ~sDone;
	wire sUp3_next = ~reset & sUp2 & ~sGarbage & ~sStart & ~sUp1 & ~sUp3 & ~sUp4 & ~sDown1 & ~sDown2 & ~sDown3 & ~sDown4 & ~sDone;
	wire sUp4_next = ~reset & sUp3 & ~sGarbage & ~sStart & ~sUp1 & ~sUp2 & ~sUp4 & ~sDown1 & ~sDown2 & ~sDown3 & ~sDown4 & ~sDone;

	wire sDown1_next = ~reset & sStart & ~direction & ~go & ~sGarbage & ~sUp1 & ~sUp2 & ~sUp3 & ~sUp4 & ~sDown1 & ~sDown2 & ~sDown3 & ~sDown4 & ~sDone;
	wire sDown2_next = ~reset & sDown1 & ~sGarbage & ~sStart & ~sUp1 & ~sUp2 & ~sUp3 & ~sUp4 & ~sDown2 & ~sDown3 & ~sDown4 & ~sDone;
	wire sDown3_next = ~reset & sDown2 & ~sGarbage & ~sStart & ~sUp1 & ~sUp2 & ~sUp3 & ~sUp4 & ~sDown1 & ~sDown3 & ~sDown4 & ~sDone;
	wire sDown4_next = ~reset & sDown3 & ~sGarbage & ~sStart & ~sUp1 & ~sUp2 & ~sUp3 & ~sUp4 & ~sDown1 & ~sDown2 & ~sDown4 & ~sDone;
	 
	wire sDone_next = ~reset & ((sUp4 | sDown4) | (sDone & ~go));

	dffe fsGarbage(sGarbage, sGarbage_next, clock, 1'b1, 1'b0);
	dffe fsStart(sStart, sStart_next, clock, 1'b1, 1'b0);

	dffe fsUp1(sUp1, sUp1_next, clock, 1'b1, 1'b0);
	dffe fsUp2(sUp2, sUp2_next, clock, 1'b1, 1'b0);
	dffe fsUp3(sUp3, sUp3_next, clock, 1'b1, 1'b0);
	dffe fsUp4(sUp4, sUp4_next, clock, 1'b1, 1'b0);
	
	dffe fsDown1(sDown1, sDown1_next, clock, 1'b1, 1'b0);
	dffe fsDown2(sDown2, sDown2_next, clock, 1'b1, 1'b0);
	dffe fsDown3(sDown3, sDown3_next, clock, 1'b1, 1'b0);
	dffe fsDown4(sDown4, sDown4_next, clock, 1'b1, 1'b0);
	
	dffe fsDone(sDone, sDone_next, clock, 1'b1, 1'b0);

	assign done = sDone;
	assign regnum = sStart ? 8 :
			sDown1 ? 7 :
			sDown2 ? 6 :
			sDown3 ? 5 :
			sDown4 ? 4 : 
			sUp1   ? 9 :
			sUp2   ? 10:
			sUp3   ? 11:
			sUp4   ? 12:
			0;
endmodule // end reg_writer
