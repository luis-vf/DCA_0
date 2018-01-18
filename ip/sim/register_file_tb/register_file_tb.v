/*
*Daniel Tola
*01/17/18
*
*Description: Testbench 1 for registerFile
*Notes:
*To-Do
*/

module regfile_tb();

`define DELAY(TIME_CLK) #(10*TIME_CLK); //delays one clock cycle to look nice. Change TIME_CLK to change number of cycles to delays

/**********
 * Internal Signals
**********/
parameter DATA_WIDTH = 32;
parameter RD_DEPTH = 2;
parameter REG_DEPTH = 32;
parameter ADDR_WIDTH = 5;

reg clk = 0;
reg rst = 0;
reg wr = 0;
reg [ADDR_WIDTH*RD_DEPTH-1:0] rr;
reg [ADDR_WIDTH-1:0] rw;
reg [DATA_WIDTH-1:0] d;
wire [DATA_WIDTH*RD_DEPTH-1:0] q;

reg simState = 0;

/*
*Synchronous Logic
*/
always begin
	if(simState != 1)begin
		`DELAY(1/2)
		clk = ~clk;
	end
end

initial begin
	$display($time, "- Starting Sim");
	$monitor("Changes in output: %d",d);
	clk = 0;
	rst = 1;
	`DELAY(5)
	rst = 0;
	rr = 10'b1010101010;
	d= 32'hdcaf484c;
	`DELAY(5)
	rw = 5'b11011;
	`DELAY(5)
	wr = 1;
	`DELAY(5)
	wr = 0;
	`DELAY(5)
	d = 32'h37373737;
	`DELAY(5)
	rw = 5'b00100;
	`DELAY(5)
	wr = 1;
	`DELAY(5)
	wr = 0;
	`DELAY(5)

	$display($time, "- End Simulation");
	simState = 1;
end
/**********
 * Components
 **********/
register_file #(
	.DATA_WIDTH(DATA_WIDTH),
	.RD_DEPTH(RD_DEPTH),
	.REG_DEPTH(REG_DEPTH),
	.ADDR_WIDTH(ADDR_WIDTH)
)UUT(
	.clk(clk),
	.rst(rst),
	.wr(wr),
	.rr(rr),
	.rw(rw),
	.d(d),
	.q(q)
);
endmodule
