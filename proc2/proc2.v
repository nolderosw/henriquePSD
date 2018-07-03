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
	wire [2:0] Xreg;
	wire [2:0] Yreg;
	wire [8:0] R0;
	wire [8:0] R1;
	wire [8:0] R2;
	wire [8:0] R3;
	wire [8:0] R4;
	wire [8:0] R5;
	wire [8:0] R6;
	wire [8:0] R7;
	wire [2:0] I;
	reg IRin;
	regn reg_IR (DIN, IRin, Clock, IRout);
	assign I = IRout[0:2];
	dec3to8 decX (IRout[3:5], 1'b1, Xreg);
	dec3to8 decY (IRout[6:8], 1'b1, Yreg);
	regn reg_0 (BusWires, Rin[0], Clock, R0);
	regn reg_1 (BusWires, Rin[1], Clock, R1);
	regn reg_2 (BusWires, Rin[2], Clock, R2);
	regn reg_3 (BusWires, Rin[3], Clock, R3);
	regn reg_4 (BusWires, Rin[4], Clock, R4);
	regn reg_5 (BusWires, Rin[5], Clock, R5);
	regn reg_6 (BusWires, Rin[6], Clock, R6);
	regn reg_7 (BusWires, Rin[7], Clock, R7);
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