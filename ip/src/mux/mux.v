/*
DESCRIPTION

NOTES

TODO

*/

module mux #(
  parameter BIT_WIDTH = 8, //size of the data that goes into each mux input
  parameter DEPTH = 2,     //number of inputs for the mux
  parameter SEL_WIDTH = DEPTH, //number of select lines

)(
  input [BIT_WIDTH*DEPTH -1 :0]

);
/**********
 *  Array Packing Defines
 **********/
//These are preprocessor defines similar to C/C++ preprocessor or VHDL functions
`define PACK_ARRAY(PK_WIDTH,PK_DEPTH,PK_SRC,PK_DEST, BLOCK_ID, GEN_VAR)    genvar GEN_VAR; generate for (GEN_VAR=0; GEN_VAR<(PK_DEPTH); GEN_VAR=GEN_VAR+1) begin: BLOCK_ID assign PK_DEST[((PK_WIDTH)*GEN_VAR+((PK_WIDTH)-1)):((PK_WIDTH)*GEN_VAR)] = PK_SRC[GEN_VAR][((PK_WIDTH)-1):0]; end endgenerate
`define UNPACK_ARRAY(PK_WIDTH,PK_DEPTH,PK_DEST,PK_SRC, BLOCK_ID, GEN_VAR)  genvar GEN_VAR; generate for (GEN_VAR=0; GEN_VAR<(PK_DEPTH); GEN_VAR=GEN_VAR+1) begin: BLOCK_ID assign PK_DEST[GEN_VAR][((PK_WIDTH)-1):0] = PK_SRC[((PK_WIDTH)*GEN_VAR+(PK_WIDTH-1)):((PK_WIDTH)*GEN_VAR)]; end endgenerate

/**********
 * Internal Signals
**********/
function integer log2; //This is a macro function (no hardware created) which finds the log2, returns log2
   input [31:0] val; //input to the function
   integer 	i;
   begin
      log2 = 0;
      for(i = 0; 2**i < val; i = i + 1)
		log2 = i + 1;
   end
endfunction
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
/**********
 * Output Combinatorial Logic
 **********/
endmodule
