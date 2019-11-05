##
## Make and program Superconference 2019 Badge
##

BASENAME = lcd_pattern
PROJECTNAME = $(BASENAME)
PROJTOP = $(PROJECTNAME)

PROJECT_DIR      = ../projects/$(PROJECTNAME)
RTL_DIR          = ../rtl
DRIVERS_RTL_DIR  = ../../drivers/rtl
COMMS_RTL_DIR    = ../../comms/rtl
PIPE_RTL_DIR     = ../../pipe/rtl
COMMS_USB_RTL_DIR   = $(COMMS_RTL_DIR)/usb

SOURCES = \
	$(DRIVERS_RTL_DIR)/lcd.v \
	$(COMMS_USB_RTL_DIR)/edge_detect.v \
	$(COMMS_USB_RTL_DIR)/serial.v \
	$(COMMS_USB_RTL_DIR)/usb_fs_in_arb.v \
	$(COMMS_USB_RTL_DIR)/usb_fs_in_pe.v \
	$(COMMS_USB_RTL_DIR)/usb_fs_out_arb.v \
	$(COMMS_USB_RTL_DIR)/usb_fs_out_pe.v \
	$(COMMS_USB_RTL_DIR)/usb_fs_pe.v \
	$(COMMS_USB_RTL_DIR)/usb_fs_rx.v \
	$(COMMS_USB_RTL_DIR)/usb_fs_tx_mux.v \
	$(COMMS_USB_RTL_DIR)/usb_fs_tx.v \
	$(COMMS_USB_RTL_DIR)/usb_reset_det.v \
	$(COMMS_USB_RTL_DIR)/usb_serial_ctrl_ep.v \
	$(COMMS_USB_RTL_DIR)/usb_uart_bridge_ep.v \
	$(COMMS_USB_RTL_DIR)/usb_uart_core.v \
	$(COMMS_USB_RTL_DIR)/usb_uart_ecp5.v \
 	$(PIPE_RTL_DIR)/pipe_utils.v \
	clock_pll.v

#	$(PIPE_RTL_DIR)/pipe_utils.v \

BADGE_VER ?= 2

#Image read mode: qspi, dual-spi, fast-read
FLASH_MODE=qspi
#Image read freq, in MHz: 2.4, 4.8, 9.7, 19.4, 38.8, 62.0
FLASH_FREQ=38.8 #MHz

SRC = $(PROJECT_DIR)/$(PROJTOP).v $(SOURCES)

CONSTR=$(PROJECT_DIR)/$(word $(BADGE_VER), had19_proto1.lpf had19_proto2.lpf had19_proto3.lpf had19_prod.lpf)

DEVICE = 45k
PACKAGE = CABGA381
SPEED = 8

CLOCK_IN_MHZ = 8
CLOCK_MHZ    = 48

TRELLIS=/usr/share/trellis

all: ${PROJECTNAME}.bit

clock_pll.v: Makefile
	ecppll --clkin_name CLKI -i $(CLOCK_IN_MHZ) --clkout0_name CLKOP -o $(CLOCK_MHZ) -f $@ -n clock_pll

%.json: $(SRC)
	yosys -p "read -sv -DBADGE_VER=$(BADGE_VER) -DBADGE_V$(BADGE_VER)=1 $(SRC);\
	          synth_ecp5 -abc9 -top $(PROJTOP) -json $@"

%_out.config: %.json
	nextpnr-ecp5 --json $< --freq $(CLOCK_MHZ) --pre-pack clock_constraints.py --textcfg $@ --$(DEVICE) --speed $(SPEED) --package $(PACKAGE) --lpf $(CONSTR)

gui: $(LPF_DEF) $(PROJTOP).json
	nextpnr-ecp5 --freq $(CLOCK_MHZ) --pre-pack clock_constraints.py --textcfg $(PROJTOP)_out.config --$(DEVICE) --speed $(SPEED) --package $(PACKAGE) --lpf $(CONSTR) --json $(PROJTOP).json --gui

%.bit: %_out.config
	ecppack --spimode $(FLASH_MODE) --freq $(FLASH_FREQ) --input $< --bit $@

${PROJECTNAME}.svf : ${PROJECTNAME}.bit

prog: ${PROJECTNAME}.svf
	openocd -f ${TRELLIS}/misc/openocd/ecp5-evn.cfg -c "transport select jtag; init; svf $<; exit"

flash: $(PROJECTNAME).bit
	tinyprog -p $(PROJECTNAME).bit -a 0x180000

dflash: impl1/${PROJECTNAME}_impl1.bit
	tinyprog -p impl1/${PROJECTNAME}_impl1.bit -a 0x180000

clean:
	rm -f *.svf *.bit *.config *.json

.PHONY: prog clean dflash
