module LFSR(out,clk,rst);
	output reg [4:0] out;
	input clk,rst;
	wire feedback;
	assign feedback = ~(out[2]^out[4]);
	always@(posedge clk,posedge rst)
		begin
			if(rst) 
				out = 5'b0;
			else
				out = {out[3:0],feedback};
		end
endmodule

module test_zero_one;

reg A, clk, rst;
wire Y;
wire [4:0] out;
wire randomizer;
integer i;

zero_one_detector dut(A, clk, rst, Y);

LFSR shift_rgstr(out, clk, rst);
assign randomizer = shift_rgstr.out[0];

always
begin 
	clk = 1; #5;
	clk = 0; #5;
end
initial
begin
		rst = 1;
 #5 rst = 0;
end

initial
begin
	$dumpfile ("dump.vcd");
	$dumpvars (0, dut);

		for(i = 0; i <= 15; i = i + 1)
		begin
			A = randomizer; #10;
			$display("Current State = ", dut.state, "  Input = ", A, "  Output = ", Y);
		end
		$finish;
end
endmodule
