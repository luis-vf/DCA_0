/*
DESCRIPTION
This is the top level wrapper for the UART driver.

NOTES

	Pass through parameters:
	BIT_WIDTH = bit width
	START_BIT = start bit value
	LSB_TO_MSB = LSB first
	SINGLE_SEND = send signle must be toggled for each send
	
	Module specific parameters:
	PARITY_SEL = selects parity, 
			zero to disable parity,
			one - even parity
			two - odd parity
	
	ARCH_SEL = select various implementations of UART drivers
		not supported at this time
		currently only uart_basic exist
	
	Signals:
		read = enables rx module
		send = enables tx module to send what is currently in the tx_reg
		tx_pin = pin which data is shifted out to
		rx_pin = pin which data is shifted into
		rx_reg = reg which fills with data from rx_pin
		tx_reg = reg which data is shifted out from
		busy = indicates a transmission is occuring. Send and recieve at same time if desired.
TODO

*/

module uart #(
	parameter BIT_WIDTH = 8,
	parameter START_BIT = 0,
	parameter LSB_TO_MSB = 1,
	parameter SINGLE_SEND = 1,
	parameter PARITY_SEL = 0,
	parameter ARCH_SEL = 0
)(
	input clk,
	input rst,
	input read,
	input send,
	output busy,
	output tx_pin,
	input [BIT_WIDTH-1:0] tx_reg,
	input rx_pin,
	output [BIT_WIDTH-1:0] rx_reg
);

/**********
 * Internal Signals
**********/
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
uart_basic  #(
	.BIT_WIDTH(BIT_WIDTH),
	.START_BIT(START_BIT),
	.LSB_TO_MSB(LSB_TO_MSB),
	.SINGLE_SEND(SINGLE_SEND)
)U_IP(
	.clk(clk),
	.rst(rst),
	.send(send),
	.read(read),
	.busy(busy),
	.rx_pin(rx_pin),
	.tx_pin(tx_pin),
	.rx_reg(rx_reg),
	.tx_reg(tx_reg)
);
/**********
 * Output Combinatorial Logic
 **********/
endmodule