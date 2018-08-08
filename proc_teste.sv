module proc_teste (DIN, Resetn, Clock, Run, Done, BusWires);

	 input  [8:0] DIN;
	 input  Resetn, Clock, Run;
	 output Done;
	 output [8:0] BusWires;
	 
	 logic [7:0] Xreg,Yreg,Rin, Rout;
	 logic [8:0] R0,R1,R2,R3,R4,R5,R6,R7, Aout,G, IR, AddSubOUT;
	 logic [9:0] SEL;
	 logic IRin, Ain, Gin, Gout, DINout, AddSub;
	 logic[1:0] T_State;
	 logic [2:0]I;
	 
	 
	 parameter T0 = 2'b00, T1 = 2'b01, T2 = 2'b10, T3 = 2'b11;
	 parameter mv = 3'b000, mvi = 3'b001, add = 3'b010, sub = 3'b011;
	 
	 //. . . declaração de variáveis
	 
	
	 assign I = IR[8:6];
	 assign Sel = {Rout, Gout, DINout};
	 
	 dec3to8 decX (IR[5:3], 1'b1, Xreg);
	 dec3to8 decY (IR[2:0], 1'b1, Yreg);
	
	 regn reg_IR (DIN[8:0], IRin, Clock, IR);
	 regn reg_0 (BusWires, Rin[0], Clock, R0);
	 regn reg_1 (BusWires, Rin[1], Clock, R1);
	 regn reg_2 (BusWires, Rin[2], Clock, R2);
	 regn reg_3 (BusWires, Rin[3], Clock, R3);
	 regn reg_4 (BusWires, Rin[4], Clock, R4);
	 regn reg_5 (BusWires, Rin[5], Clock, R5);
	 regn reg_6 (BusWires, Rin[6], Clock, R6);
	 regn reg_7 (BusWires, Rin[7], Clock, R7);
	 regn reg_A (BusWires, Ain, Clock, Aout);
	 regn reg_G (AddSubOUT, Gin, Clock, G); 
	 
	 // Controle de estados do FSM
	 
	 always @(*)
	
	begin
	
		if (SEL == 10'b0000000100)
			BusWires = R0;
		else if (SEL == 10'b0000001000)
			BusWires = R1;
		else if (SEL == 10'b0000010000)
			BusWires = R2;
		else if (SEL == 10'b0000100000)
			BusWires = R3;
		else if (SEL == 10'b0001000000)
			BusWires = R4;
		else if (SEL == 10'b0010000000)
			BusWires = R5;
		else if (SEL == 10'b0100000000)
			BusWires = R6;
		else if (SEL == 10'b1000000000)
			BusWires = R7;
		else if (SEL == 10'b0000000010)
			BusWires = G;
		else BusWires = DIN;
	
	end
	 
	 
	always @(posedge Clock, negedge Resetn)
		begin
		 if (!Resetn)
			begin
				T_State= T0;
				IRin = 1'b0;
			end
			 
		 else
			begin
				unique case(T_State)
					T0:
						begin
							IRin = 1'b1;
							Done = 1'b0;
							Rout = 8'b0;
							Gout = 1'b0;
							DINout = 1'b0;
							
						if (Run)
							T_State = T1;
						else
							T_State = T0;
								
								end
						
					T1:
						unique case(I)
							mv:
								begin
									Rout = Yreg;
									Rin = Xreg;
									Done = 1'b1;
									T_State = T0;
								end
										
							mvi:
								begin
									DINout = 1'b1;
									Rin = Xreg; 
									Done = 1'b1;
									T_State = T0;
								end
							
							add,sub:
								begin
									Rout = Xreg;
									Ain = 1'b1;
									T_State = T2;
								end						
									
							default: T_State = T0;
						
						endcase
				
					T2:
						unique case(I)
							add:
								begin
									Rout = Yreg;
									Gin = 1'b1;
									T_State = T3;
								end
										
							sub:
								begin
									Rout = Yreg;
									AddSub = 1'b1;
									Gin = 1'b1;
									T_State = T3;
								end
							
							default: T_State = T0;
									
						endcase
					
					T3:
						unique case(I)
							add, sub: 
								begin
									Gout = 1'b1;
									Rin = Xreg;
									Done = 1'b1;
									T_State = T0;
								end
										
							default: T_State = T0;
						endcase
				endcase
			end
		end	
						 
	 
	always @(AddSub or Aout or BusWires)
		begin
			if (AddSub)                      //Quando AddSub = 1
				AddSubOUT = Aout - BusWires;
			else                             //Quando AddSub = 0
				AddSubOUT = Aout + BusWires;
		end
		
					
endmodule