![](/docs/assets/images/spokefpga_banner_thin.png)

## Drivers

Code

- `camera_core` - driver for the Aptina MT9V022 camera [Documentation](https://davidthings.github.io/spokefpga/camera)
- `camera_image` - using `camera_core` creates images suitable for image pipeline modules
- `lcd` - driver for the 480 x 320 MIPI Type II  LCD [Documentation](https://davidthings.github.io/spokefpga/lcd)
- `lcd_image` - using `lcd` takes images from a image pipeline and displays them
- `lcd_image_n` - using `lcd` takes images from multiple image pipelines and displays them all

Projects

- `camera_ic` - Icarus-based testing for the camera
- `lcd_ic` - Icarus-based testing for the lcd
- `camera_image_ic` - Icarus-based testing for the image pipeline-based camera
- `lcd_image_ic` - Icarus-based testing for the lcd image module
- `lcd_image_n_ic` - Icarus-based testing for the lcd image n module

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
