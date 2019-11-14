
# Somehwere, there are the following
#
# export RISCV_TOOLCHAIN_PATH="$HOME/opt/xPacks/riscv-none-embed-gcc/8.2.0-3.1/bin"
# export RISCV_TOOLCHAIN_PREFIX="riscv-none-embed-"
#

TRELLIS=/usr/share/trellis

PREFIX := $(RISCV_TOOLCHAIN_PATH)/$(RISCV_TOOLCHAIN_PREFIX)


BASENAME := led_uart_soc
PROJECT := $(BASENAME)

CC := $(PREFIX)gcc
AR := $(PREFIX)ar
LD := $(PREFIX)ld
OBJCOPY := $(PREFIX)objcopy
OBJDUMP := $(PREFIX)objdump
SIZE := $(PREFIX)size

PROJECT_SRC := ../projects/$(PROJECT)
PICORV32_ASM := ../../picorv32/asm
PICORV32_RTL := ../../picorv32/rtl
PICORV32_SIM := ../../picorv32/sim

CLOCK_IN_MHZ = 8
CLOCK_MHZ    = 48

DEVICE = 45k
PACKAGE = CABGA381
SPEED = 8

CONSTR=$(PROJECT_SRC)/hadbadge_v2.lpf

TRELLIS=/usr/share/trellis

all: $(BASENAME).bit

clock_pll.v: Makefile
	ecppll --clkin_name CLKI -i $(CLOCK_IN_MHZ) --clkout0_name CLKOP -o $(CLOCK_MHZ) -f $@ -n clock_pll

PRJ_SOURCE = $(PROJECT_SRC)/top.v $(PROJECT_SRC)/$(BASENAME).v clock_pll.v
RTL_SOURCE = $(PICORV32_RTL)/picorv32.v $(PICORV32_RTL)/simpleuart.v

firmware.elf: $(PICORV32_ASM)/start.s $(PROJECT_SRC)/sections.lds $(PROJECT_SRC)/firmware.c
	$(CC) -march=rv32i -Wl,-Bstatic,-T,$(PROJECT_SRC)/sections.lds,--strip-debug -ffreestanding -nostdlib -o firmware.elf $(PICORV32_ASM)/start.s  $(PROJECT_SRC)/firmware.c

firmware.bin: firmware.elf
	$(OBJCOPY) -O binary firmware.elf /dev/stdout > firmware.bin

firmware.hex: firmware.bin
	python3 makehex.py $^ 4096 > $@

$(BASENAME)_tb.vvp: $(PROJECT_SRC)/$(BASENAME)_tb.v $(RTL_SOURCE) $(PRJ_SOURCE)
	iverilog -s testbench -o $@ $^

$(BASENAME)_sim: $(BASENAME)_tb.vvp firmware.hex
	vvp -N $<

$(BASENAME).json: $(RTL_SOURCE) $(PRJ_SOURCE) firmware.hex
	yosys -p "synth_ecp5 -json $@ -top top" $(RTL_SOURCE) $(PRJ_SOURCE)

$(BASENAME)_out.config: $(BASENAME).json $(CONSTR)
	nextpnr-ecp5 --json $< --freq $(CLOCK_MHZ) --pre-pack clock_constraints.py --textcfg $@ --$(DEVICE) --speed $(SPEED) --package $(PACKAGE) --lpf $(CONSTR)

gui: $(BASENAME).json $(PROJECT_SRC)/ecp5evn.lpf
	nextpnr-ecp5 --json $< --freq $(CLOCK_MHZ) --pre-pack clock_constraints.py --textcfg $@ --$(DEVICE) --speed $(SPEED) --package $(PACKAGE) --lpf $(CONSTR) --gui

$(BASENAME).bit: $(BASENAME)_out.config
	ecppack --svf-rowsize 100000 --svf $(BASENAME).svf $< $@

%.svf: %.bit

prog: $(BASENAME).svf
	openocd -f ${TRELLIS}/misc/openocd/ecp5-evn.cfg -c "transport select jtag; init; svf $<; exit"

flash: $(BASENAME).bit
	tinyprog -p $(BASENAME).bit -a 0x180000

.PHONY: $(BASENAME)_sim clean prog
.PRECIOUS: $(BASENAME).json $(BASENAME)_out.config $(BASENAME).bit

