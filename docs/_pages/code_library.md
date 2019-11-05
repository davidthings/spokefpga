---
layout: single_tech
title: "Code Library"
permalink : /code_library
toc: true
toc_label: Contents
toc_sticky: true
header:
  title: Code Library
  overlay_image: /assets/images/spokefpga_banner_thin.png
---

# Code Library

The SpokeFPGA Code library is a collection of code designed to create a basis for easy programming of the FPGA

## Prerequisites

This code is all developed under Linux, using the command line where possible.  Basic skills in the following areas are required:

- Git
- Bash or other *nix command line
- Make

Thereafter the skills depend on the activity.

## Getting the Code

You can download from github [https://github.com/davidthings/spokefpga](https://github.com/davidthings/spokefpga) or clone the repo with the following

```
git clone https://github.com/davidthings/spokefpga.git
```

This will clone the entire site - code and doc.

## Layout

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

- projects - contains all the projects centered around the section
- rtl - contains the Verilog source code for the modules
- sim - contains the testbench code for the modules

To build, go into the projects directory, eg.

```
cd src/comms/projects
```

There you will see the projects that are available.  Pick one and then type

```
./prepare [project name]
```

The `prepare` script creates a .gitignored build directory in the sub-directory
(`src/comms` in this example) called `build_[project name]`

Now, if you navigate into this new build directory you will see some tools that you can use, depending on the project type.

For example, most build directories will contain a Makefile that is all set up and ready to go.

## Documentation

Documentation for the larger systems is presented on the SpokeFPGA website.

Other documentation can be found in the Section readmes.

Finally, the source code itself has documentation.

## Code Overview

### Comms

Code

- `i2c_master` and `i2c_slave` [Documentation]({{site.baseurl}}/i2c)
- `usb_uart` cdc device code
- `uart` transmitter and receiver

Projects

- `i2c_master_slave_ic` - Icarus-based testing for the I2C modules

### Drivers

Code

- `camera_core` - driver for the Aptina MT9V022 camera [Documentation]({{site.baseurl}}/camera)
- `lcd` - driver for the 480 x 320 MIPI Type II  LCD [Documentation]({{site.baseurl}}/lcd)

Projects

- `camera_ic` - Icarus-based testing for the camera
- `lcd_ic` - Icarus-based testing for the lcd

### HaDBadge2019

Projects

- `led_blink` - blink an LED
- `usb_loopback` - instanciates a USB serial device, incoming characters are looped back
- `lcd_pattern` - puts a few patterns on the LCD
- `camera_2_lcd` - plain camera to lcd direct connection.  Requires a suitably connected MT9V022 or MT9V034 camera.

### Pipe

Contains helpers to implement Pipelines.

### Utils

Contains various helpers
