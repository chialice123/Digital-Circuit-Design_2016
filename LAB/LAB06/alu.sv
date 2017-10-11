module alu(
//input
	clk,
	rst_n,
	instruction,
	in_valid,
//output
	out,
	out_valid
);

//IO declaration
input clk, rst_n, in_valid;
input [21:0] instruction;
output logic out_valid;
output logic [19:0] out;

//parameter declaration
parameter 	IDLE = 2'b00,
			IN 	 = 2'b01,
			CAL  = 2'b10,
			OUT  = 2'b11;

//logic declaration
logic [1:0] state, next;
logic [1:0] op;
logic [9:0] d1, d2;
logic [9:0] cnt;
logic [14:0] a;
logic [19:0] b;
logic [21:0] in;

/////FSM

//current state
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		state <= IDLE;
	else
		state <= next;
end

//next state
always @(*) begin
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
		out <= 0;
		out_valid <= 0;
	end else begin
		if (state==CAL || state==OUT) begin
			cnt <= cnt+1;
		end else begin
			cnt <= 0;
		end
		
		//INPUT
		if (in_valid)
			in <= instruction;

		case (state)
			IDLE: begin
				out <= 0;
				out_valid <= 0;
			end
			
			CAL: begin
				if (cnt==0) begin
					op <= in[21:20];
					d1 <= in[19:10];
					d2 <= in[9:0];
				end else if (cnt==1) begin
					if (d1<d2) begin
						d1 <= d2;
						d2 <= d1;
					end else begin
					end
				end else begin
					case (op)
						2'b00: begin
							if (cnt==2) begin
								out <= d1-d2;
							end	else begin
								cnt <= 0;
								out_valid <= 1;
							end
						end
						
						2'b01: begin
							if (cnt==2) begin
								a <= d1*d2[4:0];
							end else if (cnt==3) begin
								b <= ((d1*d2[9:5])<<5);
							end else if (cnt==4) begin
								out <= a+b;
							end else begin
								cnt <= 0;
								out_valid <= 1;
							end
						end
						
						2'b10: begin
							if (d2!=0) begin
								if (d1>=d2) begin
									d1 <= d1-d2;
								end else begin
									d1 <= d2;
									d2 <= d1;
								end
							end else begin
								out <= d1;
								cnt <= 0;
								out_valid <= 1;
							end
						end
						
						2'b11: begin
							if (cnt==2) begin
								a <= (d1[9:5]+d1[4:0])*(d1[9:5]+d1[4:0]);
							end else if (cnt==3) begin
								b <= (d2[9:5]+d2[4:0])*(d2[9:5]+d2[4:0]);
							end else if (cnt==4) begin
								out <= a+b;
							end else begin
								cnt <= 0;
								out_valid <= 1;
							end
						end
					endcase
				end
			end
			
			OUT: begin
				if (cnt==0) begin
				end else begin
					out_valid <= 0;
					out <= 0;
				end
			end
		endcase
	end
end

endmodule
