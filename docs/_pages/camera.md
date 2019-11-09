---
layout: single_tech
title: "Camera"
permalink : /camera
toc: true
toc_label: Contents
toc_sticky: true
wavedrom : 0
# threejs: 1
header:
  title: Camera
  overlay_image: /assets/images/spokefpga_banner_thin.png
---

## Overview

The Camera module is designed for the MT9V022 & 034 cameras from On Semiconductor, formerly Aptina.  Internally there is a flexible configuration and control system, however only a tiny fraction of the camera's features are surfaced.

The Module connects to the camera in two ways: via I2C for configuration and control.  Other modules can connect to the Camera module's data port and control lines.

The camera natively is 752 x 482 pixels, and can present a subwindow.  The subwindow is set via the `set_window` line (where `column_start`, `row_start`, `window_width` and `window_height` have been set up.  The origin can be independently set via `set_origin` (using `column_start`, `row_start` again).

Surprising in the age of LCD panels, blanking is still important!  Both horizontal and vertical blanking are set via `set_blanking` (with the correct values on `horizontal_blanking` and `vertical_blanking`) Horizontal blanking is a critical means to slow the presentation of data to the system.  The camera is incredibly fast, so a long horizontal blanking interval allows a FIFO to be filled and emptied without stalling the camera.  Vertical blanking can give the sensor extra time for exposure.

Two tasks remain to `camera_core` users: 1) to wire the I2C lines up appropriately and 2) to provide the xclk.

<div id="camera-diagram"></div>

<script type="text/javascript">

    const camera_diagram = {
        id: "",
        children: [
            {
                highlight:1,
                id: "camera_core",
                parameters: [
                    "Width",
                    "Height"
                ],
                northPorts: [
                    "clock",
                    "reset"
                ],
                eastPorts: [
                    "configure",
                    "start",
                    "stop",
                    "configuring",
                    "error",
                    "idle",
                    "running",
                    "busy",
                    "column_start",
                    "row_start",
                    "window_width",
                    "window_height",
                    "set_origin",
                    "set_window",
                    "horizontal_blanking",
                    "vertical_blanking",
                    "set_blanking",
                    "snapshot_mode",
                    "set_snapshot_mode",
                    "snapshot",
                    "out_vs",
                    "out_hs",
                    "out_valid",
                    "out_d"
                ],
                westPorts: [
                    "scl_out",
                    "scl_in",
                    "sda_out",
                    "sda_in",
                    "vs",
                    "hs",
                    "pclk",
                    "d",
                    "rst",
                    "pwdn",
                    "led",
                    "trigger"
                ]
            }
        ],
        edges: [
        ]
    }

    hdelk.layout( camera_diagram, "camera-diagram" );
</script>


# Modules

There are several Camera Modules

- camera_core (internally camera_config, including i2c_master_core)
- camera_proxy

## Camera Core

Camera connects to the panel, sends the initialization command stream, then sits and waits for commands.

<div id="camera-core-diagram"></div>

<script type="text/javascript">

    const camera_core_diagram = {
        id: "",
        children: [
            {
                highlight:1,
                id: "camera_core",
                parameters: [
                    "Width",
                    "Height"
                ],
                northPorts: [
                    "clock",
                    "reset"
                ],
                eastPorts: [
                    "control",
                    "status",
                    "window_control",
                    "blanking_control",
                    "snapshot_control",
                    "data_port"
                ],
                westPorts: [
                    "camera_i2c",
                    "camera_data"
                ],
                children: [
                    {
                        id:"internals",
                        ports: [
                            "i2c_in",
                            "i2c_out",
                            "camera_data",
                            "status",
                            "control"
                        ],
                        southPorts: [
                            "data_port"
                        ]
                    },
                    {
                        id:"camera_config",
                        ports: [
                            "status",
                            "control",
                            "window",
                            "snapshot",
                            "blanking"
                        ]
                    },
                    {
                        id:"i2c_master_core",
                        ports: [
                            "i2c_signals",
                            "pipe_in",
                            "pipe_out"
                        ]
                    }
                ],
                edges:[
                    ["i2c_master_core.i2c_signals", "camera_core.camera_i2c"],
                    ["camera_core.camera_i2c","i2c_master_core.i2c_signals"],
                    ["i2c_master_core.pipe_out", "internals.i2c_in"],
                    ["internals.i2c_out", "i2c_master_core.pipe_in" ],
                    ["camera_core.video_data",    "internals.camera_data" ],
                    ["camera_core.window_control", "camera_config.window" ],
                    ["internals.data_port","camera_core.data_port"],
                    ["camera_core.snapshot_control", "camera_config.snapshot" ],
                    ["camera_core.blanking_control", "camera_config.blanking"],
                    ["camera_config.status", "camera_core.status"],
                    ["camera_core.control", "internals.control"],
                    ["internals.status", "camera_core.status"],
                    ["camera_core.control","camera_config.control"]
                ]
            },
        ],
        edges: [
        ]
    }

    hdelk.layout( camera_core_diagram, "camera-core-diagram" );
</script>



### Parameters

| Name              | Description          | Default | Comment
| -                 | -                    | -       | -
| `Width`           |                      | 752     | Fixed for the camera, of course, but handy to be able to reduce it for simulation
| `Height`          |                      | 482     | As above
| `CoordinateWidth` |                      | 10      | 0-1023
| `BlankingWidth`   |                      | 16      | 0-65536
| `CameraPixelWidth`|                      | 10      | 10 bits
| `I2CClockCount`   |                      | 200     | Clock divider for I2C bit clock (eg. 48MHz/200 = 240kbps)
| `I2CGapCount`     |                      | 256     | Cycles between I2C messages

### Ports

| Name                     | Dir | Width           | Description                |   Comment
| -                        | -      |-                | -                          |   -
| `clock`                  | In     | 1               | Module clock               |
| `reset`                  | In     | 1               | Module reset               |
|                          |        |                 |                            |
|  configure               | In     | 1               | Configure the hardware     | Takes the module into `configuring` mode.  `idle` when complete.
|  start                   | In     | 1               | Goes from idle to running  |
|  stop                    | In     | 1               | Go from running to idle    |
|                          |        |                 |                            |
|  configuring             | Out    | 1               | Device is configuring      |
|  error                   | Out    | 1               | Hardware error             | Communication timeout
|  idle                    | Out    | 1               | Idle - not started         |
|  running                 | Out    | 1               | In a running state         |
|  busy                    | Out    | 1               | Device Busy                |
|                          |        |                 |                            |
|  column_start            | In     | CoordinateWidth | Left corner of capture     |
|  row_start               | In     | CoordinateWidth | Top corner of capture      |
|  window_width            | In     | CoordinateWidth | Capture window width       |
|  window_height           | In     | CoordinateWidth | Capture window height      |
|  set_origin              | In     | 1               | Update Top Left corner     |
|  set_window              | In     | 1               | Set the whole capture window |
|                          |        |                 |                              |
|  horizontal_blanking     | In     | BlankingWidth   | Clocks requested for horizontal blanking | Try 700
|  vertical_blanking       | In     | BlankingWidth   | Clocks requested for vertical blanking | Try 500
|  set_blanking            | In     | 1               | Sets the specified intervals |
|                          |        |                 |                            |
|  snapshot_mode           | In     | 1               |  T/F                       |
|  set_snapshot_mode       | In     | 1               | Sets the above mode        |
|  snapshot                | In     | 1               | Take a snapshot            | This mode is hard to use because it turns AGC off
|                          |        |                 |                            |
|  out_vs                  | Out    | 1               |                            | Vertical Sync
|  out_hs                  | Out    | 1               |                            | Horizontal Sync
|  out_valid               | Out    | 1               |                            | Data is Valid
|  out_d                   | Out    | CameraPixelWidth|                            | Data
|                          |        |                 |                            |
|  scl_out                 | Out    | 1               |                            | I2C Lines
|  scl_in                  | In     | 1               |                            |
|  sda_out                 | Out    | 1               |                            |
|  sda_in                  | In     | 1               |                            |
|                          |        |                 |                            |
|  vs                      | In     | 1               |                            | Video hardware lines from camera
|  hs                      | In     | 1               |                            |
|  pclk                    | In     | 1               |                            |
|  d                       | In     | CameraPixelWidth|                            |
|  rst                     | Out    | 1               |                            | Hardware reset control line
|  pwdn                    | Out    | 1               |                            | Shut the camera down
|  led                     | In     | 1               |                            | Flash control - exposure indicator
|  trigger                 | In     | 1               |                            | Trigger exposure then data output for snapshot mode

### External Requirements

For the camera clock, one solution is to divide the 48MHz system clock

``` verilog
	reg [2:0] clock_divided;

	always @( posedge clock_48mhz ) begin
		if ( reset )
			clock_divided <= 0;
		else
			clock_divided <= clock_divided + 1;
	end

	assign xclk = clock_divided[ 0 ];
```

For the I2C, use the ECP5 primitives

``` verilog
    // Tristate Ports - Clock is pure output, data needs to be bidirectional (Open Drain)
	// T : Tristate, not Transmit!
	BB  clock_io( .I( camera_scl_out ), .T( 0 ), .O( scl ), .B( genio[18] ) );
	BB   data_io( .I( 0 ), .T( camera_sda_out), .O( sda ), .B( genio[19] ) );
```

### Pixel Data

Simultaneous Master Mode - Continuous frames, exposure happens during the previous frame.  Exposure is indicated
by LED_Out.  Makes sense.

```
                _...__________
    LED_Out   _/              \____________________________________________..._____________________________
              ___...___        ____________________________________________..._________________________
    Frame              \______/                                                                        \___
                                          _________         ________                _________
    Line      ___...___|______|__________/         \_______/        \______..._____/         \________|____
                       |      |          |         |       |        |              |         |        |
               P2      |  V   |    P1    |    A    |   Q   |   A    |   Q       Q  |    A    |   P2   |
```

Frame Blanking in this mode may be extended when the exposure time is longer than the frame time

Snapshot Mode - Exposure is triggered, when complete the frame is sent

```
                 _
    Exposure  __/ \__..._________________________________________________..._______________________________
                   __...___
    LED_Out   ____/        \_____________________________________________..._______________________________
                             ____________________________________________...__________________________
    Frame     _______...____/                                                                         \____
                                        _________         ________                _________
    Line      _______...____|__________/         \_______/        \______..._____/         \________|______
                            |          |         |       |        |              |         |        |
                            |    P1    |    A    |   Q   |   A    |   Q       Q  |    A    |   P2   |
```
```
    V     = Vertical Blanking     = R06
    P1    = Frame Start Blanking  = R05 - 23
    A     = Active Data Time      = R04
    Q     = Horizontal Blanking   = R05
    P2    = Frame End Blanking    = 23 (fixed)

    R     = Rows

    A + Q = Row Time

    F     = Total Frame Time = V + R x ( A + Q )
```


### Hardware Connection

The Arducam module used here has the following pinout

|Pin No.|PIN NAME  | TYPE   |DESCRIPTION|
| - | -            | -      | - |
| 1 | VCC          | POWER  | 3.3v Power supply |
| 2 | GND          | Ground | Power ground |
| 3 | SCL          | Input  | Two-Wire Serial Interface Clock |
| 4 | SDA(SDATA)   | Bi-directional | Two-Wire Serial Interface Data I/O |
| 5 | VS(VSYNC)    | Output | Active High: Frame Valid; indicates active frame |
| 6 | HS(HREF)     | Output | Active High: Line/Data Valid; indicates active pixels |
| 7 | PCLK         | Output | Pixel Clock output from sensor |
| 8 | XCLK         | Input  | Master Clock into Sensor (13MHz - 27MHz) |
| 9 | D9           | Output | Pixel Data Output 9(MSB) |
| 10| D8           | Output | Pixel Data Output 7(MSB) |
| 11| D7           | Output | Pixel Data Output 7(MSB) |
| 12| D6           | Output | Pixel Data Output 6      |
| 13| D5           | Output | Pixel Data Output 5      |
| 14| D4           | Output | Pixel Data Output 4      |
| 15| D3           | Output | Pixel Data Output 3      |
| 16| D2           | Output | Pixel Data Output 2      |
| 17| D1           | Output | Pixel Data Output 1      |
| 18| D0           | Output | Pixel Data Output 0 (LSB)|
| 19| RST          | Input  | Sensor Reset |
| 20| PDN(PWDN)    | Input  | Power Down |
| 21| Trigger(EXP) | Input | External trigger Input |
| 22| LED          | Output | LED Control, Exposure indicator |

### Invocation


### Testing

The module is tested in the project `camera_ic` by connecting to a peer module `camera_proxy` which incorporates an i2c_slave module and can present as a partial standin for a real camera in simulation.

``` verilog
    camera_proxy #(
            .Width( CameraWidth ),
            .Height( CameraHeight )
        ) cam_proxy (
            .clock( clock ),
            .reset( reset ),

            .scl_in( scl ),
            .scl_out( camera_proxy_scl_out ),
            .sda_in( sda ),
            .sda_out( camera_proxy_sda_out ),

            .vs( vs ),
            .hs( hs ),
            .pclk( pclk ),
            .xclk( xclk ),
            .d( d ),

            .rst( rst ),
            .pwdn( pwdn ),

            .led( led ),
            .trigger( trigger )
        );
```

When the test bed is run, the simulated camera (`camera_proxy`) gets configured, then sends appropriate data.
