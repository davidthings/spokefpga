
prj_project new -name "hadbadge2019_usb" -lpf "../projects/hadbadge2019_usb/had19_proto2.lpf" -impl "impl1" -dev LFE5U-45F-8BG381C -synthesis "lse"

prj_src add "../projects/hadbadge2019_usb/hadbadge2019_usb.v"

# prj_src_add "../../drivers/rtl/lcd.v"
# prj_src_add "../../drivers/sim/lcd_tb.v"
# prj_src_add "../../drivers/sim/lcd_proxy.v"

prj_src add "../../pipe/rtl/pipe_escape.v"
prj_src add "../../pipe/rtl/pipe_unescape.v"
prj_src add "../../pipe/rtl/pipe_fifo.v"
prj_src add "../../pipe/rtl/pipe_frontend.v"
prj_src add "../../pipe/rtl/pipe_utils.v"
prj_src add "../../pipe/rtl/pipe_defs.v"

prj_src add "../../comms/rtl/usb/edge_detect.v"
prj_src add "../../comms/rtl/usb/serial.v"
prj_src add "../../comms/rtl/usb/usb_fs_in_arb.v"
prj_src add "../../comms/rtl/usb/usb_fs_in_pe.v"
prj_src add "../../comms/rtl/usb/usb_fs_out_arb.v"
prj_src add "../../comms/rtl/usb/usb_fs_out_pe.v"
prj_src add "../../comms/rtl/usb/usb_fs_pe.v"
prj_src add "../../comms/rtl/usb/usb_fs_rx.v"
prj_src add "../../comms/rtl/usb/usb_fs_tx_mux.v"
prj_src add "../../comms/rtl/usb/usb_fs_tx.v"
prj_src add "../../comms/rtl/usb/usb_reset_det.v"
prj_src add "../../comms/rtl/usb/usb_serial_ctrl_ep.v"
prj_src add "../../comms/rtl/usb/usb_uart_bridge_ep.v"
prj_src add "../../comms/rtl/usb/usb_uart_core.v"
prj_src add "../../comms/rtl/usb/usb_uart_ecp5.v"

prj_impl option top "hadbadge2019_usb"

# this got created by Clarity Designer, clock_pll.sbx, clock_pll.lpc, and generate_core.tcl
# got dumped in the clock_pll build dir
# they were then moved to the project directory and the following lines added
# Steps
# - within Diamond, run Clarity
# - select "Start Clarity Designer to generate a single component..."
# - from the pallete, select pll
# - enter name "clock_pll"
# - language Module Output: "Verilog"
# - select clock in frequency eg. 8
# - select clock out frequency eg. 48
# - hit configure
# - There will be a new directory in the build directory, this can be copied into the project build folder.
# - a set of lines like the below can recreate the IP in new instances of the project

set currentPath [pwd];set tmp_autopath $auto_path
file mkdir "clock_pll"
cd "clock_pll"
source "generate_core.tcl"
set auto_path $tmp_autopath;cd $currentPath

prj_src add "clock_pll/clock_pll.sbx"

prj_project save

#prj_src add "clock_pll.v"


