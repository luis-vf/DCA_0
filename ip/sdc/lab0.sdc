## Generated SDC file "C:/Users/mrawson/Dropbox/coursework/EEL4713_TA/Lab0/ip/sdc/lab0.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.1.0 Build 162 10/23/2013 SJ Web Edition"

## DATE    "Fri Jan 05 21:39:02 2018"

##
## DEVICE  "EP3C16F484C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clk}]
create_clock -name {clk_clk} -period 104166.000 -waveform { 0.000 52083.000 } [get_nets {CLK_DIVIDER|U_IP|new_clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Automatically calculate clock uncertainty to jitter and other effects.
derive_clock_uncertainty


#**************************************************************
# Set Input Delay
#**************************************************************


set_input_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {read}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {rst}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {rx_pin}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {send}]




#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {busy}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {rx_reg[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {rx_reg[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {rx_reg[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {rx_reg[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {rx_reg[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {rx_reg[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {rx_reg[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {rx_reg[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {tx_pin}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {tx_reg[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {tx_reg[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {tx_reg[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {tx_reg[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {tx_reg[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {tx_reg[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {tx_reg[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  3.000 [get_ports {tx_reg[7]}]

#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

