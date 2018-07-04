module regn(R, Rin, Clock,Rout, Q);
	parameter n = 9;
	input [n-1:0] R;
	input Rin, Clock;
	output [n-1:0] Q;
	input Rout;
	reg [n-1:0] Q;
	always @(posedge Clock)
		if (Rin or Rout)
			Q <= R;
endmodule