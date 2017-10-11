`ifdef RTL
	`timescale 1ns/100ps
`endif

`define CLK_PERIOD 30.0

module PATTERN(
	//output
	Original_pos,
	Sequence,
	//input
	Line_O,
	Line_X
);


//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
output reg [3:0] Original_pos;
output reg [8:0] Sequence;
input [3:0] Line_O;
input [3:0] Line_X;

//---------------------------------------------------------------------
//   PARAMETER DECLARATION
//---------------------------------------------------------------------
parameter pattern_num = 2500;
reg [8:0] save;
logic [3:0] lineo;
logic [3:0] linex;

//---------------------------------------------------------------------
//   CLK DECLARATION                             
//---------------------------------------------------------------------
logic CLK;
real CYCLE;
initial begin
	CLK=0;
	CYCLE=`CLK_PERIOD;
end
always #(CYCLE/2) CLK = ~CLK;

//---------------------------------------------------------------------
//   MAIN FLOW                                         
//---------------------------------------------------------------------
integer i;

initial begin
	i=0;
	Original_pos=4'b0;
	Sequence=9'b0;
	
	for(i=1;i<=pattern_num;i=i+1) begin
		@(negedge CLK);				//give input
		// produce pattern input
		Original_pos = $urandom_range(9,0);
		Sequence = $urandom_range(511,0);
		
		////////////////////////////////////////////////////////////
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

		lineo=0;
		linex=0;
		if (save[0]==save[1] && save[1]== save[2])begin
			if (save[0]==0)
				lineo = lineo+1;
			else
				linex = linex+1;
		end else begin
		end
			
		if (save[3]==save[4] && save[4]== save[5])begin
			if (save[3]==0)
				lineo = lineo+1;
			else
				linex = linex+1;
		end else begin
		end
	
		if (save[6]==save[7] && save[7]== save[8])begin
			if (save[6]==0)
				lineo = lineo+1;
			else
				linex = linex+1;
		end else begin
		end

		if (save[0]==save[3] && save[3]== save[6])begin
			if (save[0]==0)
				lineo = lineo+1;
			else
				linex = linex+1;
		end else begin
		end
			
		if (save[1]==save[4] && save[4]== save[7])begin
			if (save[1]==0)
				lineo = lineo+1;
			else
				linex = linex+1;
		end else begin
		end
			
		if (save[2]==save[5] && save[5]== save[8])begin
			if (save[2]==0)
				lineo = lineo+1;
			else
				linex = linex+1;
		end else begin
		end
			
		if (save[0]==save[4] && save[4]== save[8])begin
			if (save[0]==0)
				lineo = lineo+1;
			else
				linex = linex+1;
		end else begin
		end
			
		if (save[2]==save[4] && save[4]== save[6])begin
			if (save[2]==0)
				lineo = lineo+1;
			else
				linex = linex+1;
		end else begin
		end
		
		@(negedge CLK);
		if((lineo==Line_O)&&(linex==Line_X)) begin
			$display("all pass");
		end else begin
			$display("----------------------------------------------------------------------");
			$display("   at initial_pos = # %d and seq = # %b ",Original_pos, Sequence);
			$display ("                    Error !! The answer is wrong!                    ");
			$display(" Your answer is Line_X = %d, Line_O = %d ",Line_X, Line_O);
			$display(" The correct answer is X = %d, O = %d ",linex, lineo);
			$display("----------------------------------------------------------------------");
			$finish;
		end
	end
end

//---------------------------------------------------------------------
//   TASK or FUNCTION DECLARATION                                         
//---------------------------------------------------------------------
endmodule
