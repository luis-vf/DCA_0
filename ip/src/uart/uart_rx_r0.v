/*
DESCRIPTION
A UART_RX statemachine for UART reciever comm.

NOTES
	BIT_WIDTH = bit width, usually 8 or 7
	START_BIT = start bit value
	
	Module uses a counter and state machine. The state machine is basic, an idle state, a start state, and an rx state.
	The counter is used to count number of shifts. on the data line. New Data is shifted into the LSB. DataOut is junk until
	the busy signal goes false.
	
	The STOP_BIT is assumes to not the START_BIT.
			
TODO

*/


module uart_rx_r0 #(
	parameter BIT_WIDTH = 8,
	parameter START_BIT = 0
)(
	input clk,
	input rst,
	input dataIn,
	input rx,
	output busy,
	output [BIT_WIDTH-1:0] dataOut
);

/**********
 * Internal Signals
**********/
localparam s_IDLE = 2'h0;
localparam s_START = 2'h1;
localparam s_RX_DATA = 2'h2;

localparam STATE_WIDTH = 2;
localparam CNT_WIDTH = 4;

reg [STATE_WIDTH-1:0] next_state;
reg [STATE_WIDTH-1:0] state;
reg [CNT_WIDTH-1:0] cnt;
reg [CNT_WIDTH-1:0] next_cnt;
reg [BIT_WIDTH - 1:0] data_rx;
reg [BIT_WIDTH - 1:0] next_data;
reg busy_tmp;

wire [CNT_WIDTH-1:0] bitwidth;
/**********
 * Glue Logic 
 **********/
assign bitwidth = BIT_WIDTH;

/**********
 * Synchronous Logic
 **********/
//sensitivity list should include clk and all mealy inputs
//assignments in the synchronous section should be all registered signals
always @(posedge clk) begin
	if(rst == 1'b1) begin
		//reset cnt and state
		state <= s_IDLE;
		cnt <= 4'h0;
		data_rx <= {(BIT_WIDTH){1'b0}}; //we need to register the data as it comes in
	end
	else begin
		//on the clk, assign next_state to state
		state <= next_state;
		cnt <= next_cnt;
		data_rx <= next_data;
	end
end

/**********
 * Combinatorial Logic
 **********/
//sensitivity list should include state and all moore inputs
//bitwidth is added to sensitivity list even though not needed since never changes, makes warnings go away
always @(state,cnt,dataIn,data_rx,bitwidth,rx) begin
	
//For statemachines, always default registered signals

	busy_tmp <= 1'b0;
	next_data <= data_rx;//hold data if no change
	next_cnt <= 4'h0;//when cnt not incremented, reset value
	next_state <= s_IDLE;//when state not assigned, go to ideal
				
//NOTE case doesnt need "begin" since has "endcase"
	case(state)
	
		s_IDLE:
			if(rx) begin //read enabled
				//if the start bit gets hit, move to capturing dataIn state
				if(dataIn == START_BIT) begin
					next_state <= s_RX_DATA;
				end
				else begin //if start bit not hit (i.e. asked to read while mid comm), wait for start bit
					next_state <= s_START;
				end
			end
			else begin //read not enabled
				next_state <= s_IDLE;
			end
				
		s_START:
			if(dataIn == START_BIT) begin
				next_state <= s_RX_DATA;
			end
			else begin //wait for start bit
				next_state <= s_START;
			end
		
		s_RX_DATA:
			//if the cnt reaches the max, move back to looking for start bit
//NOTE this below comment would be great but cast to 32 bits for equal which is wasteful
//if(cnt != BIT_WIDTH) begin 
			if(cnt^bitwidth) begin //if the bitwise xor is 0, then the two inputs are equal, no casting 
				//dataIn moves to shift register
				next_data[0] <= dataIn;
				next_data[BIT_WIDTH-1:1] <= data_rx[BIT_WIDTH-2:0]; 
				busy_tmp <= 1'b1;
				next_cnt <= cnt+1;//this will throw a warning that it is truncating 32bit 1 to a 4bit 1, good thing
				next_state <= s_RX_DATA;
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
assign dataOut = data_rx;


endmodule