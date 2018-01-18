/*
DESCRIPTION
Testbench for UART driver.

NOTES

TODO
*/

module mux_tb();

`define DELAY(TIME_CLK) #(10*TIME_CLK);


/**********
 * Internal Signals
**********/
parameter BIT_WIDTH = 4; //size of the data that goes into each mux input
parameter DEPTH = 4;     //number of inputs for the mux
parameter SEL_WIDTH = 2;
reg [BIT_WIDTH*DEPTH -1 :0] dataIn;
reg [SEL_WIDTH - 1:0] select;
wire [BIT_WIDTH - 1:0] muxout;

reg simState = 0;
reg clk = 0;


always begin
  if (simState != 1) begin
    `DELAY(1/2)
    clk = ~clk;
  end
end

initial begin
  $display($time, "- Starting Sim");
  dataIn <= 8'b00011011;
  select <= 2'b00;
  $display("select = %d",select);
  `DELAY(1)
  select <= 2'b01;
  $display("select = %d",select);
  `DELAY(1)
  select <= 2'b10;
  $display("select = %d",select);
  `DELAY(1)
  select <= 2'b11;
  $display("select = %d",select);
  `DELAY(1)
  $display($time, "- End Simulation");
  simState <= 1;
end
/**********
 * Components
 **********/
mux #(
  .BIT_WIDTH(BIT_WIDTH),
  .DEPTH(DEPTH),
  .SEL_WIDTH(SEL_WIDTH)
  )UUT(
    .dataIn(dataIn),
    .select(select),
    .muxout(muxout)
);
endmodule
