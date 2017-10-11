module ALU(
	instruction,
	out
);

//Input Port
input [10:0] instruction;

//output Port
output reg [8:0] out;

//Variable Declaration

//Design
always @(instruction)
begin
	case(instruction[10:8])
		3'b000: out = instruction[7:4]+instruction[3:0];
		3'b001: 
		begin
			if (instruction[7:4]>instruction[3:0])
				out = instruction[7:4]-instruction[3:0];
			else 
				out = instruction[3:0]-instruction[7:4];
		end
		3'b010:
			out = instruction[7:4]*instruction[3:0];
		3'b011:
			out = (instruction[7:4]+instruction[3:0]+15)*64/7;
		3'b100:
			out = (instruction[7:4]+instruction[3:0])<<2;
		default:
			out = 0;
	endcase
end

endmodule