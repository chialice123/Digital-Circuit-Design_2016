module ox(
	Original_pos,
	Sequence,
	Line_O,
	Line_X
);

//Input Port
input [3:0] Original_pos;
input [8:0] Sequence;

//output Port
output reg [3:0] Line_O;
output reg [3:0] Line_X;
reg [8:0] save;

//Variable Declaration

//Design
always @(*) begin	
	case (Original_pos)
		4'd1:
			save = Sequence;
		4'd2:
			save = {Sequence[7:0],Sequence[8]};
		4'd3:
			save = {Sequence[6:0],Sequence[8:7]};
		4'd4:
			save = {Sequence[5:0],Sequence[8:6]};
		4'd5:
			save = {Sequence[4:0],Sequence[8:5]};
		4'd6:
			save = {Sequence[3:0],Sequence[8:4]};
		4'd7:
			save = {Sequence[2:0],Sequence[8:3]};
		4'd8:
			save = {Sequence[1:0],Sequence[8:2]};
		4'd9:
			save = {Sequence[0],Sequence[8:1]};

		default:
			save = 0;
	endcase

	Line_O=0;
	Line_X=0;
	if (save[0]==save[1] && save[1]== save[2])begin
		if (save[0]==0)
			Line_O = Line_O+1;
		else
			Line_X = Line_X+1;
	end else begin
	end
			
	if (save[3]==save[4] && save[4]== save[5])begin
		if (save[3]==0)
			Line_O = Line_O+1;
		else
			Line_X = Line_X+1;
	end else begin
	end
	
	if (save[6]==save[7] && save[7]== save[8])begin
		if (save[6]==0)
			Line_O = Line_O+1;
		else
			Line_X = Line_X+1;
	end else begin
	end
			
	if (save[0]==save[3] && save[3]== save[6])begin
		if (save[0]==0)
			Line_O = Line_O+1;
		else
			Line_X = Line_X+1;
	end else begin
	end
			
	if (save[1]==save[4] && save[4]== save[7])begin
		if (save[1]==0)
			Line_O = Line_O+1;
		else
			Line_X = Line_X+1;
	end else begin
	end
			
	if (save[2]==save[5] && save[5]== save[8])begin
		if (save[2]==0)
			Line_O = Line_O+1;
		else
			Line_X = Line_X+1;
	end else begin
	end
			
	if (save[0]==save[4] && save[4]== save[8])begin
		if (save[0]==0)
			Line_O = Line_O+1;
		else
			Line_X = Line_X+1;
	end else begin
	end
			
	if (save[2]==save[4] && save[4]== save[6])begin
		if (save[2]==0)
			Line_O = Line_O+1;
		else
			Line_X = Line_X+1;
	end else begin
	end

end
endmodule