module test(
//input
	clk,
	rst_n,
	in,
	in_valid,
//output
	out,
	out_valid
);

//IO declaration
input clk, rst_n, in_valid;
input [7:0] in;
output logic [16:0] out;
output logic out_valid;

//parameter declaration
parameter 	IDLE = 2'b00,
			IN 	 = 2'b01,
			CAL  = 2'b10,
			OUT  = 2'b11;

//logic declaration
logic [1:0] state, next;
logic [3:0] rotate;
logic [4:0] cnt;
logic [7:0] a1, a2, a3, a4, b1, b2, b3, b4;
logic [16:0] c0, c1, c2, c3;
 
/////FSM
//current state
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		state <= IDLE;
	else
		state <= next;
end

//next state
always @* begin
	case (state)
		IDLE: 
			if (in_valid) next = IN;
			else next = IDLE;
		
		IN:
			if (!in_valid) next = CAL;
			else next = IN;
		
		CAL:
			if (out_valid) next = OUT;
			else next = CAL;
		
		OUT:
			if (!out_valid) next = IDLE;
			else next = OUT;
	endcase
end

/////your design
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		out_valid <= 0;
		out <= 0;
	end else begin
		//counter
		cnt <= cnt+1;
			
		//input
		if (in_valid) begin
			case (cnt)
				0:	rotate <= in[3:0];
				1:	a1 <= in;
				2:	a2 <= in;
				3:	a3 <= in;
				4:	a4 <= in;
				5:  b1 <= in;
				6:  b2 <= in;
				7:  b3 <= in;
				8:  b4 <= in;
			endcase
		end
		
		case (next)
			IDLE: begin
				cnt <= 0;
				out <= 0;
				c0 <= 0;
				c1 <= 0;
				c2 <= 0;
				c3 <= 0;
			end
			
			CAL: begin
				case (cnt)
					9: begin
						case (rotate[3:2])
							1: begin
								a1 <= a3;
								a2 <= a1;
								a3 <= a4;
								a4 <= a2;
							end
							2: begin
								a1 <= a4;
								a2 <= a3;
								a3 <= a2;
								a4 <= a1;
							end
							3: begin
								a1 <= a2;
								a2 <= a4;
								a3 <= a1;
								a4 <= a3;
							end
						endcase
					end
					
					10: begin
						case (rotate[1:0])
							1: begin
								b1 <= b3;
								b2 <= b1;
								b3 <= b4;
								b4 <= b2;
							end
							2: begin
								b1 <= b4;
								b2 <= b3;
								b3 <= b2;
								b4 <= b1;
							end
							3: begin
								b1 <= b2;
								b2 <= b4;
								b3 <= b1;
								b4 <= b3;
							end
						endcase
					end
					
					11: c0 <= a1*b1[3:0];
					12: c0 <= c0 + ((a1*b1[7:4])<<4);
					13: c0 <= c0 + a2*b3[3:0];
					14: c0 <= c0 + ((a2*b3[7:4])<<4);
					15: c1 <= a1*b2[3:0];
					16: c1 <= c1 + ((a1*b2[7:4])<<4);
					17: c1 <= c1 + a2*b4[3:0];
					18: c1 <= c1 + ((a2*b4[7:4])<<4);
					19: c2 <= a3*b1[3:0];
					20: c2 <= c2 + ((a3*b1[7:4])<<4);
					21: c2 <= c2 + a4*b3[3:0];
					22: c2 <= c2 + ((a4*b3[7:4])<<4);
					23: c3 <= a3*b2[3:0];
					24: c3 <= c3 + ((a3*b2[7:4])<<4);
					25: c3 <= c3 + a4*b4[3:0];
					26: c3 <= c3 + ((a4*b4[7:4])<<4);
					27: begin
						out <= c0;
						out_valid <= 1;
					end
				endcase
			end
			
			OUT: begin
				case (cnt) 
					28: out <= c1;
					29: out <= c2;
					30: out <= c3;
					31: out_valid <= 0;
				endcase
			end
		endcase			
	end

end

endmodule