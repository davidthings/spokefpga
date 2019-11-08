---
layout: single_tech
title: "LCD"
permalink : /lcd
toc: true
toc_label: Contents
toc_sticky: true
wavedrom : 1
# threejs: 1
header:
  title: LCD
  overlay_image: /assets/images/spokefpga_banner_thin.png
---

# Overview


LCD is designed for the Hackaday Badge 2019, 480 x 320.  16b / pixel.  Arranged as 5'Red, 6'Green, 5'Blue. It has a frame buffer.

Mostly LCD will be used inside higher level modules to provide more than just fill and rectangle services.

Basic operations are Write Rectangle and Read Rectangle and Fill Rect.

Commands are issued on the command port.

# Modules

There are several LCD Modules

- lcd
- lcd_proxy

## LCD

LCD connects to the panel, sends the initialization command stream, then sits and waits for commands.

<div id="lcd-diagram"></div>

<script type="text/javascript">

    const lcd_diagram = {
        id: "",
        children: [
            {
                highlight:1,
                id: "lcd",
                parameters: [
                    "Width",
                    "Height"
                ],
                northPorts: [
                    "clock",
                    "reset"
                ],
                westPorts: [
                    "command",
                    "abort",
                    "ready",
                    "fill_pixel",
                    "rect_x0",
                    "rect_x1",
                    "rect_y0",
                    "rect_y1",
                    "pixel_x",
                    "pixel_y",
                    "rect_pixel_write",
                    "rect_pixel_write_valid",
                    "rect_pixel_write_ready",
                    "rect_pixel_read",
                    "rect_pixel_read_valid",
                    "rect_pixel_read_ready"
                ],
                eastPorts: [
                    "lcd_db",
                    "lcd_wr",
                    "lcd_rs",
                    "lcd_cs",
                    "lcd_id",
                    "lcd_rst",
                    "lcd_fmark",
                    "lcd_blen"
                ]
            },
        ],
        edges: [
        ]
    }

    hdelk.layout( lcd_diagram, "lcd-diagram" );
</script>


The module responds to a few commands (defined in lcd_defs.v)

- `LCD_COMMAND_CONFIGURE` - configures the panel - must be called before other commands will work
- `LCD_COMMAND_FILL_RECT` - puts a single color (fill_pixel) in the specified rectangle (rect_x0,rect_y0,rect_x1,rect_y1)
- `LCD_COMMAND_WRITE_RECT` - writes into the specified rectangle, pixels supplied to the rect_pixel_write port
- `LCD_COMMAND_READ_RECT` - reads pixels from a rectangle, pixels output to the rect_pixel_read_port

Many of the parameters of the design are brought out as module parameters, however the default values work with the present hardware, so they can be left untouched.  Being able to change them helps with simulation (where sometimes, for example, smaller panels are created to shorten simulation time)

### Parameters

| Name                   | Description                       | Default | Comment
| -                      | -                                 | -       | -
| `Width`                | Width  of the panel               | 480     |
| `Height`               | Height  of the panel              | 320     |
| `CoordinateWidth`      | Width of all co-ordinates         | 9       |
| `DataWidth`            | Width of the data path to the LCD | 18      |
| `PixelWidth`           | Total width of all pixels         | 16      |
| `PixelRedWidth`        | Width of the Red component        | 5       |
| `PixelGreenWidth`      | Width of the Blue component       | 6       |
| `PixelBlueWidth`       | Width of the Green component      | 5       |
| `CommandWidth`         | Width of the Command line         | 3       | (Room for Configure, Fill, Write, Read and None)
| `CommandDataTimerCount`| Additional Clock cycles per Read/Write Op   | 0        | 0 is top speed
| `DelayTimerCount`      | How many cycles to delay between commands   | 10000    | Could be optimized to less

### Ports

| Name                     |  Dir   | Width           | Description                |   Comment
| -                        |        |                 | -                          |   -
| `clock`                  | In     | 1               | Module clock               |   Tested at 48MHz          |
| `reset`                  | In     | 1               | Module reset               |                            |
|                          |        |                 |                            |                            |
| `command`                | In     | CommandWidth    | Command                    | One of `NOP`, `Configure`, `Fill Rect`, `Write Rect`, `Read Rect` |
| `abort`                  | In     | 1               | Stops the current operation|                            |
| `ready`                  | Out    | 1               | LCD is ready for a command |                            |
|                          |        |                 |                            |                            |
| `fill_pixel`             | In     | PixelWidth      | Pixel value for fill rect  |                            |
|                          |        |                 |                            |                            |
| `rect_x0`                | In     | CoordinateWidth | Rectangle to be used in commands   |                            |
| `rect_x1`                | In     | CoordinateWidth |                            |                            |
| `rect_y0`                | In     | CoordinateWidth |                            |                            |
| `rect_y1`                | In     | CoordinateWidth |                            |                            |
|                          |        |                 |                            |                            |
| `pixel_x`                | Out    | CoordinateWidth | Outputs X during Read or Write     |                            |
| `pixel_y`                | Out    | CoordinateWidth | Outputs Y during Read or Write     |                            |
|                          |        |                 |                            |                            |
| `rect_pixel_write`       | In     | PixelWidth      | Pixel data to write        |                            |
| `rect_pixel_write_valid` | In     | 1               | Pixel data is valid        |                            |
| `rect_pixel_write_ready` | Out    | 1               | Module is ready            |                            |
|                          |        |                 |                            |                            |
| `rect_pixel_read`        | Out    | PixelWidth      | Pixel data read            |                            |
| `rect_pixel_read_valid`  | Out    | 1               | Pixel data is valid        |                            |
| `rect_pixel_read_ready`  | In     | 1               | External module is ready   |                            |
|                          |        |                 |                            |                            |
| `lcd_db`                 | In/Out | DataWidth       | LCD Data                   |                            |
| `lcd_rd`                 | Out    | 1               | LCD ~Read Enable           |                            |
| `lcd_wr`                 | Out    | 1               | LCD ~Read Enable           |                            |
| `lcd_rs`                 | Out    | 1               |                            |                            |
| `lcd_cs`                 | Out    | 1               |                            |                            |
| `lcd_id`                 | In     | 1               |                            |  What is this, again?      |
| `lcd_rst`                | Out    | 1               |                            |                            |
| `lcd_fmark`              | Out    | 1               |                            |                            |
| `lcd_blen`               | In     | 1               | LCD Backlight              |                            |

### Hardware Connection

Hackaday Badge

The LCD is fixed on the board, and the hardware lines are named in the constraints file and presented as top level ports, so connection is easy.  Just drop them in.


### Invocation

``` verilog
    localparam CoordinateWidth = 9;
    localparam PixelWidth = 16;
    localparam PixelRedWidth = 5;
    localparam PixelGreenWidth = 6;
    localparam PixelBlueWidth = 5;
    localparam CommandWidth = 3;

    reg [ CommandWidth-1:0]   command;
    wire                      ready;

    reg [PixelWidth-1:0]      fill_pixel;

    reg [CoordinateWidth-1:0] rect_x0;
    reg [CoordinateWidth-1:0] rect_x1;
    reg [CoordinateWidth-1:0] rect_y0;
    reg [CoordinateWidth-1:0] rect_y1;

    reg [CoordinateWidth-1:0] pixel_x;
    reg [CoordinateWidth-1:0] pixel_y;

    reg [PixelWidth-1:0]      rect_pixel_write;
    reg                       rect_pixel_write_valid;
    wire                      rect_pixel_write_ready;
    wire [PixelWidth-1:0]     rect_pixel_read;
    wire                      rect_pixel_read_valid;
    reg                       rect_pixel_read_ready;

    lcd l (
            .clock( clock ),
            .reset( reset ),

            .command( command ),
            .ready( ready ),

            .fill_pixel( fill_pixel ),

            .rect_x0( rect_x0 ),
            .rect_x1( rect_x1 ),
            .rect_y0( rect_y0 ),
            .rect_y1( rect_y1 ),

            .pixel_x( pixel_x ),
            .pixel_y( pixel_y ),

            .rect_pixel_write( rect_pixel_write ),
            .rect_pixel_write_valid( rect_pixel_write_valid ),
            .rect_pixel_write_ready( rect_pixel_write_ready ),

            .rect_pixel_read( rect_pixel_read ),
            .rect_pixel_read_valid( rect_pixel_read_valid ),
            .rect_pixel_read_ready( rect_pixel_read_ready ),

            .lcd_db(lcd_db),
            .lcd_rd(lcd_rd),
            .lcd_wr(lcd_wr),
            .lcd_rs(lcd_rs),
            .lcd_cs(lcd_cs),
            .lcd_id(lcd_id),
            .lcd_rst(lcd_rst),
            .lcd_fmark(lcd_fmark),
            .lcd_blen(lcd_blen)
        );
```

#### Testing

Tested in lcd_tb.v

Tested on the Hackaday 2019 Badge (ECP5)


## LCD Proxy

Implemented to provide something to test the `lcd` against.  Connects to `lcd` via the 8 ports that would normally go to real hardware.

Implements Fill Rect and Write Buffer into a frame buffer.

Provides debug access to the frame buffer for testing.

<br>
<div id="lcd-proxy-diagram"></div>

<script type="text/javascript">

    const lcd_proxy_diagram = {
        id: "",
        children: [
            {
                highlight:1,
                id: "lcd_proxy",
                parameters: [
                    "Width",
                    "Height"
                ],
                northPorts: [
                    "clock",
                    "reset"
                ],
                eastPorts: [
                    "lcd_out_x",
                    "lcd_out_y",
                    "lcd_out_p"
                ],
                westPorts: [
                    "lcd_db",
                    "lcd_wr",
                    "lcd_rs",
                    "lcd_cs",
                    "lcd_id",
                    "lcd_rst",
                    "lcd_fmark",
                    "lcd_blen"
                ]
            },
        ],
        edges: [
        ]
    }

    hdelk.layout( lcd_proxy_diagram, "lcd-proxy-diagram" );
</script>
