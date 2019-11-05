![](/docs/assets/images/spokefpga_banner_thin.png)

### HaDBadge2019

Projects

- `led_blink` - blink an LED
- `usb_loopback` - instanciates a USB serial device, incoming characters are looped back
- `lcd_pattern` - puts a few patterns on the LCD
- `camera_2_lcd` - plain camera to lcd direct connection.  Requires a suitably connected MT9V022 or MT9V034 camera.

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

Documentation for the larger systems is presented on the SpokeFPGA [website](http://localhost:4000/spokefpga/#top).

The source code itself has documentation.

