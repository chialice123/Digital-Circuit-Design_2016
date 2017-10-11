module vm(
//input
	clk,
	rst_n,
	in_valid,
	in_valid_price,
	btn_coin_rtn,
	coin_in,
	btn_item,
	item_price,
//output
	out_valid,
	item_out,
	coin_out_1,
	coin_out_5,
	coin_out_10,
	coin_out_50
);

//IO declaration
input clk, rst_n, in_valid_price, in_valid;
input [4:0] item_price;
input [5:0] coin_in;
input [2:0] btn_item;
input btn_coin_rtn;

output logic out_valid;
output logic [2:0] item_out;
output logic [2:0] coin_out_50, coin_out_10, coin_out_5, coin_out_1;

//parameter declaration
parameter 	IDLE = 3'b000,
			INp	 = 3'b001,
			INc	 = 3'b010,
			CAL  = 3'b011,
			OUT  = 3'b100;

//logic declaration
logic [2:0] state, next;
logic [5:0] cnt, cnt_temp;
logic [7:0] money;
logic [4:0] buy;
logic cal, crtn;
logic [4:0] i1, i2, i3, i4, i5, i6, i7;

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
			if (in_valid_price) next = INp;
			else if (in_valid)	next = INc;
			else if (cal) next = CAL;
			else next = IDLE;
		
		INp:
			if (!in_valid_price) next = IDLE;
			else next = INp;
			
		INc:
			if (!in_valid) next = IDLE;
			else next = INc;
		
		CAL:
			if (out_valid) next = OUT;
			else next = CAL;
		
		OUT:
			if (!out_valid) next = IDLE;
			else next = OUT;
		default:
			next = IDLE;
	endcase
end
//-------------------------------------------------------
//   Your design
//-------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		out_valid <= 0;
		item_out <= 0;
		money <= 0;
		coin_out_1 <= 0;
		coin_out_5 <= 0;
		coin_out_10 <= 0;
		coin_out_50 <= 0;
	end else begin
		//counter
		if (next==IDLE) begin
			cnt <= 0;
		end else begin
			cnt <= cnt+1;
		end
			
		//input
		if (in_valid) begin
			case (cnt-cnt_temp)
				0:	money <= money+coin_in;
				1:	money <= money+coin_in;
				2:	money <= money+coin_in;
				3:	money <= money+coin_in;
				4:	begin
					buy <= btn_item;
					crtn <= btn_coin_rtn;
				end
				//default: begin end
			endcase
		end //else begin end
		
		if (in_valid_price) begin			
			case(cnt-cnt_temp)
				0:	i1 <= item_price;
				1:	i2 <= item_price;
				2:	i3 <= item_price;
				3:	i4 <= item_price;
				4:	i5 <= item_price;
				5:	i6 <= item_price;
				6:	i7 <= item_price;
				//default: begin end
			endcase
		end //else begin end


		case (next)
			IDLE: begin
				cnt_temp <= 0;
				if (i1 && i2 && i3 && i4 && i5 && i6 && i7 && (crtn||buy))
					cal <= 1;
				else
					cal <= 0;	
			end
			
			INp: begin
			end

			INc: begin
			end

			CAL: begin
				if (cnt==0) begin
					if (crtn) begin
						item_out <= 0;
					end else begin
						item_out <= buy;
						case(buy)
							1: buy <= i1;
							2: buy <= i2;
							3: buy <= i3;
							4: buy <= i4;
							5: buy <= i5;
							6: buy <= i6;
							7: buy <= i7;
							//default: begin end
						endcase
					end
				end else begin
					if (crtn) begin
						if (money>=50) begin
							money <= money-50;
							coin_out_50 <= coin_out_50+1;
						end else if (money>=10) begin
							money <= money-10;
							coin_out_10 <= coin_out_10+1;
						end else if (money>=5) begin
							money <= money-5;
							coin_out_5 <= coin_out_5+1;
						end else if (money>=1) begin
							money <= money-1;
							coin_out_1 <= coin_out_1+1;
						end else begin
							cal <= 0;
							out_valid <= 1;
							cnt <= 0;
						end
					end else begin
						if (money>=buy) begin
							money <= money-buy;
							crtn <= 1;
						end else begin
							item_out <= 0;
							cal <= 0;
							cnt <= 0;
							out_valid <= 1;
						end
					end
				end
			end
			
			OUT: begin
				if (cnt) begin
					out_valid <= 0;
					item_out <= 0;
					coin_out_1 <= 0;
					coin_out_5 <= 0;
					coin_out_10 <= 0;
					coin_out_50 <= 0;
				end else begin
					crtn <= 0;
					buy <= 0;
				end
			end
		endcase			
	end

end


endmodule




