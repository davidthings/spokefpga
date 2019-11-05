![](/docs/assets/images/spokefpga_banner_thin.png)

# Source Code

All the SpokeFGPA source code is maintained in this source tree.
```
SRC
 |
 |---comms
 |---drivers
 |---hadbadge2019
 |---pipe
```

## Common Structure

All the source code directories have the same structure

```
Section
 |
 |---projects
 |---rtl
 |---sim
```

- projects - contains all the projects centered around this section
- rtl - contains the verilog source code for the modules
- sim - contains the testbench code for the modules

## Sections

### hadbadge2019

Projects

- `led_blink` - blink an LED
- `usb_loopback` - instanciates a USB serial device, incoming characters are looped back
- `lcd_pattern` - puts a few patterns on the LCD
- `camera_2_lcd` - plain camera to lcd direct connection.  Requires a suitably connected MT9V022 or MT9V034 camera.

### comms

Code

- usb cdc
- i2c master and slave
- uart-in and uart-out

### drivers

Code

- camera - driver for the Aptina MT9V022 camera
- lcd - driver for the 480 x 320 MIPI Type II  LCD

Projects

- camera_ic - Icarus-based testing for the camera
- lcd_ic - Icarus-based testing for the lcd

### pipe

Various pipeline helpers

### utils

General utilities


