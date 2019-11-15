##
## Make and program Superconference 2019 Badge
##

BASENAME = led_blink
PROJECTNAME = $(BASENAME)
PROJTOP = $(PROJECTNAME)

PROJECT_DIR   = ../projects/$(PROJECTNAME)

SOURCES =

BADGE_VER ?= 3

#Image read mode: qspi, dual-spi, fast-read
FLASH_MODE=qspi
#Image read freq, in MHz: 2.4, 4.8, 9.7, 19.4, 38.8, 62.0
FLASH_FREQ=38.8 #MHz

SRC = $(PROJECT_DIR)/$(PROJTOP).v $(SOURCES)

CONSTR=$(PROJECT_DIR)/$(word $(BADGE_VER), had19_proto1.lpf had19_proto2.lpf had19_proto3.lpf had19_prod.lpf)

DEVICE = 45k
PACKAGE = CABGA381
SPEED = 8

CLOCK_MHZ    = 8

TRELLIS=/usr/share/trellis

all: ${PROJECTNAME}.bit

%.json: $(SRC) Makefile
	yosys -p "read -sv -DBADGE_VER=$(BADGE_VER) -DBADGE_V$(BADGE_VER)=1 $(SRC);\
	          synth_ecp5 -abc9 -top $(PROJTOP) -json $@"

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

dfu_flash: $(PROJECTNAME).bit
	dfu-util$(EXE) -d 1d50:614a,1d50:614b -a 0 -R -D $(PROJECTNAME).bit

clean:
	rm -f *.svf *.bit *.config *.json

.PHONY: prog clean
