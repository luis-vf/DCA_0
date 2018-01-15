/*
DESCRIPTION
Testbench for UART driver.

NOTES

TODO
*/

module uart_tb();

/*
Defines
*/
`define DELAY(TIME_CLK) #(10*TIME_CLK);

/**********
 * Internal Signals
**********/
parameter BAUD_RATE = 9600;
parameter BIT_WIDTH = 8;
parameter START_BIT = 0;
parameter LSB_TO_MSB = 1;
parameter PARITY_SEL = 0;
parameter ARCH_SEL = 0;
parameter CLK_FREQ = 50000000;
parameter SINGLE_SEND = 1;

//UUT inputs
reg clk = 0;
reg rst = 1;
reg send;
reg read;
reg rx_pin;
reg [BIT_WIDTH-1:0] tx_reg;
//UUT outputs
wire busy;
wire tx_pin;
wire [BIT_WIDTH-1:0] rx_reg;

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
	send = 0;
	read = 0;
	rx_pin = 0;
	tx_reg = 0;
	`DELAY(10)
	
	//leaving reset 
	$display($time, "- Leaving Reset");
	rst = 0;
	
	send = 1; //hold send as one
	for(i=0; i<10; i=i+1) begin
		tx_reg = i;
		`DELAY(1)
		send = 0;
		tx_reg = 0;
		`DELAY(9)
	end
	send = 0;
	
	//End Simulation
	$display($time, "- End Simulation");
	simState = 1; //should stop clock and thus simulation, but modelsim has given me problems about this in the past...
end
/**********
 * Glue Logic 
 **********/
/**********
 * Components
 **********/
toplevel_uart #(
	.CLK_FREQ(CLK_FREQ),
	.SINGLE_SEND(SINGLE_SEND), 
	.ARCH_SEL(ARCH_SEL),
	.BAUD_RATE(BAUD_RATE),
	.BIT_WIDTH(BIT_WIDTH),
	.START_BIT(START_BIT),
	.LSB_TO_MSB(LSB_TO_MSB),
	.PARITY_SEL(PARITY_SEL)
)UUT( //UUT = Unit under test, DUT = device under test, both commonly used
	.clk(clk),
	.rst(rst),
	.send(send),
	.read(1'b1),
	.busy(busy),
	.rx_pin(tx_pin),
	.tx_pin(tx_pin),
	.rx_reg(rx_reg),
	.tx_reg(tx_reg)
);

endmodule