##
## Make and program Superconference 2019 Badge
##

BASENAME = add_sat
PROJTOP = $(BASENAME)
PROJECTNAME = $(BASENAME)

#Image read mode: qspi, dual-spi, fast-read
FLASH_MODE=qspi
#Image read freq, in MHz: 2.4, 4.8, 9.7, 19.4, 38.8, 62.0
FLASH_FREQ=38.8 #MHz

DEVICE = 45k
PACKAGE = CABGA381
SPEED = 8

CLOCK_MHZ    = 8

TRELLIS=/usr/share/trellis

all: ${PROJECTNAME}.bit

SRC = ../rtl/$(BASENAME).v

CONSTR = ../projects/$(PROJECTNAME)/add_sat.lpf

%.json: $(SRC) Makefile
	yosys -p "read_verilog $(SRC);\
	          synth_ecp5 -abc9 -top $(PROJTOP) -json $@"

y_parse:
	yosys -p "read_verilog $(SRC);\
	          show;"

y_proc:
	yosys -p "read_verilog $(SRC);\
	          proc; \
			  show;"

y_opt:
	yosys -p "read_verilog $(SRC);\
	          proc; \
	          opt; \
			  show;"

y_s:
	yosys -p "read_verilog $(SRC);\
			show -pause; \
			read_verilog -D_ABC -lib +/ecp5/cells_sim.v +/ecp5/cells_bb.v; \
			show -pause; \
			proc; \
			show -pause; \
			flatten; \
			show -pause; \
			tribuf -logic; \
			show -pause; \
			deminout; \
			show -pause; \
			opt_expr; \
			show -pause; \
			opt_clean; \
			show -pause; \
			check; \
			show -pause; \
			opt; \
			show -pause; \
			wreduce; \
			show -pause; \
			peepopt; \
			show -pause; \
			opt_clean; \
			show -pause; \
			share; \
			show -pause; \
			techmap -map +/cmp2lut.v -D LUT_WIDTH=4; \
			show -pause; \
			opt_expr; \
			show -pause; \
			opt_clean; \
			show -pause; \
			alumacc; \
			show -pause; \
			opt; \
			show -pause; \
			fsm; \
			show -pause; \
			opt -fast; \
			show -pause; \
			memory -nomap; \
			show -pause; \
			opt_clean; \
			show -pause; \
			memory_bram -rules +/ecp5/bram.txt; \
			show -pause; \
			techmap -map +/ecp5/brams_map.v; \
			show -pause; \
			memory_bram -rules +/ecp5/lutram.txt; \
			show -pause; \
			techmap -map +/ecp5/lutrams_map.v; \
			show -pause; \
			opt -fast -mux_undef -undriven -fine; \
			show -pause; \
			memory_map; \
			show -pause; \
			opt -undriven -fine; \
			show -pause; \
			techmap -map +/techmap.v -map +/ecp5/arith_map.v; \
			show -pause; \
			abc -dff; \
			show -pause; \
			dffsr2dff; \
			show -pause; \
			dff2dffs; \
			show -pause; \
			opt_clean; \
			show -pause; \
			techmap -D NO_LUT -map +/ecp5/cells_map.v; \
			show -pause; \
			opt_expr -undriven -mux_undef; \
			show -pause; \
			simplemap; \
			show -pause; \
			ecp5_ffinit; \
			show -pause; \
			ecp5_gsr; \
			show -pause; \
			attrmvcp -copy -attr syn_useioff; \
			show -pause; \
			opt_clean; \
			show -pause; \
			abc; \
			show -pause; \
			techmap -map +/ecp5/latches_map.v; \
			show -pause; \
			abc -lut 4:7 -dress; \
			show -pause; \
			clean; \
			show -pause; \
			techmap -map +/ecp5/cells_map.v; \
			show -pause; \
			clean; \
			show -pause; \
			hierarchy -check; \
			show -pause; \
			stat; \
			show -pause; \
			check -noinit; \
			show -pause; \
			opt_clean -purge; \
			show -pause; \
			write_blif -attr -cname -conn -param <file-name>; \
			show -pause; \
			write_blif -gates -attr -param <file-name>; \
			show -pause; \
			write_edif <file-name>; \
			show -pause; \
			write_json <file-name>; \
			show -pause; "

y_ss:
	yosys -p "read_verilog $(SRC);\
	        show -format svg -prefix $(BASENAME)_parse;"
			read_verilog -D_ABC -lib +/ecp5/cells_sim.v +/ecp5/cells_bb.v; \
			proc; \
	        show -format svg -prefix $(BASENAME)_proc;"
			flatten; \
			show -pause; \
			tribuf -logic; \
			show -pause; \
			deminout; \
			show -pause; \
			opt_expr; \
			show -pause; \
			opt_clean; \
			show -pause; \
			check; \
			show -pause; \
			opt; \
			show -pause; \
			wreduce; \
			show -pause; \
			peepopt; \
			show -pause; \
			opt_clean; \
			show -pause; \
			share; \
			show -pause; \
			techmap -map +/cmp2lut.v -D LUT_WIDTH=4; \
			show -pause; \
			opt_expr; \
			show -pause; \
			opt_clean; \
			show -pause; \
			alumacc; \
			show -pause; \
			opt; \
			show -pause; \
			fsm; \
			show -pause; \
			opt -fast; \
			show -pause; \
			memory -nomap; \
			show -pause; \
			opt_clean; \
			show -pause; \
			memory_bram -rules +/ecp5/bram.txt; \
			show -pause; \
			techmap -map +/ecp5/brams_map.v; \
			show -pause; \
			memory_bram -rules +/ecp5/lutram.txt; \
			show -pause; \
			techmap -map +/ecp5/lutrams_map.v; \
			show -pause; \
			opt -fast -mux_undef -undriven -fine; \
			show -pause; \
			memory_map; \
			show -pause; \
			opt -undriven -fine; \
			show -pause; \
			techmap -map +/techmap.v -map +/ecp5/arith_map.v; \
			show -pause; \
			abc -dff; \
			show -pause; \
			dffsr2dff; \
			show -pause; \
			dff2dffs; \
			show -pause; \
			opt_clean; \
			show -pause; \
			techmap -D NO_LUT -map +/ecp5/cells_map.v; \
			show -pause; \
			opt_expr -undriven -mux_undef; \
			show -pause; \
			simplemap; \
			show -pause; \
			ecp5_ffinit; \
			show -pause; \
			ecp5_gsr; \
			show -pause; \
			attrmvcp -copy -attr syn_useioff; \
			show -pause; \
			opt_clean; \
			show -pause; \
			abc; \
			show -pause; \
			techmap -map +/ecp5/latches_map.v; \
			show -pause; \
			abc -lut 4:7 -dress; \
			show -pause; \
			clean; \
			show -pause; \
			techmap -map +/ecp5/cells_map.v; \
			show -pause; \
			clean; \
			show -pause; \
			hierarchy -check; \
			show -pause; \
			stat; \
			show -pause; \
			check -noinit; \
			show -pause; \
			opt_clean -purge; \
			show -pause; \
			write_blif -attr -cname -conn -param <file-name>; \
			show -pause; \
			write_blif -gates -attr -param <file-name>; \
			show -pause; \
			write_edif <file-name>; \
			show -pause; \
			write_json <file-name>; \
			show -pause; "


y_synth_ecp5:
	yosys -p "read_verilog $(SRC);\
	          synth_ecp5 -abc9 -top $(PROJTOP); \
			  show;"


%_out.config: %.json
	nextpnr-ecp5 --json $< --freq $(CLOCK_MHZ) --pre-pack clock_constraints.py --textcfg $@ --$(DEVICE) --speed $(SPEED) --package $(PACKAGE) --lpf $(CONSTR)

gui: $(LPF_DEF) $(PROJTOP).json
	nextpnr-ecp5 --$(DEVICE) --freq $(CLOCK_MHZ) --pre-pack clock_constraints.py --textcfg $(PROJTOP)_out.config --speed $(SPEED) --package $(PACKAGE) --lpf $(CONSTR) --json $(PROJTOP).json --gui

%.bit: %_out.config
	ecppack --spimode $(FLASH_MODE) --freq $(FLASH_FREQ) --input $< --bit $@

${PROJECTNAME}.svf : ${PROJECTNAME}.bit

prog: ${PROJECTNAME}.svf
	openocd -f ${TRELLIS}/misc/openocd/ecp5-evn.cfg -c "transport select jtag; init; svf $<; exit"

flash: $(PROJECTNAME).bit
	tinyprog -p $(PROJECTNAME).bit -a 0x180000

clean:
	rm -f *.svf *.bit *.config *.json

.PHONY: prog clean
