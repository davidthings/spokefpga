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

BASENAME := image_background
TARGET := $(BASENAME)_tb

<<<<<<< HEAD
IMAGE_SIM := ../../image/sim
=======
IMAGE_SIM := ../sim
>>>>>>> bd47fc1bde0bf3353d999bf313160dd47b8b4925
IMAGE_RTL := ../../image/rtl
PIPE_RTL := ../../pipe/rtl

SOURCE := $(IMAGE_SIM)/$(TARGET).v \
	$(IMAGE_RTL)/$(BASENAME).v \
	$(IMAGE_RTL)/image_buffer.v \
	$(IMAGE_RTL)/image_defs.v \
	$(PIPE_RTL)/pipe_defs.v

CC = iverilog
FLAGS = -Wall -Winfloop -gstrict-expr-width

all: $(TARGET)

$(TARGET): $(SOURCE)
	$(CC) -s $(TARGET) $(FLAGS) -o $@ $^

sim: $(TARGET)
	vvp -n $<

wave : $(TARGET).vcd
	gtkwave $(TARGET).vcd

lint:
	verilator --lint-only $(IMAGE_RTL)/$(BASENAME).v

<<<<<<< HEAD
lint_tb:
	verilator --lint-only $(IMAGE_SIM)/$(BASENAME)_tb.v

=======
>>>>>>> bd47fc1bde0bf3353d999bf313160dd47b8b4925
.PHONY: all sim wave install
