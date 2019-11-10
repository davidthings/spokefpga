##
## Make and program Superconference 2019 Badge
##

BASENAME = add_accum
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

CONSTR = ../projects/$(PROJECTNAME)/add_accum.lpf

%.json: $(SRC) Makefile
	yosys -p "read_verilog $(SRC);\
	          synth_ecp5 -abc9 -top $(PROJTOP) -json $@"

y_parse:
	yosys -p "read_verilog $(SRC);\
	          show -stretch;"

y_proc:
	yosys -p "read_verilog $(SRC);\
	          proc; \
			  show -stretch;"

y_opt:
	yosys -p "read_verilog $(SRC);\
	          proc; \
	          opt; \
			  show -stretch;"

y_s:
	yosys -p "read_verilog $(SRC);\
			show -stretch -pause; \
			read_verilog -D_ABC -lib +/ecp5/cells_sim.v +/ecp5/cells_bb.v; \
			show -stretch -pause; \
			proc; \
			show -stretch -pause; \
			flatten; \
			show -stretch -pause; \
			tribuf -logic; \
			show -stretch -pause; \
			deminout; \
			show -stretch -pause; \
			opt_expr; \
			show -stretch -pause; \
			opt_clean; \
			show -stretch -pause; \
			check; \
			show -stretch -pause; \
			opt; \
			show -stretch -pause; \
			wreduce; \
			show -stretch -pause; \
			peepopt; \
			show -stretch -pause; \
			opt_clean; \
			show -stretch -pause; \
			share; \
			show -stretch -pause; \
			techmap -map +/cmp2lut.v -D LUT_WIDTH=4; \
			show -stretch -pause; \
			opt_expr; \
			show -stretch -pause; \
			opt_clean; \
			show -stretch -pause; \
			alumacc; \
			show -stretch -pause; \
			opt; \
			show -stretch -pause; \
			fsm; \
			show -stretch -pause; \
			opt -fast; \
			show -stretch -pause; \
			memory -nomap; \
			show -stretch -pause; \
			opt_clean; \
			show -stretch -pause; \
			memory_bram -rules +/ecp5/bram.txt; \
			show -stretch -pause; \
			techmap -map +/ecp5/brams_map.v; \
			show -stretch -pause; \
			memory_bram -rules +/ecp5/lutram.txt; \
			show -stretch -pause; \
			techmap -map +/ecp5/lutrams_map.v; \
			show -stretch -pause; \
			opt -fast -mux_undef -undriven -fine; \
			show -stretch -pause; \
			memory_map; \
			show -stretch -pause; \
			opt -undriven -fine; \
			show -stretch -pause; \
			techmap -map +/techmap.v -map +/ecp5/arith_map.v; \
			show -stretch -pause; \
			abc -dff; \
			show -stretch -pause; \
			dffsr2dff; \
			show -stretch -pause; \
			dff2dffs; \
			show -stretch -pause; \
			opt_clean; \
			show -stretch -pause; \
			techmap -D NO_LUT -map +/ecp5/cells_map.v; \
			show -stretch -pause; \
			opt_expr -undriven -mux_undef; \
			show -stretch -pause; \
			simplemap; \
			show -stretch -pause; \
			ecp5_ffinit; \
			show -stretch -pause; \
			ecp5_gsr; \
			show -stretch -pause; \
			attrmvcp -copy -attr syn_useioff; \
			show -stretch -pause; \
			opt_clean; \
			show -stretch -pause; \
			abc; \
			show -stretch -pause; \
			techmap -map +/ecp5/latches_map.v; \
			show -stretch -pause; \
			abc -lut 4:7 -dress; \
			show -stretch -pause; \
			clean; \
			show -stretch -pause; \
			techmap -map +/ecp5/cells_map.v; \
			show -stretch -pause; \
			clean; \
			show -stretch -pause; \
			hierarchy -check; \
			show -stretch -pause; \
			stat; \
			show -stretch -pause; \
			check -noinit; \
			show -stretch -pause; \
			opt_clean -purge; \
			show -stretch -pause; \
			write_blif -attr -cname -conn -param $(BASENAME); \
			show -stretch -pause; \
			write_blif -gates -attr -param $(BASENAME); \
			show -stretch -pause; \
			write_edif $(BASENAME); \
			show -stretch -pause; \
			write_json $(BASENAME); \
			show -stretch -pause; "

y_ss:
	yosys -p "read_verilog $(SRC);\
	        show -stretch -format svg -prefix $(BASENAME)_parse_00; \
			read_verilog -D_ABC -lib +/ecp5/cells_sim.v +/ecp5/cells_bb.v; \
			proc; \
	        show -stretch -format svg -prefix $(BASENAME)_proc_01; \
			flatten; \
			tribuf -logic; \
			deminout; \
			opt_expr; \
			opt_clean; \
	        show -stretch -format svg -prefix $(BASENAME)_clean_02; \
			check; \
			opt; \
			wreduce; \
			peepopt; \
			opt_clean; \
			share; \
			techmap -map +/cmp2lut.v -D LUT_WIDTH=4; \
			opt_expr; \
			opt_clean; \
			alumacc; \
	        show -stretch -format svg -prefix $(BASENAME)_alumacc_03; \
			opt; \
			fsm; \
			opt -fast; \
			memory -nomap; \
			opt_clean; \
			memory_bram -rules +/ecp5/bram.txt; \
			techmap -map +/ecp5/brams_map.v; \
			memory_bram -rules +/ecp5/lutram.txt; \
			techmap -map +/ecp5/lutrams_map.v; \
			opt -fast -mux_undef -undriven -fine; \
			memory_map; \
			opt -undriven -fine; \
			techmap -map +/techmap.v -map +/ecp5/arith_map.v; \
	        show -stretch -format svg -prefix $(BASENAME)_tm_arith_04; \
			abc -dff; \
	        show -stretch -format svg -prefix $(BASENAME)_abc_05; \
			dffsr2dff; \
			dff2dffs; \
			opt_clean; \
	        show -stretch -format svg -prefix $(BASENAME)_clean_06; \
			techmap -D NO_LUT -map +/ecp5/cells_map.v; \
	        show -stretch -format svg -prefix $(BASENAME)_tm_cells_07; \
			opt_expr -undriven -mux_undef; \
			simplemap; \
			ecp5_ffinit; \
	        show -stretch -format svg -prefix $(BASENAME)_ffinit_08; \
			ecp5_gsr; \
			attrmvcp -copy -attr syn_useioff; \
			opt_clean; \
	        show -stretch -format svg -prefix $(BASENAME)_opt_clean_09; \
			abc; \
	        show -stretch -format svg -prefix $(BASENAME)_abc_10; \
			techmap -map +/ecp5/latches_map.v; \
			abc -lut 4:7 -dress; \
	        show -stretch -format svg -prefix $(BASENAME)_abc_lut_11; \
			clean; \
	        show -stretch -format svg -prefix $(BASENAME)_clean_12; \
			techmap -map +/ecp5/cells_map.v; \
	        show -stretch -format svg -prefix $(BASENAME)_tm_cells_13; \
			clean; \
	        show -stretch -format svg -prefix $(BASENAME)_clean_14; \
			hierarchy -check; \
			stat; \
			check -noinit; \
			opt_clean -purge; \
			write_blif -attr -cname -conn -param $(BASENAME); \
			write_blif -gates -attr -param $(BASENAME); \
			write_edif $(BASENAME); \
			write_json $(BASENAME); "


y_synth_ecp5:
	yosys -p "read_verilog $(SRC);\
	          synth_ecp5 -abc9 -top $(PROJTOP); \
			  show -stretch;"


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
