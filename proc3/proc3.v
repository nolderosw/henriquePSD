module proc3(DIN, Resetn, Clock, Run, Done, BusWires);
	input [8:0] DIN;
	input Resetn, Clock, Run;
	output Done;
	output [8:0] BusWires;
	parameter T0 = 2'b00, T1 = 2'b01, T2 = 2'b10, T3 = 2'b11;
	reg [8:0] BusWires;
	reg [0:7] Rin, Rout;
	reg [8:0] Sum;
	reg IRin, Done, DINout, Ain, Gin, Gout, AddSub;
	reg [1:0] Tstep_Q, Tstep_D;
	wire [2:0] I;
	wire [0:7] Xreg, Yreg;
	wire [8:0] R0, R1, R2, R3, R4, R5, R6, R7;
	wire [8:0] A, G;
	wire [1:9] IR;
	wire [1:10] Sel; 
	assign I = IR[1:3];
	dec3to8 decX (IR[4:6], 1'b1, Xreg);
	dec3to8 decY (IR[7:9], 1'b1, Yreg);
	always @(Tstep_Q, Run, Done)
	begin
		case (Tstep_Q)
			T0:
				if (~Run) Tstep_D = T0;
				else Tstep_D = T1;
	 		T1:
				if (~Run) Tstep_D = T2;
				else Tstep_D = T0;
			T2: 
 				if(~Run)Tstep_D = T3;
				else Tstep_D = T0;
			T3: 
 				Tstep_D = T0;
			default: ;
		endcase
	end
  	parameter mv = 3'b000, mvi = 3'b001, add = 3'b010, sub = 3'b011;
	always @(Tstep_Q or I or Xreg or Yreg)
	begin
		Done = 1'b0; Ain = 1'b0; Gin = 1'b0; Gout = 1'b0; AddSub = 1'b0;
		IRin = 1'b0; DINout = 1'b0; Rin = 8'b0; Rout = 8'b0;
		case (Tstep_Q)
			T0: 
				begin
					IRin = 1'b1;
				end
			T1:   
				case (I)
					mv: 
					begin
						Rout = Yreg;
						Rin = Xreg;
						Done = 1'b1;
					end
					mvi: 
					begin
						
						DINout = 1'b1;
						Rin = Xreg; 
						Done = 1'b1;
					end
					add, sub: 
					begin
						Rout = Xreg;
						Ain = 1'b1;
					end
					default: ; 
				endcase
			T2:   
				case (I)
					add: 
					begin
						Rout = Yreg;
						Gin = 1'b1;
					end
					sub: 
					begin
						Rout = Yreg;
						AddSub = 1'b1;
						Gin = 1'b1;
					end
					default: ; 
				endcase
			T3:  
				case (I)
					add, sub: 
					begin
						Gout = 1'b1;
						Rin = Xreg;
						Done = 1'b1;
					end
					default: ;
				endcase
			default: ;
		endcase
	end	
	always @(posedge Clock, negedge Resetn)
		begin
			if (!Resetn)
				Tstep_Q <= T0;
			else
				Tstep_Q <= Tstep_D;
		end
	regn reg_0 (BusWires, Rin[0], Clock, R0);
	regn reg_1 (BusWires, Rin[1], Clock, R1);
	regn reg_2 (BusWires, Rin[2], Clock, R2);
	regn reg_3 (BusWires, Rin[3], Clock, R3);
	regn reg_4 (BusWires, Rin[4], Clock, R4);
	regn reg_5 (BusWires, Rin[5], Clock, R5);
	regn reg_6 (BusWires, Rin[6], Clock, R6);
	regn reg_7 (BusWires, Rin[7], Clock, R7);
	regn reg_A (BusWires, Ain, Clock, A);
	always @(AddSub or A or BusWires)
		begin
		if (!AddSub)
			Sum = A + BusWires;
	    else
			Sum = A - BusWires;
		end
	regn reg_G (Sum, Gin, Clock, G);
	assign Sel = {Rout, Gout, DINout};
	always @(*)
	begin
		if (Sel == 10'b1000000000)
			BusWires = R0;
   	else if (Sel == 10'b0100000000)
			BusWires = R1;
		else if (Sel == 10'b0010000000)
			BusWires = R2;
		else if (Sel == 10'b0001000000)
			BusWires = R3;
		else if (Sel == 10'b0000100000)
			BusWires = R4;
		else if (Sel == 10'b0000010000)
			BusWires = R5;
		else if (Sel == 10'b0000001000)
			BusWires = R6;
		else if (Sel == 10'b0000000100)
			BusWires = R7;
		else if (Sel == 10'b0000000010)
			BusWires = G;
   	else BusWires = DIN;
	end	
endmodule