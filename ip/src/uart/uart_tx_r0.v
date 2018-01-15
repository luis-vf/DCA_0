/*
DESCRIPTION
A UART_TX statemachine for UART transmit comm.

NOTES
	BIT_WIDTH = bit width, usually 8 or 7
	START_BIT = start bit value
	The STOP_BIT is assumes to not the START_BIT.

	Module uses a counter and state machine. The state machine is basic, an idle state and a transmit state.
	The counter is used to count number of shifts. on the data line. Data is shifted to the left.
	
	Will have issues with bit lengths over 14 (should never happen), but can change but changing CNT_WIDTH. Could improve with log2 function block.

TODO

*/

module uart_tx_r0 #(
	parameter BIT_WIDTH = 8,
	parameter START_BIT = 0
)(
	input clk,
	input rst,
	input [BIT_WIDTH-1:0] dataIn,
	input tx,
	output busy,
	output dataOut
);

/**********
 * Internal Signals
**********/
localparam STATE_WIDTH = 1; //only 2 states
localparam CNT_WIDTH = 4; //bit width of 4 counts up to 16
localparam s_IDLE = 1'h0;
localparam s_TX_DATA = 1'h1;

//for state machine, use the equiv of 2 process vhdl construct. Next values are assigned based on combinatorial logic, feeding into registers to make sequential.
reg [STATE_WIDTH-1:0] next_state;
reg [STATE_WIDTH-1:0] state;
reg [CNT_WIDTH-1:0] cnt;
reg [CNT_WIDTH-1:0] next_cnt;
reg [BIT_WIDTH+2 - 1:0] data_tx; //must add two extra bits, one for start and one for stop bit
reg [BIT_WIDTH+2 - 1:0] next_data;

reg busy_tmp; //why do we need this signal? Busy is an output, and thus a wire. We want to register busy to keep the timing correct.
				//We could have used "output reg busy," above but this prevents us from doing any combinatorial logic on busy which is needed pretty often.
				//In this case we could have used "output reg busy" but I chose not to for demonstration.

wire [CNT_WIDTH-1:0] bitwidth; // This wire exist for an optimization explained below. It holds the bitwidth which is the max value of the counter.
/**********
 * Glue Logic 
 **********/
assign bitwidth = BIT_WIDTH+2; //extra two for start and stop bits

/**********
 * Synchronous Logic
 **********/
always @(posedge clk) begin
	if(rst == 1'b1) begin
		//reset cnt, state, and data
		state <= s_IDLE;
		cnt <= 4'h0;
		data_tx[BIT_WIDTH+1] = ~START_BIT; //start bit disabled
		data_tx[0] = ~START_BIT; //stop bit
		data_tx[BIT_WIDTH:1] <= {(BIT_WIDTH){1'b1}}; //we need to register the data as it goes out
	end
	else begin
		//on the clk, assign next_state to state
		state <= next_state;
		cnt <= next_cnt;
		data_tx <= next_data;
	end
end

/**********
 * Combinatorial Logic
 **********/
//bitwidth is added to sensitivity list even though not needed since never changes, makes warnings go away
always @(state,cnt,dataIn,data_tx,tx,bitwidth) begin

	//default values 
	busy_tmp <= 1'b0;
				
	next_data[BIT_WIDTH+1] = ~START_BIT; //start bit disabled
	next_data[BIT_WIDTH:1] <= {(BIT_WIDTH){1'b1}};//data is stop bit (not the start bit) if idling
	next_data[0] = ~START_BIT; //stop bit
	
	next_cnt <= 4'h0;//when cnt not incremented, reset value
	next_state <= s_IDLE;//when state not assigned, go to idle

	case(state)
		s_IDLE:
			//if the start bit gets hit, move to capturing data state
			if(tx) begin
				next_state <= s_TX_DATA;
				next_data[BIT_WIDTH+1] = START_BIT; //start bit
				next_data[BIT_WIDTH:1] <= dataIn;//lock in the data to send
				next_data[0] = ~START_BIT; //stop bit
			end 
			else begin
				next_state <= s_IDLE;
				next_data[BIT_WIDTH+1] <= ~START_BIT; //stop bit
			end
			
		s_TX_DATA:
			//if the cnt reaches the max, move back to looking for start bit
			//if(cnt != BIT_WIDTH) begin //This would be nice, but unfortunatly it cast cnt to a 32 bit value which is inefficient
			if(cnt^bitwidth) begin //same as !=, this is better since it only uses an xor gate to do the comparision and essentially truncated BIT_WIDTH
				next_data[BIT_WIDTH+1:1] <= data_tx[BIT_WIDTH:0]; //data moves through shift register to the left
				busy_tmp <= 1'b1;
				next_cnt <= cnt+1;
				next_state <= s_TX_DATA;
			end
	endcase
end
/**********
 * Glue Logic 
 **********/
/**********
 * Components
 **********/
/**********
 * Output Combinatorial Logic
 **********/
assign busy = busy_tmp;
assign dataOut = data_tx[BIT_WIDTH+1];


endmodule