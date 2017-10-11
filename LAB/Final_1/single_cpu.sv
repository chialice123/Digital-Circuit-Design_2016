module single_cpu(
	//input
	clk,
	rst_n,
	in_valid,
	instruction,
	dout,
	//output
	out_valid,
	ren,
	wen,
	addr,
	din,
	out0,
	out1,
	out2,
	out3,
	out4,
	out5,
	out6,
	out7,
	out8,
	out9,
	out10,
	out11,
	out12,
	out13,
	out14,
	out15
);

//IO declaration
input clk, rst_n, in_valid;
input [18:0] instruction;
input [15:0] dout;
output logic out_valid, ren, wen;
output logic [15:0] out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10,
					out11, out12, out13, out14, out15, din;
output logic [3:0] addr;

//register used to save data temporarily
logic [18:0] in;
logic [15:0] rd, rs, rt, rl;
logic [3:0] cnt;
logic [31:0] temp;
logic ok;

//parameter declaration
parameter 	IDLE = 2'b00,
			IN 	 = 2'b01,
			CAL  = 2'b10,
			OUT  = 2'b11;

//logic declaration
logic [1:0] state, next;

//-------------------------------------------------------
//   Finite state machine
//-------------------------------------------------------
//current state
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		state <= IDLE;
	else
		state <= next;
end

//next state
always_comb begin
	case (state)
		IDLE: 
			if (in_valid) next = IN;
			else next = IDLE;
			
		IN:
			if (!in_valid) next = CAL;
			else next = IN;
		
		CAL:
			if (ok) next = OUT;
			else next = CAL;
		
		OUT:
			if (!out_valid) next = IDLE;
			else next = OUT;
	endcase
end

//-------------------------------------------------------
//   Your design
//-------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		ok <= 0;
		temp <= 0;
		out_valid <= 0;
		out0 <= 0;
		out1 <= 0;
		out2 <= 0;
		out3 <= 0;
		out4 <= 0;
		out5 <= 0;
		out6 <= 0;
		out7 <= 0;
		out8 <= 0;
		out9 <= 0;
		out10 <= 0;
		out11 <= 0;
		out12 <= 0;
		out13 <= 0;
		out14 <= 0;
		out15 <= 0;
		ren <= 0;
		wen <= 0;
		addr <= 0;
		din <= 0;
	end else begin
		//counter
		if (state==CAL || state==OUT) begin
			cnt <= cnt+1;
		end else begin
			cnt <= 0;
		end
		
		//input
		if (in_valid)
			in <= instruction;
			
		if (next==OUT)
			out_valid <= 1;
			
		case (state)
			IDLE: begin
				ok <= 0;
				out_valid <= 0;
				temp <= 0;
				ren <= 0;
				wen <= 0;
				addr <= 0;
				din <= 0;
			end
			
			CAL: begin
				if (cnt==0) begin
					case (in[15:12])
						4'd0: rs <= out0;
						4'd1: rs <= out1;
						4'd2: rs <= out2;
						4'd3: rs <= out3;
						4'd4: rs <= out4;
						4'd5: rs <= out5;
						4'd6: rs <= out6;
						4'd7: rs <= out7;
						4'd8: rs <= out8;
						4'd9: rs <= out9;
						4'd10: rs <= out10;
						4'd11: rs <= out11;
						4'd12: rs <= out12;
						4'd13: rs <= out13;
						4'd14: rs <= out14;
						4'd15: rs <= out15;		
					endcase
				end else if (cnt==1) begin
					case (in[11:8])
						4'd0: rt <= out0;
						4'd1: rt <= out1;
						4'd2: rt <= out2;
						4'd3: rt <= out3;
						4'd4: rt <= out4;
						4'd5: rt <= out5;
						4'd6: rt <= out6;
						4'd7: rt <= out7;
						4'd8: rt <= out8;
						4'd9: rt <= out9;
						4'd10: rt <= out10;
						4'd11: rt <= out11;
						4'd12: rt <= out12;
						4'd13: rt <= out13;
						4'd14: rt <= out14;
						4'd15: rt <= out15;
					endcase
				end else begin //cnt starts from 2
					case (in[18:16])
						3'b000: begin
							if (cnt==2) begin
								case (in[3:0])
									4'b0000: rd <= rs & rt;
									4'b0001: rd <= rs | rt;
									4'b0010: rd <= rs + rt;
									4'b0011: begin
										if (rs>rt) rd <= rs-rt;
										else rd <= rt-rs;
									end
								endcase
							end else begin
								case (in[7:4])
									4'd0: out0 <= rd;
									4'd1: out1 <= rd;
									4'd2: out2 <= rd;
									4'd3: out3 <= rd;
									4'd4: out4 <= rd;
									4'd5: out5 <= rd;
									4'd6: out6 <= rd;
									4'd7: out7 <= rd;
									4'd8: out8 <= rd;
									4'd9: out9 <= rd;
									4'd10: out10 <= rd;
									4'd11: out11 <= rd;
									4'd12: out12 <= rd;
									4'd13: out13 <= rd;
									4'd14: out14 <= rd;
									4'd15: out15 <= rd;
								endcase
								ok <= 1;
								cnt <= 0;
							end
							
						end
						
						3'b001: begin
							if (cnt==2)
								temp <= temp + rs*rt[3:0];
							else if (cnt==3)
								temp <= temp + ((rs*rt[7:4])<<4);
							else if (cnt==4)
								temp <= temp + ((rs*rt[11:8])<<8);
							else if (cnt==5)
								temp <= temp + ((rs*rt[15:12])<<12);
							else if (cnt==6)
								{rd[15:0],rl[15:0]} <= temp;
							else begin
								case (in[7:4])
									4'd0: out0 <= rd;
									4'd1: out1 <= rd;
									4'd2: out2 <= rd;
									4'd3: out3 <= rd;
									4'd4: out4 <= rd;
									4'd5: out5 <= rd;
									4'd6: out6 <= rd;
									4'd7: out7 <= rd;
									4'd8: out8 <= rd;
									4'd9: out9 <= rd;
									4'd10: out10 <= rd;
									4'd11: out11 <= rd;
									4'd12: out12 <= rd;
									4'd13: out13 <= rd;
									4'd14: out14 <= rd;
									4'd15: out15 <= rd;
								endcase
								case (in[3:0])
									4'd0: out0 <= rl;
									4'd1: out1 <= rl;
									4'd2: out2 <= rl;
									4'd3: out3 <= rl;
									4'd4: out4 <= rl;
									4'd5: out5 <= rl;
									4'd6: out6 <= rl;
									4'd7: out7 <= rl;
									4'd8: out8 <= rl;
									4'd9: out9 <= rl;
									4'd10: out10 <= rl;
									4'd11: out11 <= rl;
									4'd12: out12 <= rl;
									4'd13: out13 <= rl;
									4'd14: out14 <= rl;
									4'd15: out15 <= rl;
								endcase
								ok <= 1;
								cnt <= 0;
							end
						end
						
						3'b010:begin
							if (cnt==2)
								rt <= rs + in[7:0];
							else begin
								case (in[11:8])
									4'd0: out0 <= rt;
									4'd1: out1 <= rt;
									4'd2: out2 <= rt;
									4'd3: out3 <= rt;
									4'd4: out4 <= rt;
									4'd5: out5 <= rt;
									4'd6: out6 <= rt;
									4'd7: out7 <= rt;
									4'd8: out8 <= rt;
									4'd9: out9 <= rt;
									4'd10: out10 <= rt;
									4'd11: out11 <= rt;
									4'd12: out12 <= rt;
									4'd13: out13 <= rt;
									4'd14: out14 <= rt;
									4'd15: out15 <= rt;
								endcase
								ok <= 1;
								cnt <= 0;
							end
						end
						
						3'b011: begin
							if (cnt==2) begin
								if (rs>in[7:0])
									rt <= rs - in[7:0];
								else 
									rt <= in[7:0] - rs;
							end else begin
								case (in[11:8])
									4'd0: out0 <= rt;
									4'd1: out1 <= rt;
									4'd2: out2 <= rt;
									4'd3: out3 <= rt;
									4'd4: out4 <= rt;
									4'd5: out5 <= rt;
									4'd6: out6 <= rt;
									4'd7: out7 <= rt;
									4'd8: out8 <= rt;
									4'd9: out9 <= rt;
									4'd10: out10 <= rt;
									4'd11: out11 <= rt;
									4'd12: out12 <= rt;
									4'd13: out13 <= rt;
									4'd14: out14 <= rt;
									4'd15: out15 <= rt;
								endcase
								ok <= 1;
								cnt <= 0;
							end
						end

						3'b100: begin
							if (cnt==2) begin
								wen <= 1;
								addr <= rs[3:0];
								din <= rt + in[7:0];
							end else begin
								case (in[11:8])
									4'd0: out0 <= 0;
									4'd1: out1 <= 0;
									4'd2: out2 <= 0;
									4'd3: out3 <= 0;
									4'd4: out4 <= 0;
									4'd5: out5 <= 0;
									4'd6: out6 <= 0;
									4'd7: out7 <= 0;
									4'd8: out8 <= 0;
									4'd9: out9 <= 0;
									4'd10: out10 <= 0;
									4'd11: out11 <= 0;
									4'd12: out12 <= 0;
									4'd13: out13 <= 0;
									4'd14: out14 <= 0;
									4'd15: out15 <= 0;
								endcase
								ok <= 1;
								cnt <= 0;
							end
						end
						
						3'b101: begin
							if(cnt==2) begin
								ren <= 1;
								addr <= rs[3:0];
							end else if (cnt==3) begin
								ren <= 0;
								rt <= dout + in[7:0];
							end else begin
								case (in[11:8])
									4'd0: out0 <= rt;
									4'd1: out1 <= rt;
									4'd2: out2 <= rt;
									4'd3: out3 <= rt;
									4'd4: out4 <= rt;
									4'd5: out5 <= rt;
									4'd6: out6 <= rt;
									4'd7: out7 <= rt;
									4'd8: out8 <= rt;
									4'd9: out9 <= rt;
									4'd10: out10 <= rt;
									4'd11: out11 <= rt;
									4'd12: out12 <= rt;
									4'd13: out13 <= rt;
									4'd14: out14 <= rt;
									4'd15: out15 <= rt;
								endcase
								ok <= 1;
								cnt <= 0;
							end
						end
					endcase
				end
			end
			
			OUT: begin
				if (cnt) begin
					out_valid <= 0;
					ok <= 0;
				end
			end

		endcase
	end
end
endmodule