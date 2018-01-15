/*
DESCRIPTION
This module merges the RX and TX uart modules to form a full UART driver. This does not account for baud rate so that must be done elsewhere.

NOTES
	Pass through parameters:
	BIT_WIDTH = bit width
	START_BIT = start bit value
	
	Module specific parameters:
	LSB_TO_MSB = LSB first, if false then flip the input and output registers.
	SINGLE_SEND = send signle must be toggled for each send, the send occurs on the toggle, i.e. holding send true only sends a single byte
	
	LOOPBACK_MODE i.e. connecting the rx_reg to tx_reg - if we are in loopback mode, and MSB first, we need to only flip the rx reg, otherwise we get to flips
	
TODO

*/

module uart_basic #(
	parameter BIT_WIDTH = 8,
	parameter START_BIT = 0,
	parameter LSB_TO_MSB = 1,
	parameter SINGLE_SEND = 1
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
wire rx_busy;
wire tx_busy;
reg send_tmp;

wire [BIT_WIDTH-1:0] rx_reg_tmp;
wire [BIT_WIDTH-1:0] tx_reg_tmp;

localparam LOOPBACK_MODE = 1;
/**********
 * Glue Logic 
 **********/
genvar i; //iterator for generates
generate
if(LSB_TO_MSB) begin //behavior for LSB to MSB, usual configuration
	assign rx_reg = rx_reg_tmp;
	assign tx_reg_tmp = tx_reg;
end else begin //MSB to LSB
	for(i = 0; i<BIT_WIDTH; i=i+1) begin: BIT_REVERSAL_BLOCK //bit reversal for loop, for generate blocks must have a block id in this case BIT_REVERSAL_BLOCK
		assign rx_reg[i] = rx_reg_tmp[BIT_WIDTH-1-i]; 
		
		if(LOOPBACK_MODE) begin //if in loopback mode, flipping tx causes a double flip, which makes the tx not actually flip
			assign tx_reg_tmp = tx_reg;	
		end else begin
			assign tx_reg_tmp[i] = tx_reg[BIT_WIDTH-1-i];
		end
	end
end
endgenerate
/**********
 * Synchronous Logic
 **********/
always @(posedge clk) begin
	if(rst) begin
		send_tmp <= 1'b0;
	end
	else begin
		send_tmp <= send;
	end
end
/**********
 * Glue Logic 
 **********/
/**********
 * Components
 **********/
uart_rx_r0  #(
	.BIT_WIDTH(BIT_WIDTH),
	.START_BIT(START_BIT)
)U_RX(
	.clk(clk),
	.rst(rst),
	.busy(rx_busy),
	.rx(read),
	.dataIn(rx_pin),
	.dataOut(rx_reg_tmp)
);

generate
	if(SINGLE_SEND) begin
		uart_tx_r0  #(
			.BIT_WIDTH(BIT_WIDTH),
			.START_BIT(START_BIT)
		)U_TX(
			.clk(clk),
			.rst(rst),
			.busy(tx_busy),
			.tx(send^send_tmp),
			.dataIn(tx_reg_tmp),
			.dataOut(tx_pin)
		);
	end else begin
		uart_tx_r0  #(
			.BIT_WIDTH(BIT_WIDTH),
			.START_BIT(START_BIT)
		)U_TX(
			.clk(clk),
			.rst(rst),
			.busy(tx_busy),
			.tx(send),
			.dataIn(tx_reg_tmp),
			.dataOut(tx_pin)
		);
	end
endgenerate
	
/**********
 * Output Combinatorial Logic
 **********/
 assign busy = tx_busy | rx_busy;

endmodule