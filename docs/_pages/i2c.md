---
layout: single_tech
title: "Pipelined I2C"
permalink : /i2c
toc: true
toc_label: Contents
toc_sticky: true
wavedrom : 1
# threejs: 1
header:
  title: "Pipelined I2C"
  overlay_image: /assets/images/spokefpga_banner_thin.png
---

## Overview

Pipelined I2C code

<div id="i2c_system_diagram"></div>

<script type="text/javascript">

    const i2c_system_diagram = {
        id: "",
        color:"#555",
        children: [
                {
                    id: "",
                    color:"#CCC",
                    children: [
                        {
                            id: "DeviceM",
                            label: "Device",
                            type: "I2C Master",
                            westPorts: [
                                "scl",
                                "sda",
                            ]
                        },
                        {
                            id: "FPGAA",
                            label: "FPGA",
                            eastPorts: [
                                "scl",
                                "sda"
                            ],
                            children: [
                                {
                                    id: "AppA",
                                    eastPorts: [
                                        "pipe_out",
                                        "pipe_in"
                                    ]
                                },
                                {
                                    highlight:1,
                                    id: "I2CM",
                                    label: "I2C Master",
                                    westPorts: [
                                        "pipe_in",
                                        "pipe_out"
                                    ],
                                    eastPorts: [
                                        "sda",
                                        "scl"
                                    ]
                                },
                            ],
                            edges: [
                                ["AppA.pipe_out","I2CM.pipe_in",1],
                                ["I2CM.pipe_out","AppA.pipe_in",-1,1],
                                ["I2CM.scl","FPGAA.scl"],
                                ["I2CM.sda","FPGAA.sda"],
                                ["FPGAA.scl","I2CM.scl"],
                                ["FPGAA.sda","I2CM.sda"]
                            ]
                        },
                        {
                            id: "DeviceS",
                            label: "Device",
                            type: "I2C Slave",
                            westPorts: [
                                "scl",
                                "sda",
                            ]
                        },
                        {
                            id: "FPGAB",
                            label: "FPGA",
                            westPorts: [
                                "scl",
                                "sda"
                            ],
                            children: [
                                {
                                    id: "AppB",
                                    westPorts: [
                                        "pipe_in",
                                        "pipe_out"
                                    ]
                                },
                                {
                                    highlight:1,
                                    id: "I2CS",
                                    label: "I2C Slave",
                                    parameters: [
                                      "Address"
                                    ],
                                    westPorts: [
                                        "scl",
                                        "sda"
                                    ],
                                    eastPorts: [
                                        "pipe_out",
                                        "pipe_in"
                                    ]
                                }
                            ],
                            edges: [
                                ["AppB.pipe_out","I2CS.pipe_in",-1,1],
                                ["I2CS.pipe_out","AppB.pipe_in",1,1],
                                ["I2CS.scl","FPGAB.scl",-1],
                                ["I2CS.sda","FPGAB.sda",-1],
                                ["FPGAB.scl","I2CS.scl"],
                                ["FPGAB.sda","I2CS.sda"]
                            ]
                        }

                    ],
                    edges: [
                        ["DeviceM.scl","FPGAA.scl", -1],
                        ["DeviceM.sda","FPGAA.sda",-1],
                        ["FPGAA.scl","DeviceM.scl"],
                        ["FPGAA.sda","DeviceM.sda"],
                        ["DeviceS.scl","FPGAA.scl", -1],
                        ["DeviceS.sda","FPGAA.sda",-1],
                        ["FPGAA.scl","DeviceS.scl"],
                        ["FPGAA.sda","DeviceS.sda"],
                        ["FPGAB.scl","FPGAA.scl", -1],
                        ["FPGAB.sda","FPGAA.sda",-1],
                        ["FPGAA.scl","FPGAB.scl"],
                        ["FPGAA.sda","FPGAB.sda"]
                    ]
            } ]
        }

    hdelk.layout( i2c_system_diagram, "i2c_system_diagram" );
</script>


## Modules

### I2C Master

<div id="i2c_master"></div>

<script type="text/javascript">

    const i2c_master_diagram = {
        id: "",
        children: [
            {
                highlight:1,
                id: "i2c_master",
                parameters: [
                    "PipeSpec",
                    "ClockCount"
                ],
                northPorts: [
                    "clock",
                    "reset"
                ],
                westPorts: [
                    "slave_address",
                    "read_count",
                    "operation",
                    "send_address",
                    "send_operation",
                    "send_write_count",
                    "read_start",
                    "pipe_in",
                    "pipe_out"
                ],
                eastPorts: [
                    "SCL",
                    "SDA",
                    "complete",
                    "error",
                    "write_count"
                ]
            },
        ],
        edges: [
        ]
    }

    hdelk.layout( i2c_master_diagram, "i2c_master" );
</script>

#### Parameters

| Name         | Description |
| -            | -           |
| `Address`    | Address for the Slave. |
| `PipeSpec`   | specification of the data coming in and out of the module. |
| `ClockCount` | Number of clock ticks for each bit (@ 48MHz for 400kbps, count is 48M/400K = 120 ) |

#### Ports

| Name            | Direction | Size | Description |
| -               | -         | -    | -           |
| `clock`         | In | 1 | System clock |
| `reset`         | In | 1 | System reset |
| `slave_address` | In | n | Slave Address , -1 if in-pipe instead |
| `read_count`    | In | n+1 | Words to read, -1 if in-pipe |
| `operation`     | In | 1 | Operation, 0 write, 1 read, 2 write-read, -1 specified in pipe |
| `send_address`  | In | 1 | send address as part of the return message |
| `send_operation`| In | 1 | send operation as part of the return message |
| `send_write_count`| In | 1 | send write count as part of the return message |
| `read_start`    | In | 1 | Start operation |
| `complete`      | Out | 1 | Operation complete |
| `error`         | Out | 1 | Operation failed |
| `write_count`   | Out | n | Words written |
| `pipe_in`       | InOut | p | Pipeline of messages to be sent |
| `pipe_out`      | InOut | p | Pipeline of messages received |
| `scl`           | InOut | 1 | Communication clock clock out.  Open Drain Output |
| `sda`           | InOut | 1 |  Communication data in and out.  Open Drain Output |

#### Dependencies

| Subsystem | File          |
| -         | -             |
| Pipe      | pipe_defs.v   |
|           | pipe_utils.v  |

#### Template

``` verilog

i2c_master #(
        .PipeSpec( PipeSpec ),
        .ClockCount( ClockCount )

    ) i2c_m(
        .clock( clock ),
        .reset( reset ),

        .pipe_in( pipe_in ),
        .pipe_out( pipe_out ),

        .scl( scl ),
        .sda( sda )
    );
```

### I2C Slave

<div id="i2c_slave"></div>

<script type="text/javascript">

    const i2c_slave_diagram = {
        id: "",
        children: [
            {
                id: "i2c_slave",
                highlight: 1,
                parameters: [
                    "Address",
                    "PipeSpec",
                    "ClockCount"
                ],
                northPorts: [
                    "clock",
                    "reset"
                ],
                westPorts: [
                    "SCL",
                    "SDA"
                ],
                eastPorts: [
                    "pipe_in",
                    "pipe_out"
                ],
            },
        ],
        edges: [
        ]
    }

    hdelk.layout( i2c_slave_diagram, "i2c_slave" );
</script>

#### Parameters

| Name    | Description |
| -       | -           |
| `Address` | Slave Address. |
| `PipeSpec` | specification of the data coming in and out of the module. |
| `ClockCount` | clock ticks per bit |

#### Ports

| Name | Direction | Size | Description |
| -      | -         | -    | -           |
| `clock` | In | 1 | System clock |
| `reset` | In | 1 | System reset |
| `pipe_in` | InOut | p | Pipeline of messages to be sent |
| `pipe_out` | InOut | p | Pipeline of messages received |
| `scl` | In | 1 | Communication clock in |
| `sda` | In | n |  Communication data in |

#### Dependencies

Pipe
- pipe_defs.v
- pipe_utils.v

#### Template


## Waveforms

<script type="WaveDrom">
{
  signal: [
        { name: 'SYS CLK',  wave: 'p..........|..............'},
            {name: 'SCL',   wave: '1...0.1.0.1|0.1.0.1.0.1...'},
            {name: 'SDA',   wave: '1.0..=...=.|.=...4...0..1.', data: "D7  D0 ACK"}
    ],
    config:{skin:"lowkey"},
  foot:{ tick:0,text:'I2C Signals' }
}
</script>


<script type="WaveDrom">{
    signal: [
        { name: 'SYS CLK',  wave: 'p........................................'},
      [ "Write",
        {name: 'SCL',       wave: '1.0101010101010.1010101010.10101010101...'},
        {name: 'SDA',       wave: '10=.=.=.=.=.4..=.=.=.=.4..=.=.=.=.=.4.01.', data: "A6 A5 ... A0 R/W=0 ACK D0.7 D0.6 ... D0.0 ACK ... Dn.7 Dn.6 ... Dn.0 ACK"} ],
      [ "Read",
        {name: 'SCL',       wave: '1.0101010101010.1010101010.10101010101...'},
        {name: 'SDA',       wave: '10=.=.=.=.=.4..4.4.=.4.=..=.4.4.=.4.=.01.', data: "A6 A5 ... A0 R/W=0 ACK D0.7 D0.6 ... D0.0 ACK ... Dn.7 Dn.6 ... Dn.0 ACK"} ],
    ],
    config:{skin:"lowkey"},
  foot:{ tick:0,text:'I2C Signals' }
}
</script>

## Tasks

More doc

Timeouts for clock stretching (else?)

Write-Read mode

More hardware testing


## Discussions

### How to handle Read length in a pipeline environment?

Same as SPI with header or input options for read/write read count

```
  ADDRESS
  READ COUNT n = 0
  WRITE DATA 0
  ...
  WRITE DATA m
```
```
  ADDRESS
  READ COUNT n =/= 0
```
### Should address be added to the return?

Yes, optionally.

### How to handle status (timeout, error, too long)

