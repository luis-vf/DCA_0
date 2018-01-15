/*
DESCRIPTION
Testbench for clk divider.

NOTES

TODO
*/

module clk_div_tb();

/*
Defines
*/
`define DELAY(TIME_CLK) #(10*TIME_CLK); //delays one clk cycle, TIME_CLK = number of clk cycles to delay

/**********
 * Internal Signals
**********/
//UUT parameters
parameter IN_FREQ = 50000000;
parameter OUT_FREQ = 9600;
//UUT inputs
reg clk = 0;
reg rst = 1;
//UUT outputs
wire new_clk;

integer i,j;
reg simState = 0;
/**********
 * Glue Logic 
 **********/
/**********
 * Synchronous Logic
 **********/
always begin 
	if (simState != 1) begin
		`DELAY(1/2)
		clk = ~clk;
	end
end

initial begin
	//SIM
	simState = 0;
	
	//Start Sim, initialize all inputs
	$display($time, "- Starting Sim");
	clk = 0;
	rst = 1;
	`DELAY(10)
	
	//leaving reset 
	$display($time, "- Leaving Reset");
	rst = 0;
	`DELAY(20000)
	
	//End Simulation
	$display($time, "- End Simulation");
	simState = 1;
end
/**********
 * Glue Logic 
 **********/
/**********
 * Components
 **********/
clk_div #(
	.IN_FREQ(IN_FREQ),
	.OUT_FREQ(OUT_FREQ)
)UUT(
	.clk(clk),
	.rst(rst),
	.new_clk(new_clk)
);

endmodule