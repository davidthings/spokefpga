## Makefile for Icarus
##
## You'll need the icarus tools
##
##     sudo apt install verilog gtkwave
##
## If you're lucky, just set the BASENAME and all will work.  Luck includes
## naming your test benches BASENAME_tb.v and putting it all in the correct location
##
## Just type 'make' to build the simulator
## Then 'make sim' will actually perform the simulation
##  if your test bench doesn't terminate itself, CTRL-C out of it and type 'finish' to get out
## Finally you can see any variables you monitored 'make wave'
## To monitor variables you'll need to add the following to your test bench
##
##     initial begin
##         $dumpfile("timer_ms_tb.vcd");  // specify the output file - use the same basename
##         $dumpvars(0,timer_ms_tb);      // dump the module - 0 means just one layer deep
##         $dumpvars(1,t_1MHz_1ms);       // dump the module - 1 means and one layer underneath
##     end

BASENAME := image
TARGET := $(BASENAME)_tb

SIM := ../sim
RTL := ../rtl
PIPE_RTL := ../../pipe/rtl

SOURCE := $(SIM)/$(TARGET).v  $(RTL)/image_defs.v
CC = iverilog
FLAGS = -Wall -Winfloop

all: $(TARGET)

$(TARGET): $(SOURCE)
	$(CC) -s $(TARGET) $(FLAGS) -o $@ $^

sim: $(TARGET)
	vvp -n $<

lint:
	verilator --lint-only $(SOURCE) --top-module image_tb

linti:
	verilator --lint-only ../sim/image_spec_check.v

wave : $(TARGET).vcd
	gtkwave $(TARGET).vcd

.PHONY: all sim wave install
