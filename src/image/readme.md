![](/docs/assets/images/spokefpga_banner_thin.png)

## Image

Overview

These modules use the image spec definitions from image_defs.h (and pipe specs too) to create pipelines
for images. From the `drivers` directory `camera_image` can create images from a camera and `lcd_image` and
`lcd_image_n` can display one or more images (respectively) on an lcd.

Code

- `image_defs.v` - include file for image helper macros
- `image_fifo` - buffering pixels (helps with fast camera and slow lcd)
- `image_background` - creates solid or simple patterned images for use as backgrounds
- `image_reformat` - converts between pixel formats (currently mostly for grayscale to rgb)
- `image_debayer` - using a half line buffer, converts incoming bayer patterned pixels to rgb

Projects

- testing for the above

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



