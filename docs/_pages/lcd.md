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

## Overview


LCD is designed for the Hackaday Badge 2019, 480 x 320.  16b / pixel.  Arranged as 5'Red, 6'Green, 5'Blue. It has a frame buffer.

Basic operations are Write Rectangle and Read Rectangle.  Also there is Fill Rect.

The drive responds to commands, and reading and writing data.


## Module

LCD `lcd.v`


The module responds to a few commands (defined in lcd_defs.v)

`LCD_COMMAND_CONFIGURE` - configures the panel - must be called before other commands will work
`LCD_COMMAND_FILL_RECT` - puts a single color (fill_pixel) in the specified rectangle (rect_x0,rect_y0-rect_x1,rect_y1)
`LCD_COMMAND_WRITE_RECT` - writes into the specified rectangle, pixels supplied to the rect_pixel_write port
`LCD_COMMAND_READ_RECT` - reads pixels from a rectangle, pixels output to the rect_pixel_read_port

Many of the parameters of the design are brought out as module parameters, however the default values work with the present hardware, so they can be left untouched.


### Parameters

| Name                   | Description                   | Default | Comment
| -                      | -                             | -       | -
| `Width`                | Width  of the panel           |         |
| `Height`               | Height  of the panel          |         |
| `Width`                |                               | 480     |
| `Height`               |                               | 320     |
| `CoordinateWidth`      |                               | 9       |
| `DataWidth`            |                               | 18      |
| `PixelWidth`           |                               | 16      |
| `PixelRedWidth`        |                               | 5       |
| `PixelGreenWidth`      |                               | 6       |
| `PixelBlueWidth`       |                               | 5       |
| `CommandWidth`         |                               | 3       |
| `CommandDataTimerCount`|                               | 2       |
| `DelayTimerCount`      |                               | 1000    |

### Ports

| Name                     | Description                |   Comment
| -                        | -                          |   -
| `clock`                  |                            |                            |
| `reset`                  |                            |                            |
|                          |                            |                            |
| `command`                |                            |                            |
| `ready`                  |                            |                            |
|                          |                            |                            |
| `fill_pixel`             |                            |                            |
|                          |                            |                            |
| `rect_x0`                |                            |                            |
| `rect_x1`                |                            |                            |
| `rect_y0`                |                            |                            |
| `rect_y1`                |                            |                            |
|                          |                            |                            |
| `pixel_x`                |                            |                            |
| `pixel_y`                |                            |                            |
|                          |                            |                            |
| `rect_pixel_write`       |                            |                            |
| `rect_pixel_write_valid` |                            |                            |
| `rect_pixel_write_ready` |                            |                            |
|                          |                            |                            |
| `rect_pixel_read`        |                            |                            |
| `rect_pixel_read_valid`  |                            |                            |
| `rect_pixel_read_ready`  |                            |                            |
|                          |                            |                            |
| `lcd_db`                 |                            |                            |
| `lcd_rd`                 |                            |                            |
| `lcd_wr`                 |                            |                            |
| `lcd_rs`                 |                            |                            |
| `lcd_cs`                 |                            |                            |
| `lcd_id`                 |                            |                            |
| `lcd_rst`                |                            |                            |
| `lcd_fmark`              |                            |                            |
| `lcd_blen`               |                            |                            |

### Hardware Connection

Hackaday Badge

The LCD is fixed on the board, and the hardware lines are named in the constraints file and presented as top level ports, so connection is easy.  Just drop them in.

## Invocation

``` verilog
    localparam Width = 480;
    localparam Height = 320;
    localparam CoordinateWidth = 9;
    localparam DataWidth = 18;
    localparam PixelWidth = 16;
    localparam PixelRedWidth = 5;
    localparam PixelGreenWidth = 6;
    localparam PixelBlueWidth = 5;
    localparam DelayTimerCount = 10000;
    localparam CommandDataTimerCount = 2;
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

    lcd #(
            .Width( Width ),
            .Height( Height ),
            .CoordinateWidth( CoordinateWidth ),
            .CommandWidth( CommandWidth ),
            .DataWidth( DataWidth ),
            .PixelWidth( PixelWidth ),
            .PixelRedWidth( PixelRedWidth ),
            .PixelGreenWidth( PixelGreenWidth ),
            .PixelBlueWidth( PixelBlueWidth ),
            .CommandDataTimerCount( CommandDataTimerCount ),
            .DelayTimerCount( DelayTimerCount )
        ) l (
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

## Testing

Tested in lcd_tb.v

Tested on the Hackaday 2019 Badge (ECP5)
