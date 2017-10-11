module BCD(
	in_bin,
	out_hundred,
	out_ten,
	out_unit
);

//Input Ports
input 	[8:0]in_bin;

//output Ports
output reg	[2:0]out_hundred;
output reg	[3:0]out_ten;
output reg	[3:0]out_unit;

//Variable Declarations

//Design
always @*
begin
	out_hundred = in_bin/100;
	out_unit = in_bin%10;
	out_ten = in_bin/10-out_hundred*10;
end

endmodule