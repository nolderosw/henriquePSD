module proc2 (DIN, Resetn, Clock, Run, Done, BusWires);
	input [8:0] DIN;
	input Resetn, Clock, Run;
	output Done;
	output [8:0] BusWires;
	parameter T0 = 2'b00, T1 = 2'b01, T2 = 2'b10, T3 = 2'b11;
	
	//declaracao de variaveis
	reg [1:0] Tstep_Q;
	reg [7:0] Rin;
	wire [0:8] IRout;
	wire [8:0] Xreg;
	wire [8:0] Yreg;
	wire YA;
	wire YG;
	wire Areg;
	wire Greg;
	wire [8:0] R0;
	wire [8:0] R1;
	wire [8:0] R2;
	wire [8:0] R3;
	wire [8:0] R4;
	wire [8:0] R5;
	wire [8:0] R6;
	wire [8:0] R7;
	wire [8:0] A;
	wire [8:0] G;
	wire [2:0] I;
	wire [8:0] RTemp;
	wire [8:0] RTemp_y;
	wire [8:0] RTemp_add;
	reg IRin;
	regn reg_IR (DIN, IRin, Clock, IRout);
	assign I = IRout[0:2];
	dec3to8 decX (IRout[3:5], 1'b1, Xreg);
	dec3to8 decY (IRout[6:8], 1'b1, Yreg);
	regn reg_0 (BusWires, Xreg[0], Clock, Yreg[0], R0);
	regn reg_1 (BusWires, Xreg[1], Clock, Yreg[1], R1);
	regn reg_2 (BusWires, Xreg[2], Clock, Yreg[2], R2);
	regn reg_3 (BusWires, Xreg[3], Clock, Yreg[3], R3);
	regn reg_4 (BusWires, Xreg[4], Clock, Yreg[4], R4);
	regn reg_5 (BusWires, Xreg[5], Clock, Yreg[5], R5);
	regn reg_6 (BusWires, Xreg[6], Clock, Yreg[6], R6);
	regn reg_7 (BusWires, Xreg[7], Clock, Yreg[7], R7);
	regn reg_a (BusWires, Areg, Clock, YA, A);
	regn reg_g (Buswires, Greg, Clock, YG, G);
	if(Xreg[0])
		Rtemp = R0;
	else if(Xreg[1])
		Rtemp = R1;
	else if(Xreg[2])
		Rtemp = R2;
	else if(Xreg[3])
		Rtemp = R3;
	else if(Xreg[4])
		Rtemp = R4;
	else if(Xreg[5])
		Rtemp = R5;
	else if(Xreg[6])
		Rtemp = R6;
	else if(Xreg[7])
		Rtemp = R7;
				
	if(Yreg[0])
		Rtemp_y = R0;
	else if(Yreg[1])
		Rtemp_y = R1;
	else if(Yreg[2])
		Rtemp_y = R2;
	else if(Yreg[3])
		Rtemp_y = R3;
	else if(Yreg[4])
		Rtemp_y = R4;
	else if(Yreg[5])
		Rtemp_y = R5;
	else if(Yreg[6])
		Rtemp_y = R6;
	else if(Yreg[7])
		Rtemp_y = R7;
	// Controle de estados do FSM
	always @(posedge Clock)
		begin
			case (Tstep_Q)
				T0: // Os dados são carregados no IR nesse passo
					if (!Run) 
						Tstep_Q = T0;
					else 
						Tstep_Q = T1;
				T1: 
					if (!Run) 
						Tstep_Q = T0;
					else 
						Tstep_Q = T2;
				T2: 
					if (!Run) 
						Tstep_Q = T0;
					else 
						Tstep_Q = T3;
				T3: 
					Tstep_Q = T0;
				default:
					Tstep_Q = T0;
			endcase
		end
	// Controle das saídas da FSM
	always @(Tstep_Q or I or Xreg or Yreg)
		begin
		//especifique os valores iniciais
			case (Tstep_Q)
				T0: // Armazene DIN no registrador IR no passo 0
					begin
						IRin = 1'b1;
					end
				T1:
					begin
						case(I)
							3'b000: //mv
								begin
									BusWires = RTemp;
								end
							3'b001: //mvi
								begin
									BusWires = DIN;
								end
							3'b010:	//add
								begin
									
								end
							3'b011: //sub	
								begin
									
								end
						endcase
					end
				T2:
					begin
						case(I)
							3'b010: //add
							3'b011: //sub	
						endcase
					end
				T3:
					begin
						case(I)
							3'b010: //add
							3'b011: //sub
						endcase
					end
					
			endcase
		end
	// Controle os flip-flops do FSM
	/*
	always @(posedge Clock, negedge Resetn)
		begin
			if (!Resetn)
				begin
				//Instancie outros registradores e o somador/subtrator
				//definição do barramento
				end
		end
		*/
endmodule