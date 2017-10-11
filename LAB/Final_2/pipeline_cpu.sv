module pipeline_cpu(
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
	out_addr,
	din,
	out
);
//IO declaration
input clk, rst_n, in_valid;
input [18:0] instruction;
input [15:0] dout;

output logic out_valid, ren, wen;
output logic [15:0] out, din;
output logic [3:0] out_addr, addr;

//logic declaration
logic [18:0] in, in1, in2;
logic [15:0] out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15;
logic [19:0] rd, rs, rt, rl;
logic [19:0] rd1, rs1, rt1, rl1;
logic [19:0] rd2, rs2, rt2, rl2;

//control signal declaration
logic ok_in, ok_cal1, ok_cal2;

//input instruction
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rs <= 0;
		rt <= 0;
		ok_in <= 0;
		in <= 0;
	end else if (in_valid) begin
		ok_in <= 1;
		in <= instruction;
		//store rs
		case (instruction[15:12])
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
		//store rt
		case (instruction[11:8])
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
	end else
		ok_in <= 0;
end

//ALU
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		//ALU1
		rd1 <= 0;
		rs1 <= 0;
		rt1 <= 0;
		rl1 <= 0;
		ok_cal1 <= 0;
		din <= 0;
		ren <= 0;
		wen <= 0;
		in1 <= 0;
		addr <= 0;
		
		//ALU2
		rd2 <= 0;
		rs2 <= 0;
		rt2 <= 0;
		rl2 <= 0;
		in2 <= 0;
		ok_cal2 <= 0;
	end else begin
		if (ok_in) begin
			in1 <= in;
			rd1 <= 0;
			rl1 <= 0;
			ok_cal1 <= 1;
			rs1 <= rs;
			rt1 <= rt;
			case (in[18:16])
				3'b000: begin
					case (in[3:0])
						4'b0000: rd1 <= rs & rt;
						4'b0001: rd1 <= rs | rt;
						4'b0010: rd1 <= rs + rt;
						4'b0011: begin
							if (rs>rt) rd1 <= rs-rt;
							else rd1 <= rt-rs;
						end
					endcase
				end
					
				3'b001: begin
					rd1 <= rs[15:0]*rt[15:12];
					rs1 <= rs[15:0]*rt[11:8];
					rt1 <= rs[15:0]*rt[7:4];
					rl1 <= rs[15:0]*rt[3:0];
				end
					
				3'b010: begin
					rt1 <= rs + in[7:0];
				end
								
				3'b011: begin
					if (rs>in[7:0])
						rt1 <= rs - in[7:0];
					else 
						rt1 <= in[7:0] - rs;
				end
								
				3'b100: begin
					wen <= 1;
					addr <= rs[3:0];
					din <= rt + in[7:0];
				end
						
				3'b101: begin
					ren <= 1;
					addr <= rs[3:0];
				end
			endcase
		end else begin
			ok_cal1 <= 0;
		end
		
		if (ok_cal1) begin
			ok_cal2 <= 1;
			in2 <= in1;
			rd2 <= rd1;
			rs2 <= rs1;
			rt2 <= rt1;
			rl2 <= rl1;
			case (in1[18:16])
				3'b001: begin
					{rd2[15:0],rl2[15:0]} <= (rd1<<12)+(rs1<<8)+(rt1<<4)+rl1;
				end
				
				3'b100: begin
					rl2 <= din;
					wen <= 0;
				end
						
				3'b101: begin
					ren <= 0;
					rt2 <= dout + in1[7:0];
				end
			endcase
		end else begin
			ok_cal2 <= 0;
		end
	end
end

//output
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		out <= 0;
		out_addr <= 0;
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
		out_valid <= 0;
	end else if (ok_cal2) begin
		out_valid <= 1;
		case (in2[18:16])
			3'b000: begin
				out <= rd2;
				out_addr <= in2[7:4];
				case (in2[7:4])
					4'd0: out0 <= rd2;
					4'd1: out1 <= rd2;
					4'd2: out2 <= rd2;
					4'd3: out3 <= rd2;
					4'd4: out4 <= rd2;
					4'd5: out5 <= rd2;
					4'd6: out6 <= rd2;
					4'd7: out7 <= rd2;
					4'd8: out8 <= rd2;
					4'd9: out9 <= rd2;
					4'd10: out10 <= rd2;
					4'd11: out11 <= rd2;
					4'd12: out12 <= rd2;
					4'd13: out13 <= rd2;
					4'd14: out14 <= rd2;
					4'd15: out15 <= rd2;
				endcase
			end
		
			3'b001: begin
				out <= rd2&rl2;
				out_addr <= in2[7:4]+in2[3:0];
				case (in2[7:4])
					4'd0: out0 <= rd2;
					4'd1: out1 <= rd2;
					4'd2: out2 <= rd2;
					4'd3: out3 <= rd2;
					4'd4: out4 <= rd2;
					4'd5: out5 <= rd2;
					4'd6: out6 <= rd2;
					4'd7: out7 <= rd2;
					4'd8: out8 <= rd2;
					4'd9: out9 <= rd2;
					4'd10: out10 <= rd2;
					4'd11: out11 <= rd2;
					4'd12: out12 <= rd2;
					4'd13: out13 <= rd2;
					4'd14: out14 <= rd2;
					4'd15: out15 <= rd2;
				endcase
				case (in2[3:0])
					4'd0: out0 <= rl2;
					4'd1: out1 <= rl2;
					4'd2: out2 <= rl2;
					4'd3: out3 <= rl2;
					4'd4: out4 <= rl2;
					4'd5: out5 <= rl2;
					4'd6: out6 <= rl2;
					4'd7: out7 <= rl2;
					4'd8: out8 <= rl2;
					4'd9: out9 <= rl2;
					4'd10: out10 <= rl2;
					4'd11: out11 <= rl2;
					4'd12: out12 <= rl2;
					4'd13: out13 <= rl2;
					4'd14: out14 <= rl2;
					4'd15: out15 <= rl2;
				endcase
			end
			
			3'b010: begin
				out_addr <= in2[11:8];
				out <= rt2;
				case (in2[11:8])
					4'd0: out0 <= rt2;
					4'd1: out1 <= rt2;
					4'd2: out2 <= rt2;
					4'd3: out3 <= rt2;
					4'd4: out4 <= rt2;
					4'd5: out5 <= rt2;
					4'd6: out6 <= rt2;
					4'd7: out7 <= rt2;
					4'd8: out8 <= rt2;
					4'd9: out9 <= rt2;
					4'd10: out10 <= rt2;
					4'd11: out11 <= rt2;
					4'd12: out12 <= rt2;
					4'd13: out13 <= rt2;
					4'd14: out14 <= rt2;
					4'd15: out15 <= rt2;
				endcase
			end
			
			3'b011: begin
				out_addr <= in2[11:8];
				out <= rt2;
				case (in2[11:8])
					4'd0: out0 <= rt2;
					4'd1: out1 <= rt2;
					4'd2: out2 <= rt2;
					4'd3: out3 <= rt2;
					4'd4: out4 <= rt2;
					4'd5: out5 <= rt2;
					4'd6: out6 <= rt2;
					4'd7: out7 <= rt2;
					4'd8: out8 <= rt2;
					4'd9: out9 <= rt2;
					4'd10: out10 <= rt2;
					4'd11: out11 <= rt2;
					4'd12: out12 <= rt2;
					4'd13: out13 <= rt2;
					4'd14: out14 <= rt2;
					4'd15: out15 <= rt2;
				endcase
			end
					
			3'b100: begin
				out <= rl2;
				case (in2[11:8])
					4'd0: out_addr <= out0[3:0];
					4'd1: out_addr <= out1[3:0];
					4'd2: out_addr <= out2[3:0];
					4'd3: out_addr <= out3[3:0];
					4'd4: out_addr <= out4[3:0];
					4'd5: out_addr <= out5[3:0];
					4'd6: out_addr <= out6[3:0];
					4'd7: out_addr <= out7[3:0];
					4'd8: out_addr <= out8[3:0];
					4'd9: out_addr <= out9[3:0];
					4'd10: out_addr <= out10[3:0];
					4'd11: out_addr <= out11[3:0];
					4'd12: out_addr <= out12[3:0];
					4'd13: out_addr <= out13[3:0];
					4'd14: out_addr <= out14[3:0];
					4'd15: out_addr <= out15[3:0];
				endcase
			end
			
			3'b101: begin
				out_addr <= in2[11:8];
				out <= rt2;
				case (in2[11:8])
					4'd0: out0 <= rt2;
					4'd1: out1 <= rt2;
					4'd2: out2 <= rt2;
					4'd3: out3 <= rt2;
					4'd4: out4 <= rt2;
					4'd5: out5 <= rt2;
					4'd6: out6 <= rt2;
					4'd7: out7 <= rt2;
					4'd8: out8 <= rt2;
					4'd9: out9 <= rt2;
					4'd10: out10 <= rt2;
					4'd11: out11 <= rt2;
					4'd12: out12 <= rt2;
					4'd13: out13 <= rt2;
					4'd14: out14 <= rt2;
					4'd15: out15 <= rt2;
				endcase
			end
		endcase
	end
end
endmodule