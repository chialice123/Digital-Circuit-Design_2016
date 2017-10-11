module core(
//input
clk,
in,
in_s,
in_valid,
rst_n,
//output
out,
order,
out_valid
);

//IO declaration
input [6:0] in, in_s;
input rst_n, in_valid, clk;
output logic [6:0] out;
output logic [2:0] order;
output logic out_valid;

//parameter declaration
parameter 	IDLE = 2'b00,
			IN 	 = 2'b01,
			EX   = 2'b10,
			OUT  = 2'b11;

//logic declaration
logic [1:0] state, next;
logic [6:0] in_arr [6:0];
logic [6:0] srh, temp;
logic [5:0] cnt, cnt_temp;
logic [2:0] i;

/////FSM
initial begin
	out_valid = 0;
	order = 0;
	out = 0;
	cnt = 0;
	cnt_temp = 0;
	i = 0;
end

//current state
always @(next or rst_n) begin
	if(!rst_n) begin
		state = IDLE;
	end else begin
		state = next;
	end
end

//next state
always @(state or in_valid or out_valid) begin
	case (state)
		IDLE: 
			if (in_valid) next = IN;
			else next = IDLE;
		
		IN:
			if (!in_valid) next = EX;
			else next = IN;
		
		EX:
			if (out_valid) next = OUT;
			else next = EX;
		
		OUT:
			if (!out_valid) next = IDLE;
			else next = OUT;
	endcase
end

/////your design
always @(posedge clk) begin
	if (state==IDLE) begin
		cnt <= 0;
	end else begin
		cnt <= cnt+1;
	end
	
	case (state)
		IDLE: begin
			out <= 0;
			order <= 0;
			cnt_temp <= 0;
		end
		
		IN: begin
			if (cnt==cnt_temp) begin
				srh <= in_s;
				in_arr[0] <= in;
			end else begin
				in_arr[cnt-cnt_temp] <= in;
			end
			i <= 0;
		end
		
		EX: begin
			if (cnt<50) begin
				//sorting
				if (i<7)
					i <= i+1;
				else
					i <= 0;
				
				if (in_arr[i]<in_arr[i+1]) begin
					in_arr[i] <= in_arr[i+1];
					in_arr[i+1] <= in_arr[i];
				end else begin
					in_arr[i] <= in_arr[i];
					in_arr[i+1] <= in_arr[i+1];
				end
				
			end else begin
				//searching
				if (srh==in_arr[0])
					order <= 1;
				else if (srh==in_arr[1])
					order <= 2;
				else if (srh==in_arr[2])
					order <= 3;
				else if (srh==in_arr[3])
					order <= 4;
				else if (srh==in_arr[4])
					order <= 5;
				else if (srh==in_arr[5])
					order <= 6;
				else if (srh==in_arr[6])
					order <= 7;
				else
					order <= 0;
				
				cnt_temp <= cnt;
				out_valid <= 1;
				out <= in_arr[0];
			end
			
		end
		
		OUT: begin
			if (cnt==cnt_temp) begin
				order <= order;
				out <= in_arr[0];
				$display("out: %d %d %d %d %d %d %d, order: %d ",in_arr[0],in_arr[1],in_arr[2],in_arr[3],in_arr[4],in_arr[5],in_arr[6], order);
			end else if (cnt==cnt_temp+7) begin
				out_valid <= 0;
			end else begin
				order <= 0;
				out <= in_arr[cnt-cnt_temp];
			end
		end
	endcase
end


endmodule

