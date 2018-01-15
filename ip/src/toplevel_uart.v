/*
DESCRIPTION
This is the top level which instantiates a uart state machine.

NOTES
Parity not supported, default value required. 
Arch_sel not supported, default value required.

Repeats data sent to it and displays data on the LEDs. Note Read and Send must both be set to one. 
Note you can easily get buffering issues if you are sending and recieving at the same time full speed. 

TODO

*/

module toplevel_uart #(
	parameter CLK_FREQ = 50000000,
	parameter BAUD_RATE = 9600,
	parameter BIT_WIDTH = 8,
	parameter START_BIT = 0,
	parameter LSB_TO_MSB = 0,
	parameter SINGLE_SEND = 1, 
	parameter PARITY_SEL = 0,
	parameter ARCH_SEL = 0
)(
	input clk,
	input rst,
	input send,
	input read,
	input rx_pin,
	output [BIT_WIDTH-1:0] tx_reg, //made to be output since connecting rx_reg to tx_reg
	output busy,
	output tx_pin,
	output [BIT_WIDTH-1:0] rx_reg
);

/**********
 * Internal Signals
**********/

wire uart_clk;

/**********
 * Glue Logic 
 **********/
/**********
 * Synchronous Logic
 **********/
/**********
 * Glue Logic 
 **********/
/**********
 * Components
 **********/

clk_div #(
	.IN_FREQ(CLK_FREQ),
	.OUT_FREQ(BAUD_RATE*2)
)CLK_DIVIDER(
	.clk(clk),
	.rst(rst),
	.new_clk(uart_clk)
);
 
uart #(
	.BIT_WIDTH(BIT_WIDTH),
	.START_BIT(START_BIT),
	.LSB_TO_MSB(LSB_TO_MSB),
	.PARITY_SEL(PARITY_SEL),
	.SINGLE_SEND(SINGLE_SEND)
)UUT(
	.clk(uart_clk),
	.rst(rst),
	.send(send),
	.read(read),
	.busy(busy),
	.rx_pin(rx_pin),
	.tx_pin(tx_pin),
	.rx_reg(rx_reg),
	.tx_reg(rx_reg)
);
/**********
 * Output Combinatorial Logic
 **********/
assign tx_reg = rx_reg;
endmodule