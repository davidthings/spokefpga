---
layout: single_tech
title: "Pipelines"
permalink : /pipelines
toc: true
toc_label: Contents
toc_sticky: true
wavedrom : 1
# threejs: 1
header:
  title: Pipelines
  overlay_image: /assets/images/spokefpga_banner_thin.png
---

## Introduction

The purpose of this document is to motivate and describe a proposal that might promote more reuse in the world of small FPGA IP design. The target audience will be people who are familiar with Verilog, and who are interested in developing ways to better connect IP.

In a sense what follows is all rather known or obvious, and there is little new innovation presented, but that really underscores how strange it is that we don't have a huge range of compatible libraries of functionality to play with as FPGA engineers. 

An [Overview](#overview) of the problem is outlined initially, followed by a [Motivation](#motivation) section with a few "wouldn't it be nice" examples. The [Design](#design) section goes through the creation of a systematic pipeline and finally, in [Implementation](#implementation) there are some proposals for how pipleines might be implemented.

## Overview

The first thing that strikes new FPGA engineers is *where the heck are all the code libraries?* There are a few places, like [FuseSoC Cores](https://github.com/fusesoc/fusesoc-cores), [OpenCores](https://opencores.org/), [OH](https://github.com/parallella/oh) but there is nothing like the thousands of libraries available to software developers using Python, Javascript, C, C++, or indeed almost any modern programming language.  Considering that Verilog is *decades* older than some of these incredibly well stocked languages, the mystery deepens.

What are some of the causes of the lack of rich compatible, composable, libraries?

- lack of interface standards (eg. even ready/valid connections have different names and different semantics)
- vendor lock-in - intentional or incidental.  Libraries provided for use with a particular platform may use platform specific features, making them locked to that particular architecture and often via license unsharable.
- varying provison of and need for fullness of design makes a module look less appealling (a complete module may feel too heavy to someone looking for a minimal implementation, and vice versa)
- company libraries don't destinquish proprietary code from code that could potentially be shared, and so it becomes hard to extact code for sharing.
- lack of a open library tradition.  When engineers don't have a practice of grabbing code from GitHub or similar, it doesn't occur to them to contribute it back.
- lack of a connecting component tradition.   Designs don't seem to emphasize generic interconnection as a priority.
- ASIC designers may have a "one and done" orientation.  Designs are very focussed on a single target product, not sharable libraries, and when a design has sucessfully made it into silicon there is very little incentive to reuse that IP other than within the same team.
- the HDL world is split into Verilog and VHDL meaning that much code is "in the wrong language"
- the very low level HDL operates at means implementation strategies can vary widely, being appealing to some and not to others.  
- sometimes the code is designed to be put on a processor bus, sometimes not.
- comprehensive interfaces are long winded.  It is frustrating to wire everything up laboriously.  Verilog is especially bad since there are no structures in that language.
- one especially vexing situation is when high quality layers are built on top of HDL, for example **System Verilog** and **MiGen**, but this further fragments things!  Incredible libraries exist for these other languages, but of course you have to be using them to use the libraries.  And worse, in some cases you can't use basic Verilog/VHDL modules either!

The effect of all this is that new FPGA engineers tend to avoid low level coding all together, the mode of programming FPGAs becomes more and more connecting cores to a bus and connecting directly or indirectly to a processor and writing C code for it.  This is sad, since some of the excitement of incredibly fast interconnected FPGA IP is lost through relatively slow code execution and increased FPGA system complexity.  It also means that there is pressure to use bigger and bigger FPGA's, since larger LUT counts mean more efficient soft CPUs (more pipelining) and larger code space.  Larger FPGAs are more expensive, boards they sit on are harder to design and more expensive, and larger images are slower to build.

New FPGA developers get some idea of how things work by programming a blinking LED (without library help!), but almost immediately the next step is soft CPU, IP with Wishbone interfaces, C compilers and C code.  

Another effect of a lack of library behavior is that even companies providing FPGA add-on hardware often don't provide low level HDL to use the devices, preferring instead offer nothing at all or generic bus interfaces.

**Pipelines** are a convention that aims to make connecting Verilog modules easier and promoting re-use.  They do this by formalizing how modules connect together by building on well known Ready/Valid signals, and then offering a shorthand to make this easier.

## Motivation

Pretending for a minute that the above problems did not exist, and that we had a decade or more of compatible IP library development, what would it be reasonable to expect to be able to do?  Dreaming a little...

### USB Echo

A simple character echo would have been so reassuring for a first timer.  

<div id="host_echo"></div>

<script type="text/javascript">

    var graph = {
        color: "#555",
        children: [
            { id: "HOST", outPorts: ["usb"],
                children: [
                    { id: "term", label: "Serial Terminal"  }
                ],
                edges: [
                    ["term", "HOST.usb"]
                ]
             },
            { id: "FPGA", inPorts: [ "usb"],
                children: [
                    { id: "usb_s", label:"USB CDC", inPorts: ["usb"], outPorts:[ "in", "out" ]  }
                ],
                edges: [
                    ["FPGA.usb","usb_s.usb" ],
                    { route:["usb_s.in","usb_s.out" ], highlight:4}
                ] }
        ],
        edges: [
            [ "HOST.usb","FPGA.usb" ]
        ]
    }

    hdelk.layout( graph, "host_echo" );
</script>

The `USB CDC` module is generic and reusable.  Note how thinking about it as a pipeline component and not a bus slave means interesting things can be done with it directly.  In this case just connecting `out` to `in`.


### Function Tester

While first learning, wouldn't it have been great to be able to write a math module and then test it in real hardware with a terminal program?  

<div id="hello_function_tester"></div>

<script type="text/javascript">

    var graph = {
        color: "#555",
        children: [
            { id: "HOST", outPorts: ["usb"],
                children: [
                    { id: "term", label: "Serial Terminal", type: "10,20"  }
                ],
                edges: [
                    ["term", "HOST.usb"]
                ]
             },
            { id: "FPGA", inPorts: [ "usb"],
                children: [
                    { id: "usb_s", label:"USB CDC", inPorts: ["usb"], outPorts:[ "in", "out" ]  },
                    { id: "param1", type:"remove int string", inPorts: ["in"], outPorts:[ "out" ], southPorts:["int"]  },
                    { id: "param2", type:"remove int string", inPorts: ["in"], outPorts:[ "out" ], southPorts:["int"]  },
                    { id: "f", label:"f(a,b)->c", inPorts:["a", "b" ], outPorts:["c"], highlight:4  },
                    { id: "return", type:"add int string", inPorts: ["in"], northPorts:["int"], outPorts:[ "out" ]  },
                    { id: "unique", inPorts: ["in"], outPorts:[ "out" ]  }
                ],
                edges: [
                    ["usb_s.out","param1.in" ],
                    ["param1.out","param2.in" ], 
                    ["param1.int","f.a" ], 
                    ["param2.int","f.b" ], 
                    ["f.c","return.int" ], 
                    ["return.out","unique.in" ], 
                    ["unique.out","usb_s.in" ], 
                    ["FPGA.usb","usb_s.usb" ]
                ] }
        ],
        edges: [
            [ "HOST.usb","FPGA.usb" ]
        ]
    }

    hdelk.layout( graph, "hello_function_tester" );
</script>

The `USB CDC` module is being reused.  It is not too far fetched to think of `remove int string` and `add int string` as general purpose reusable functions.  They would be customizable - with definable (via parameter) delimiters, etc.  `unique` would clearly have many uses.

The only code that would need to be written is the new code in the function module.

The handshaking on all the modules has small overhead and permits them to all govern their own execution.

### Host Communication

It would have been nice to be able to run some message passing code on the host, and have real delimited packets be available for local code.  Also, ideally if local code created packets, something to process them and get them back to the host, that would have been great, too.

<div id="host_communication"></div>

<script type="text/javascript">

    var graph = {
        color: "#555",
        children: [
            { id: "HOST", outPorts: ["usb"],
                children: [
                    { id: "Lib", label:"Comms Lib"  },
                    { id: "App", highlight:4 }
                ],
                edges: [
                    ["App","Lib"],
                    ["Lib", "HOST.usb"]
                ]
             },
            { id: "FPGA", inPorts: [ "usb"],
                children: [
                    { id: "usb_s", label:"usb serial", inPorts: ["usb"], outPorts:[ "in", "out" ]  },
                    { id: "escape", eastPorts: ["in"], westPorts:[ "out" ]  },
                    { id: "unescape", inPorts: ["in"], outPorts:[ "out" ]  },
                    { id: "Internals", type:"Verilog", westPorts:["in", "out" ], highlight:4  }
                ],
                edges: [
                    ["FPGA.usb","usb_s.usb" ],
                    ["Internals.out","escape.in"], 
                    ["escape.out","usb_s.in"], 
                    ["usb_s.out","unescape.in"], 
                    ["unescape.out","Internals.in"]
                ] }
        ],
        edges: [
            [ "HOST.usb","FPGA.usb" ]
        ]
    }

    hdelk.layout( graph, "host_communication" );
</script>

`escape` would turn the pipelines' `start` and `stop` packet delimiting signals into escape sequences, and `unescape` would do the opposite.  This would make sending messages over an 8bit line more convenient.

Again, the only code that would need to be written in this case is the highlighted code : the app code on the host and the Verilog internal code on the FPGA. 

Let's use the following shorthand for this kind of host communication:

<div id="host_template"></div>

<script type="text/javascript">

    var graph = {
        color: "#555",
        children: [
            { id: "FPGA",
                children: [
                    { id: "to_host", label:"to host", port:1 },
                    { id: "from_host", label:"from host", port:1 },
                    { id: "Internals", type:"Verilog", inPorts:["in"], outPorts:[ "out" ], highlight:4  }
                ],
                edges: [
                    ["Internals.out","to_host"], 
                    ["from_host","Internals.in"]
                ] 
            }
        ]
    }

    hdelk.layout( graph, "host_template" );
</script>

The `to Host` and `from Host` ports will be assumed to take and provide messages from the host code.

### FPGA Comms

FPGA pins can trivially toggle at hundreds of metahetz, so why aren't there off-the-shelf, architecture independent modules to create fast, reliable message communication? 

<div id="fpga_comms"></div>

<script type="text/javascript">

    var graph = {
        color: "#555",
        children: [
            { id: "FPGA1",
                eastPorts:[ "link" ],
                children: [
                    //{ id: "to_host", label:"to Host", port:1 },
                    //{ id: "from_host", label:"from Host", port:1 },
                    { id:"c1", label: "comms", inPorts:["in","out"], outPorts:["link"]},
                    { id: "i1", label:"Internals", type:"Verilog", ports:[ "in","out" ], highlight:4  }
                ],
                edges: [
                    //["i1.out","to_host"], 
                    //["from_host","i1.in"],
                    ["i1.out","c1.in"],
                    ["c1.out","i1.in"],
                    ["c1.link","FPGA1.link"]
                ] 
            },
            { id: "FPGA2",
                westPorts:[ "link" ],
                children: [
                    { id:"c2", label: "comms", ports:["out","in"], westPorts:["link"]},
                    { id:"i2", label:"Internals", type:"Verilog", ports:[ "in","out" ], highlight:4  }
                ],
                edges: [
                    ["i2.out","c2.in"],
                    ["c2.out","i2.in"],
                    ["FPGA2.link","c2.link"]
                ] 
            }
        ],
        edges:[
            ["FPGA1.link","FPGA2.link"]
        ]
    }

    hdelk.layout( graph, "fpga_comms" );
</script>

The `comms` module would create a bi-directional, reliable link and would transparently deliver messages from one FPGA to another.

### Networking

A small extension to the `comms` module would allow a ring network to be created between nodes.  Distributed applications could be built with these tools.

<div id="networking_idea"></div>

<script type="text/javascript">

    var graph = {
        color: "#555",
        children: [
            { id: "FPGA1",
                westPorts:[ "net_in" ],
                eastPorts:[ "net_out" ],
                children: [
                    { id: "to_host", label:"to host", port:1 },
                    { id: "from_host", label:"from host", port:1 },
                    { id: "n1", label: "network", northPorts:["in","out"], ports:["net_in","net_out"]},
                    { id: "i1", label:"Internals", type:"Verilog", ports:[ "h_in","h_out"], southPorts:[ "in","out" ], highlight:4  }
                ],
                edges: [
                    ["i1.h_out","to_host"], 
                    ["from_host","i1.h_in"],
                    ["i1.out","n1.in"],
                    ["n1.out","i1.in"],
                    ["FPGA1.net_in","n1.net_in"],
                    ["n1.net_out","FPGA1.net_out"]
                ] 
            },
            { id: "FPGA2",
                westPorts:[ "net_in" ],
                eastPorts:[ "net_out" ],
                children: [
                    { id:"n2", label: "network", southPorts:["out","in"], westPorts:["net_in"], eastPorts:["net_out"]},
                    { id:"i2", label:"Internals", type:"Verilog", northPorts:[ "in","out" ], highlight:4  }
                ],
                edges: [
                    ["i2.out","n2.in"],
                    ["n2.out","i2.in"],
                    ["FPGA2.net_in","n2.net_in"],
                    ["n2.net_out","FPGA2.net_out"]
                ] 
            },
            { id: "FPGA3",
                westPorts:[ "net_in" ],
                eastPorts:[ "net_out" ],
                children: [
                    { id:"n3", label: "network", southPorts:["out","in"], westPorts:["net_in"], eastPorts:["net_out"]},
                    { id:"i3", label:"Internals", type:"Verilog", northPorts:[ "in","out" ], highlight:4  }
                ],
                edges: [
                    ["i3.out","n3.in"],
                    ["n3.out","i3.in"],
                    ["FPGA3.net_in","n3.net_in"],
                    ["n3.net_out","FPGA3.net_out"]
                ] 
            }

        ],
        edges:[
            ["FPGA1.net_out","FPGA2.net_in"],
            ["FPGA2.net_out","FPGA3.net_in"],
            ["FPGA3.net_out","FPGA1.net_in"]
        ]
    }

    hdelk.layout( graph, "networking_idea" );
</script>

### SPI Interface

There are so many incredible SPI chips.  Wouldn't it have been great if it were possible to experiment with these devices from a host?

<div id="spi_interface"></div>

<script type="text/javascript">

    var graph = {
        color: "#555",
        children: [
            { id: "HOST", outPorts: ["usb"],
                children: [
                    { id: "Lib", label:"Comms Lib"  },
                    { id: "App", highlight:4  }
                ],
                edges: [
                    ["App","Lib"],
                    ["Lib", "HOST.usb"]
                ]
             },
            { id: "FPGA", westPorts: [ "usb"], eastPorts:[ "spi" ],
                children: [
                    { id: "usb_m", label:"usb msg", inPorts: ["usb"], outPorts:[ "in", "out" ]  },
                    { id: "spi", label:"spi master", westPorts:["out", "in" ], eastPorts:["spi"]  }
                ],
                edges: [
                    ["FPGA.usb","usb_m.usb" ],
                    ["spi.out","usb_m.in"], 
                    ["usb_m.out","spi.in"], 
                    ["spi.spi","FPGA.spi"]
                ] },
            { id: "s", label:"SPI Device", inPorts: [ "spi" ] }
        ],
        edges: [
            [ "HOST.usb","FPGA.usb" ],
            [ "FPGA.spi","s.spi" ]
        ]
    }

    hdelk.layout( graph, "spi_interface" );
</script>

The `spi master` accepts messages and puts their content out to the SPI bus.  Received data is returned.

### SPI Devices 

Could we go further?  Take an IMU as an example - wouldn't it have been great if it were possible to wrap the `spi master` module with code that handles the IMU's initialization and interface requirements and then just get IMU data out of it?

<div id="spi_imu"></div>

<script type="text/javascript">

    var graph = {
        color: "#555",
        children: [
            { id: "FPGA", eastPorts:[ "spi" ],
                children: [
                    { id:"i", label:"Internals", type:"Verilog", southPorts:[ "accel","rot","mag" ], highlight:4  },
                    { id: "imu", label:"imu spi", northPorts:["accel","rot","mag" ], eastPorts:["spi"]  }
                ],
                edges: [
                    ["imu.accel","i.accel"], 
                    ["imu.rot","i.rot"], 
                    ["imu.mag","i.mag"], 
                    ["imu.spi","FPGA.spi"]
                ] },
            { id: "i", label:"IMU Device", inPorts: [ "spi" ] }
        ],
        edges: [
            [ "FPGA.spi","i.spi" ]
        ]
    }

    hdelk.layout( graph, "spi_imu" );
</script>

Of course there would need to be a some configuration, etc. but this module should exist - one for each type of IMU.

ADC's in general are another kind of SPI-based device that would be incredible to have code libraries available for.  The list of the devices is long.

Another good point to be emphazed here is that the pipeline code needs to be in pure Verilog, because it needs to be possible to *wrap* pipeline modules in code to create new pipeline modules.  In the above example, there would be an SPI Master pipeline module *inside* the `imu spi` module, doing all the SPI master stuff.  The code around it would handle initialization, and getting data in and out of the device.

### Other Ideas

Of course there are thousands of other applications like this.

- PID Controller
- PWM generator
- I2C Master
- GPIO
- Display Controller

The foregoing have been heavily biased towards interfacing and communicating but there are many internal functions that could benefit from the Pipeline approach.  For example,

- multiplication, division, CORDIC functions, filtering, etc.
- memory - fifo's, caches, etc
- parsing and generating structured messages

Things that are often specific to a particular FPGA family could be wrapped up providing a way to isolate libraries needing to know these details.  For example,

- LVDS IO
- Clock PLLs
- FPGA internals

Finally various *combinations* of pipeline components could be put together to make even more interesting functionality.  The new modules so formed would themselves be pipeline modules, reusable, and with all the other desirable pipeline characteristics. 

The hope in providing so many examples is to build the case for a Pipelining approach.  But is it even feasible and convenient to express these ideas in FPGAs?  Let's now turn to how we might do that.

## Design

How to design a flexible pipelining system?  If you're intimately familiar with **Valid-Ready** interfaces you might like to skip ahead to the [Start + Stop](#start--stop) section.

### Data 

When one module needs to speak to another there is one thing that must be shared, the data, what ever that is.  We'll call the data sender the **Producer** and the receiver the **Consumer** 

<div id="pipe_data"></div>

<script type="text/javascript">

    var graph = {
        children: [
            { id: "p1", type:"Producer", outPorts: ["out_data"] },
            { id: "p2", type:"Consumer", inPorts: [ "in_data"] }
        ],
        edges: [
            { route:["p1.out_data","p2.in_data"], label:"n-bits", bus:1 }
        ]
    }

    hdelk.layout( graph, "pipe_data" );
</script>

The edge is thick, because the data is mostly more than one bit wide. We can also use the edge label to describe how big the data field is if necessary

But when is this data actually available?

<script type="WaveDrom">
{ signal: [
   { name: 'clock', wave: 'p..........'},
   { name: 'p1.out_data',  wave: 'x.2x2x.2x..', data:'d1 d2 d3'}
  ], config:{skin:"lowkey"} }
</script>

After a reset it might take a while for data to be valid, more might turn up, but then there may nothing for a while, then more data could become available, etc.  Think about a UART, for example.  Every now and again a character just appears! 

### Valid

The accepted solution to this problem is to provide a signal alongside the data, often called `valid`

<div id="pipe_data_valid"></div>

<script type="text/javascript">

    var graph = {
        children: [
            { id: "p1", type:"Producer", outPorts: ["out_data", "out_valid"] },
            { id: "p2", type:"Consumer", inPorts: [ "in_data", "in_valid"] }
        ],
        edges: [
            { route:["p1.out_data","p2.in_data"], bus:1 },
            ["p1.out_valid","p2.in_valid"]
        ]
    }

    hdelk.layout( graph, "pipe_data_valid" );
</script>

`valid` is raised when the data being provided by the Producer is valid.

<script type="WaveDrom">
{ signal: [
   { name: 'clock', wave: 'p..........'},
   { name: 'p1.out_data',  wave: 'x.2x2x.2x..', data:'d1 d2 d3'},
   { name: 'p1.out_valid', wave: '0.1010.10..' }
  ], config:{skin:"lowkey"} }
</script>

This is great.  Now a Consumer can tell when another valid data item is available.

### Ready

However, there is another problem here.  What if the Consumer is not ready?  It may take a little bit after a reset to be receptive to data.  Some data may cause it to pause for a little while, etc.  To solve this problem we add the Consumer provided signal, `ready`.

<div id="pipe_data_valid_ready"></div>

<script type="text/javascript">

    var graph = {
        children: [
            { id: "p1", type:"Producer", outPorts: ["out_data", "out_valid", "out_ready"] },
            { id: "p2", type:"Consumer", inPorts: [ "in_data", "in_valid", "in_ready"] }
        ],
        edges: [
            { route:["p1.out_data","p2.in_data"], bus:1 },
            ["p1.out_valid","p2.in_valid"],
            ["p2.in_ready","p1.out_ready"] 
        ]
    }

    hdelk.layout( graph, "pipe_data_valid_ready" );
</script>

The 'ready' signal is raised when the Consumer is ready to receive data.  `Ready` and `Valid` together form a **handshake**.

<script type="WaveDrom">
{ signal: [
   { name: 'clock', wave: 'p..........'},
   { name: 'p1.out_data',  wave: 'x.2x2x.4..x', data:'d1 d2 d3'},
   { name: 'p1.out_valid', wave: '0.1010.1..0' },
   { name: 'p2.in_ready', wave: '01....0..1.' }
  ], 
  head:{ tock:1 },
  config:{skin:"lowkey"} }
</script>

This is an improvement, however, the transfer situation just got a lot more complex.  `d1` and `d2` look reasonable, but look at what happens to `d3`.  The Consumer is *not* ready when the Producer is, so *the Producer has to hang onto its data until the Consumer is ready*.  When the Consumer finally is ready, the Producer may release the data.

This gives rise to the common observation that with a valid-ready system, *data is only transfered when both ready and valid signals are true*.  In the example above at times 3,5 and 10.

Codewise, if you're a producer and you have data, you'll be in a producer-valid kind of state until you see a `ready` from the consumer.  In Verilog, this might look like the following:

``` verilog
...
    case ( state )
        ...
        STATE_DATA_VALID:
            // out_data is set up
            // out_valid is high
            if ( out_ready ) begin
                state <= STATE_DO_THE_NEXT_THING;
                out_valid <= 0;
            end
...
```

On the consumer side, when you're in a consumer-ready sort of state, you'll sit and wait until you get a `valid` from the producer. In Veriog this might look like this:

``` verilog
...
    case ( state )
        ...
        STATE_READY_TO_RECEIVE:
            // in_ready is high
            if ( in_valid ) begin
                internal_data <= in_data
                state <= STATE_DO_THE_NEXT_THING;
                in_ready <= 0;
            end
...
```

One of the great things about the Ready-Valid connection is that if both `ready` and `valid` are held high, transfers occur *every clock cycle*.  To someone used to laboriously reading or toggling data from one place to another, this is pretty exciting.  

<script type="WaveDrom">
{ signal: [
   { name: 'clock', wave: 'p..........'},
   { name: 'data',  wave: 'x.2222222x.', data:'d1 d2 d3 d4 d5 d6 d7'},
   { name: 'valid', wave: '0.1......0.' },
   { name: 'ready', wave: '01.........' }
  ], 
  config:{skin:"lowkey"} }
</script>

Good Pipeline modules ought to be able to do this whenever possible, but it does make things even more complex.  Modules supporting this kind of fast transfer have to take into account data appearing at every clock cycle, and have to be careful about getting in and out of the "one transfer every cycle" mode.  See the [Appendix](#appendix--fast-pipeline-programming) for more of the darkness that awaits a pipeline module in the middle programmer.

The details of a full pipeline module require their own article.  So for an excellent overview of handshaking in general see the excellent ZipCPU article ["Strategies for Pipelining"](https://zipcpu.com/blog/2017/08/14/strategies-for-pipelining.html)

### Start + Stop

Very often sequential data items in a pipeline are parts of multiword **Packets** (also known as **Frames**).  In order to delineate these we add appropriate signals to the pipeline.

<div id="pipe_packets"></div>

<script type="text/javascript">

    var graph = {
        children: [
            { id: "p1", type:"Producer", outPorts: ["out_start", "out_stop", "out_data", "out_valid", "out_ready"] },
            { id: "p2", type:"Consumer", inPorts: [ "in_start", "in_stop", "in_data", "in_valid", "in_ready"] }
        ],
        edges: [
            ["p1.out_start","p2.in_start"],
            ["p1.out_stop","p2.in_stop"],
            { route:["p1.out_data","p2.in_data"], bus:1 },
            ["p1.out_valid","p2.in_valid"],
            ["p2.in_ready","p1.out_ready"] 
        ]
    }

    hdelk.layout( graph, "pipe_packets" );
</script>

Not surprisingly, the `start` and `stop` signals mark the words that begin and end the packet. 

<script type="WaveDrom">
{ signal: [
   { name: 'clock', wave: 'p..........'},
   { name: 'start', wave: '0.30........' },
   { name: 'stop',  wave: '0.......30.' },
   { name: 'data',  wave: 'x.3222223x.', data:'d1 d2 d3 d4 d5 d6 d7'},
   { name: 'valid', wave: '0.1......0.' },
   { name: 'ready', wave: '01.........' }
  ], 
  config:{skin:"lowkey"} }
</script>

With this scheme is is possible to have one word packets, but not zero word packets, since there is always a word alongside the `start` and `stop` flags.  

<script type="WaveDrom">
{ signal: [
   { name: 'clock', wave: 'p.......'},
   { name: 'start', wave: '0..30...' },
   { name: 'stop',  wave: '0..30...' },
   { name: 'data',  wave: 'x..3x...', data:'d1'},
   { name: 'valid', wave: '0..10...' },
   { name: 'ready', wave: '01......' }
  ], 
  config:{skin:"lowkey"} }
</script>

Buses sometimes omit the `start` signal, and have a `stop` signal only (often called `eof` or "end of frame") to indicate that what has come before, since the last `stop` was part of a packet and now it has ended.  But this means that non packet and packet data can't be mixed, and any stray words get prepended to the next packet, so here at the expense of an additional signal line, we have both `start` and `stop` to make it clear.

### Data Size

Often, and especially with larger data fields, it is useful to be able to specify how much of the data field is being used.  This is a count in bits.  

<div id="pipe_data_size"></div>

<script type="text/javascript">

    var graph = {
        children: [
            { id: "p1", type:"Producer", outPorts: ["out_start", "out_stop", "out_data", "out_data_size", "out_valid", "out_ready"] },
            { id: "p2", type:"Consumer", inPorts: [ "in_start", "in_stop", "in_data", "in_data_size", "in_valid", "in_ready"] }
        ],
        edges: [
            ["p1.out_start","p2.in_start"],
            ["p1.out_stop","p2.in_stop"],
            { route:["p1.out_data_size","p2.in_data_size"], bus:1 },
            { route:["p1.out_data","p2.in_data"], bus:1 },
            ["p1.out_valid","p2.in_valid"],
            ["p2.in_ready","p1.out_ready"] 
        ]
    }

    hdelk.layout( graph, "pipe_data_size" );
</script>

This is especially useful when converting from serial pipelines to parallel ones and vice versa.  Since all pipelines are fixed width, this permits packets of less than the full size of the parallel data field to be transfered. 

Let's imagine that we have such a pipeline:

<div id="pipe_serial_parallel"></div>

<script type="text/javascript">

    var graph = {
        children: [
            { id: "p1", type:"Serial", outPorts: ["out_start", "out_stop", "out_data", "out_valid", "out_ready"] },
            { id: "p2", type:"pipe_parallelize", inPorts: [ "in_start", "in_stop", "in_data", "in_valid", "in_ready"], 
                                        outPorts: [ "out_data_size", "out_data", "out_valid", "out_ready"] },
            { id: "p3", type:"Parallel", inPorts: [ "in_data_size", "in_data", "in_valid", "in_ready"] }
        ],
        edges: [
            ["p1.out_start","p2.in_start"],
            ["p1.out_stop","p2.in_stop"],
            { route:["p1.out_data","p2.in_data"], bus:1 },
            ["p1.out_valid","p2.in_valid"],
            ["p2.in_ready","p1.out_ready"],
            { route:["p2.out_data_size","p3.in_data_size"], bus:1 },
            { route:["p2.out_data","p3.in_data"], bus:1 },
            ["p2.out_data","p3.in_data"],
            ["p2.out_valid","p3.in_valid"],
            ["p3.in_ready","p2.out_ready"]
        ]
    }

    hdelk.layout( graph, "pipe_serial_parallel" );
</script>

In this setup, there is a module `p1` that produces packets of data delineated with `start` and `stop` signals.  This serial packet is converted to a parallel one, and the data size is reported as the number of words in the packet x word size in bits.

<script type="WaveDrom">
{ signal: [
   { name: 'clock',        wave: 'p..........'},
   { name: 'p1.start',     wave: '0.10.......' },
   { name: 'p1.stop',      wave: '0.......10.' },
   { name: 'p1.data',      wave: 'x.2222222x.', data:'d1 d2 d3 d4 d5 d6 d7'},
   { name: 'p1.valid',     wave: '0.1......0.' },
   { name: 'p1.ready',     wave: '01.........' },
   { name: 'p2.data_size', wave: 'x........3x', data:'7xn'},
   { name: 'p2.data',      wave: 'x........3x', data:'d1-7'},
   { name: 'p2.valid',     wave: '0........10' },
   { name: 'p2.ready',     wave: '01.........' }
  ], 
  config:{skin:"lowkey"} }
</script>

The `data_size` field can also solve the "can't make an empty packet" problem by setting the data_size on the included data item to zero for an empty packet.  This comes at the expense of lugging around a data_size field so this is not an ideal technique.

<script type="WaveDrom">
{ signal: [
   { name: 'clock',      wave: 'p...........'},
   { name: 'start',      wave: '0..10..10...' },
   { name: 'stop',       wave: '0..10..10...' },
   { name: 'data_size',  wave: 'x..2x..3x...', data:'n 0'},
   { name: 'data',       wave: 'x..2x.......', data:'d1'},
   { name: 'valid',      wave: '0..10..10...' },
   { name: 'ready',      wave: '01..........' }
  ], 
  config:{skin:"lowkey"} }
</script>

### Payload

Collectively, all the non-handshaking fields make up the **Payload**.  

<script type="WaveDrom">
{ signal: [
   { name: 'clock',      wave: 'p...........'},
   [ "Payload",
   { name: 'start',      wave: '0..10.......' },
   { name: 'stop',       wave: '0......10...' },
   { name: 'data_size',  wave: 'x..22222x...', data:'n1 n2 n3 n4 n5 n6'},
   { name: 'data',       wave: 'x..22222x...', data:'d1 d2 d3 d4 d5 d6'} ],
   [ "Handshake",
   { name: 'valid',      wave: '0..1....0...' },
   { name: 'ready',      wave: '01..........' }],
   {}
  ],
  config:{skin:"lowkey"} }
</script>

Tools exist (as you'll see below) to manipulate the whole payload at once.

This is very handy for modules that don't much care what the various fields are, they just want to do something correctly, transparently with the entire payload.  Like a fifo, or many communication modules.  

## Implementation

### Visual Helpers

The last module diagram was a bit of an eye-full and the textual Verilog needed to make all these connections is even worse.

<div id="pipe_helpers"></div>

<script type="text/javascript">

    var graph = {
        children: [
            { id: "p1", type:"Serial", outPorts: ["out_start", "out_stop", "out_data", "out_valid", "out_ready"] },
            { id: "p2", type:"pipe_parallelize", inPorts: [ "in_start", "in_stop", "in_data", "in_valid", "in_ready"], 
                                        outPorts: [ "out_data_size", "out_data", "out_valid", "out_ready"] },
            { id: "p3", type:"Parallel", inPorts: [ "in_data_size", "in_data", "in_valid", "in_ready"] }
        ],
        edges: [
            ["p1.out_start","p2.in_start"],
            ["p1.out_stop","p2.in_stop"],
            { route:["p1.out_data","p2.in_data"], bus:1 },
            ["p1.out_valid","p2.in_valid"],
            ["p2.in_ready","p1.out_ready"],
            { route:["p2.out_data_size","p3.in_data_size"], bus:1 },
            { route:["p2.out_data","p3.in_data"], bus:1 },
            ["p2.out_data","p3.in_data"],
            ["p2.out_valid","p3.in_valid"],
            ["p3.in_ready","p2.out_ready"]
        ]
    }

    hdelk.layout( graph, "pipe_helpers" );
</script>

Visually many tools let you make short cuts in these circumstances.  The diagram above might become something more like the following:

<div id="pipe_pipes"></div>

<script type="text/javascript">

    var graph = {
        children: [
            { id: "p1", type:"Serial", outPorts: ["out_pipe"] },
            { id: "p2", type:"pipe_parallelize", inPorts: [ "in_pipe"], 
                                        outPorts: [ "out_pipe" ] },
            { id: "p3", type:"Parallel", inPorts: [ "in_pipe"] }
        ],
        edges: [
            {route:["p1.out_pipe","p2.in_pipe"], label:"serial", bus:1},
            {route:["p2.out_pipe","p3.in_pipe"], label:"parallel", bus:1}
        ]
    }

    hdelk.layout( graph, "pipe_pipes" );
</script>

So much better!  The thicker lines indicate that what is being transfered is a bundle of signals, or **Pipe**(, or bus!), and the edge labels say what kind of pipeline we are implementing.

### Pipe Specifications

How can we help ourselves in code too?  In almost any other language a data structure would be the natural way to handle this situation.  Put all the fields into a structure and pass it around as one unified object.  The compiler might even type check it for us if we're so lucky.  The (very) bad news is that Verilog does not permit structures.  They are one of the benefits of System Verilog, but questions about uniform support for System Verilog in Vendor and OSS tools results in smirks and head shakes. 

So what can we do in Verilog itself?  The one thing Verilog does allow is arrays of wires, so could we try to do that?

Let's take a look at a realistic module header in Verilog

```verilog

module sample #( parameter DataWidth = 8 )(
        input clock,
        input reset,

        input [DataWidth-1:0] in_data,
        input                 in_valid,
        output                in_ready,

        ...
    );

    ...
endmodule
```

What we want is something more like:

```verilog

module sample #( parameter PipeWidth = 8 )(
        input clock,
        input reset,

        inout  [PipeWidth-1:0] in_pipe,

        ...
    );

    ...
endmodule
```

Where all the wires of the pipe are packed into the one array:

**Pipe**
<script type="WaveDrom">
{
reg:[
    {bits: 8,  name: 'data'},
    {bits: 1,  name: 'valid'},
    {bits: 1,  name: 'ready'}
], config: {bits: 10, bigendian: false},
}
</script>

This is definitely an improvement, but we just spent all the sections above adding new (and optional) wires to our idea of a pipeline, so how do we work out the width?

The answer: **Macros**.  (Sorry!  They're nasty, but in Verilog, they're all we have)

To use them we include a header *before* our module declaration.  It needs to be before because we are able to use some of its functionality in the module header itself.

``` verilog
`include "../../pipe/rtl/pipe_predefs.v"
```

First we need a way to specify the Pipes we're using.  If this were just a single value, that would be great.  Let's try to pack the various configuration options into a single 32bit value called a **PipeSpec**.  This value will only be used during synthesis, and will not make it into our designs unless we explicitly use it. 

**PipeSpec**
<script type="WaveDrom">
{
reg:[
    {bits: 8,  name: 'data_width'},
    {bits: 1,  name: 'start_stop'},
    {bits: 1,  name: 'data_size'},
    {bits: 6,  name:'...', type:2 },
    {bits: 16, name:'...', type:2 },
    {bits: 16, name:'...', type:2 }
], config: {bits: 32, lanes:4, bigendian: false},
}
</script>

This is not the bundle of wires we're passing around as our pipe, it's a single 32b value encoding *what's in our pipe*.  With a lot of room for growth.
Note that there is no mention of `ready_valid` since these signals must be present in all pipes.

There is a shorthand for these PipeSpecs: not all combinations are defined but the pattern is 

**`PS_** + **d** + data_size + *[optionally]* **s** + *[optionally]* **z**  

- **d**n means data size n
- **s** means start and stop bits
- **z** means data size

Let's look at a few

**Example `PS_d8**

A pipe with just 8 data bits (and the `valid`, `ready` of course)

<script type="WaveDrom">
{
reg:[
    {bits: 8,  name: 'data'},
    {bits: 1,  name: 'valid'},
    {bits: 1,  name: 'ready'}
], config: {bits: 10, bigendian: false},
}
</script>

The PipeSpec for a pipe with 8 bits of data, and no other features is just 

``` verilog
8
```

The shorthand for this is

``` verilog
`PS_d8
```

Anywhere you need a PipeSpec, you can use this shorthand to define a pipe with 8 bits of data and no other additional features.

**Example `PS_d8s**

A pipe with start and stop, 8 data bits (and the `valid`, `ready`)

<script type="WaveDrom">
{
reg:[
    {bits: 8,  name: 'data'},
    {bits: 1,  name: 'stop'},
    {bits: 1,  name: 'start'},
    {bits: 1,  name: 'valid'},
    {bits: 1,  name: 'ready'}
], config: {bits: 12, bigendian: false},
}
</script>

The PipeSpec is 

``` verilog
8 | `PS_START_STOP
```

where PS_START_STOP is defined as 

``` verilog
(1<<`PS_START_STOP_BIT)
```

The short hand for this is

``` verilog
`PS_d8s
```

**Example `PS_d64sz**

<script type="WaveDrom">
{
reg:[
    {bits: 64,  name: 'data'},
    {bits: 7,  name: 'data_size'},
    {bits: 1,  name: 'stop'},
    {bits: 1,  name: 'start'},
    {bits: 1,  name: 'valid'},
    {bits: 1,  name: 'ready'}
], config: {bits: 75, lanes:5, bigendian: false},
}
</script>

The PipeSpec for a pipe with 64 bits of data, start stop and data size is  

``` verilog
64 | `PS_START_STOP_BIT | `PS_DATA_SIZE
```

where PS_DATA_SIZE is defined as 

``` verilog
(1<<`PS_DATA_SIZE_BIT)
```

### Pipe Widths

Now we can specify pipes in a single integer, we can add *more macros* to do things for us.  For a start, and most importantly, we can do what we set out to do earlier, we can calculate Pipe widths!

The macro 

``` verilog
`P_w( PipeSpec )
```

Calculates pipe width given the PipeSpec.  This is pretty straight forward - it just adds up the widths of all the enabled fields.

So finally we can define a module using this system.

```verilog

module sample #( parameter PipeSpec = `PS_d8 )(
        input clock,
        input reset,

        inout  [P_w(PipeSpec)-1:0] in_pipe,

        ...
    );

    ...
endmodule
```

The `in_pipe` port will be the right size, and we have the definition of the pipe, in the form of a PipeSpec available for later use, as we will see.

Where are we?  Here's how connecting modules together by pipe used to look:

``` verilog
    ...

    localparam DataSize = 8;

    wire                xfer_start;
    wire                xfer_stop;
    wire [DataSize-1:0] xfer_data;
    wire                xfer_valid;
    wire                xfer_ready;

    producer #( .DataSize( DataSize ) ) p (
            ...
            .out_start( xfer_start ), 
            .out_stop( xfer_stop ), 
            .out_data( xfer_data ), 
            .out_valid( xfer_valid ), 
            .out_ready( xfer_ready ), 
            ...
        );
    consumer #( .DataSize( DataSize ) ) c ( 
            ... 
            .in_start( xfer_start ), 
            .in_stop( xfer_stop ), 
            .in_data( xfer_data ), 
            .in_valid( xfer_valid ), 
            .in_ready( xfer_ready ), 
            ...
        );

    ...
```

Exhausting.  The two modules are connected, but at what price to your sanity.  Forget about linking chains of them up.

Fortunately, having all the present and future features of pipes being passed around as a single packed array means that using pipeline modules is very easy.

``` verilog
    ...

    localparam XferPipeSpec = `PS_d8s;

    wire [P_w(XferPipeSpec)-1:0] xferPipe;

    producer #( .PipeSpec( XferPipeSpec ) ) p ( 
            ... 
            .out_pipe( xferPipe ) 
            ...
        );
    consumer #( .PipeSpec( XferPipeSpec ) ) c ( 
            ... 
            .in_pipe( xferPipe ) 
            ...
        );

    ...
```

With these few lines the modules are connected.  So much better.  Even if we have to tolerate a macro or two.

### Pipe Macro Summary

Here are the PipeSpec shorthand macros we can use:

``` verilog
`define PS_d8     ( 8 )
`define PS_d8s    ( 8 | `PS_START_STOP ) // 8 bit data, and start stop signals
`define PS_d8sz   ( 8 | `PS_START_STOP | `PS_DATA_SIZE ) // 8 bit data, and data size

`define PS_d16    ( 16 )
`define PS_d16s   ( 16 | `PS_START_STOP ) // 16 bit data, and start stop signals
`define PS_d16sz  ( 16 | `PS_START_STOP | `PS_DATA_SIZE ) // 16 bit data, and data size

`define PS_d32    ( 32 ) // 32 bit data onlyw
`define PS_d32s   ( 32 | `PS_START_STOP ) // 32 bit data, and start stop signals
`define PS_d32sz  ( 32 | `PS_START_STOP | `PS_DATA_SIZE ) // 32 bit data, start stop signals and data size

`define PS `PS_d8s
```

Here are the Macros for calculating widths.  Note that if the field is not present, the width is 0.  

``` verilog
`define P_Data_w( spec )     ( ( spec ) & `PS_DATA )
`define P_DataSize_w( spec ) ( ( ( spec ) & `PS_DATA_SIZE ) ? $clog2( `P_Data_w( spec ) ) + 1 : 0 )
`define P_Start_w( spec )    ( ( ( spec ) & `PS_START_STOP ) ? 1 : 0 )
`define P_Stop_w( spec )     ( ( ( spec ) & `PS_START_STOP ) ? 1 : 0 )
`define P_Error_w( spec )    ( ( ( spec ) & `PS_ERROR ) ? 1 : 0 )
`define P_Valid_w( spec )    ( 1 )
`define P_Ready_w( spec )    ( 1 )
```

The only vaguely interesting thing is the calculation the width of the data_size field.  If the data_size itself is zero the data_size width is zero.  Otherwise, data_size width is ( log2(data_size) + 1 ).  There needs to be room to express a 100% full data field. log2( data_size) bits is not enough. For example, for data_size 8 (a common number), the legal sizes are 0 (empty) through 8 (full). The data_size width couldn't be log2(8) = 3 bits, since a three bit register can't contain 8 (only 0 - 7)! Hence the extra bit.

Here's the width of the payload part of the pipe.  Recall that the payload is all the actual data in a pipe.

```verilog
`define P_Payload_w( spec )  ( `P_w( spec ) - 2 )
```

It's just the width of the whole pipe less the two handshake signals.

### Pipe Helper Modules

Turning our attention from module *use* to module *creation*, how are we going to get the data out of these packed arrays?  This time tiny sub modules are the way to go.  Instead of having to do elaborate bit location calculations there are module helpers.

Declare the data values you need, and then instanciate the helper to pack or unpack the pipe field you want.  A great part of this story is that these packing and unpacking functions will work even if the fields are not there in the PipeSpec.  For example unpacking Start and Stop fields from a pipe that according to the PipeSpec doesn't have them results in registers being defined that are always 0.  Similarly attempting to pack Start and Stop fields into a pipe that doesn't have them just silently doesn't do it.  This cuts down on conditional code in the rest of the module. 

The best part of the pipe packer and unpacker story is that these modules are mostly just helpers.  They add almost nothing to the final design. 

What is this going to look like?

<div id="pipe_helper_modules"></div>

<script type="text/javascript">

    var graph = {
        children: [
            { id: "p1", type:"Producer", outPorts: ["out_pipe"],
                children: [
                    { id: "p1p1", label:"", port:1, inPorts:["out_start", "out_stop", "out_data", "out_valid", "out_ready" ], outPorts: ["out_pipe"]  },
                    { id: "Internals", type:"Verilog", outPorts:["out_start", "out_stop", "out_data", "out_valid", "out_ready" ]  }
                ],
                edges: [
                    { route:["p1p1.out_pipe","p1.out_pipe"], bus:1 },
                    ["Internals.out_start","p1p1.out_start"],
                    ["Internals.out_stop","p1p1.out_stop"],
                    { route:["Internals.out_data","p1p1.out_data"], bus:1 },
                    ["Internals.out_valid","p1p1.out_valid"],
                    ["p1p1.out_ready","Internals.out_ready"] 
                ]
             },
            { id: "p2", type:"Consumer", inPorts: [ "in_pipe"],
                children: [
                    { id: "p2p1", label:"", port:1, inPorts: ["in_pipe"], outPorts:["in_start", "in_stop", "in_data", "in_valid", "in_ready" ],  },
                    { id: "Internals", type:"Verilog", inPorts:["in_start", "in_stop", "in_data", "in_valid", "in_ready" ],  }
                ],
                edges: [
                    { route:["p2.in_pipe","p2p1.in_pipe"], bus:1 },
                    ["p2p1.in_start","Internals.in_start"],
                    ["p2p1.in_stop","Internals.in_stop"],
                    { route:["p2p1.in_data","Internals.in_data"], bus:1 },
                    ["p2p1.in_valid","Internals.in_valid"],
                    ["Internals.in_ready","p2p1.in_ready"] 
                ] }
        ],
        edges: [
            { route:["p1.out_pipe","p2.in_pipe"], bus:1 }
        ]
    }

    hdelk.layout( graph, "pipe_helper_modules" );
</script>

Somehow, inside the module, some code is going to take the packed arrays that contain all the pipe data and handshake signals and expand them into something useful.

Here's the top of a simple producer module:

``` verilog
module producer #( parameter PipeSpec = `PS_d8 )(
        input clock,
        input reset,

        inout  [P_w(PipeSpec)-1:0] out_pipe,    // using the `P_w( ) macro returning a pipe's overall width

        ...
    );

    localparam PipeData_w = `P_Data_w(PipeSpec); // using the `P_Data_w( ) macro returning a pipe's data width

    reg out_start;
    reg out_stop;
    reg [PipeData_w-1:0] out_data;
    reg out_valid;
    wire out_ready;

    p_pack_start_stop   #( .PipeSpec( PipeSpec ) )  p_pp_ss(   .start(out_start), .stop(out_stop), .pipe(out_pipe) );
    p_pack_data         #( .PipeSpec( PipeSpec ) )   p_pp_d(                      .data(out_data), .pipe(out_pipe) );
    p_pack_valid_ready  #( .PipeSpec( PipeSpec ) )  p_pp_vr( .valid(out_valid), .ready(out_ready), .pipe(out_pipe) );

    // out_start, out_stop, out_data, out_valid, out_ready are all now automatically bundled into out_pipe

    ...
endmodule

```
Here, as required, the separate signals that are used internal to the module are bundled by helper submodules into a single array, `out_pipe` for routing outside.

Note that the default PipeSpec (PS_d8) has no Start Stop flags, but the code can still work with them if they're there.  The code can assign to them but there is no further effect. 

Here's what a consumer looks like:

``` verilog
module consumer #( parameter PipeSpec = `PS_d8 )(
        input clock,
        input reset,

        inout  [P_w(PipeSpec)-1:0] in_pipe,      // using the `P_w( ) macro returning a pipe's overall width

        ...
    );

    localparam PipeIn_Data_w = `P_Data_w(PipeSpec); // using the `P_Data_w( ) macro returning a pipe's data width

    wire in_start;
    wire in_stop;
    wire [PipeIn_Data_w-1:0] in_data;
    wire in_valid;
    reg in_ready;

    p_unpack_start_stop  #( .PipeSpec( PipeSpec ) ) p_upp_ss( .pipe(in_pipe), .start(in_start), .stop(in_stop) );
    p_unpack_data        #( .PipeSpec( PipeSpec ) )  p_upp_d( .pipe(in_pipe), .data(in_data) );
    p_unpack_valid_ready #( .PipeSpec( PipeSpec ) ) p_upp_vr( .pipe(in_pipe), .valid(in_valid), .ready(in_ready) );

    // in_start, in_stop, in_data, in_valid, in_ready are all now automatically available for use in the rest of the module

    ...
endmodule

```
Similarly, as required, the single `in_pipe` array from outside is unbundled by helper submodules into separate signals to be used internal to the module.

Note again that the default PipeSpec (PS_d8) has no Start Stop flags, but the code can still work with them if they're there. They will appear as always off wires to the synthesizer. 

### Pipe Helper Module Summary

Here are the various packers and unpackers.

Payload as a whole pack and unpack

```verilog

module p_pack_payload #( parameter PipeSpec = `PS ) (
        input [`P_Payload_w(PipeSpec)-1:0] payload,
        input [`P_w(PipeSpec)-1:0]   pipe
    );
    ...
endmodule

module p_unpack_payload #( parameter PipeSpec = `PS ) (
        inout [`P_w(PipeSpec)-1:0]       pipe,
        output [`P_Payload_w(PipeSpec)-1:0] payload
    );
    ...
endmodule
```

Ready Valid pack and unpack

```verilog

module p_pack_valid_ready #( parameter PipeSpec = `PS ) (
        input                    valid,
        output                   ready,
        inout [`P_w(PipeSpec)-1:0] pipe
    );
    ...
endmodule

module p_unpack_valid_ready #( parameter PipeSpec = `PS ) (
        inout [`P_w(PipeSpec)-1:0] pipe,
        output                   valid,
        input                    ready
    );
    ...
endmodule
```

Start Stop pack and unpack

```verilog
module p_pack_start_stop #( parameter PipeSpec = `PS ) (
        input                    start,
        input                    stop,
        inout [`P_w(PipeSpec)-1:0] pipe
    );
    ...
endmodule

module p_unpack_start_stop #( parameter PipeSpec = `PS ) (
        inout [`P_w(PipeSpec)-1:0] pipe,
        output                   start,
        output                   stop
    );
    ...
endmodule
```

Data pack and unpack

```verilog
module p_pack_data #( parameter PipeSpec = `PS ) (
        input [`P_Data_w(PipeSpec)-1:0] data,
        inout [`P_w(PipeSpec)-1:0]      pipe
    );
    ...
endmodule

module p_unpack_data #( parameter PipeSpec = `PS ) (
        inout [`P_w(PipeSpec)-1:0]       pipe,
        output [`P_Data_w(PipeSpec)-1:0] data
    );
    ...
endmodule
```

Data Size pack and unpack

```verilog
module p_pack_data_size #( parameter PipeSpec = `PS ) (
        input [`P_DataSize_w(PipeSpec)-1:0] data_size,
        inout [`P_w(PipeSpec)-1:0]          pipe
    );
    ...
endmodule

module p_unpack_data_size #( parameter PipeSpec = `PS ) (
        inout [`P_w(PipeSpec)-1:0]          pipe,
        output [`P_DataSize_w(PipeSpec)-1:0] data_size
    );
    ...
endmodule
```

## Futher Work

### More Fields

Since there is no runtime downside to having extra fields that are not being used, it is tempting to wonder about supporting other fields.  This has to be approached with caution, howeve, since adding features creates a requirement that existing modules support them.

- **Address** - When forming a read or write operation to a memory, it might be handy to have an Address field.
- **Meta Character** - When communicating over a lossy channel, it is frequently desirable to have access to meta characters (message start, message end, message crc follows, etc.)
- **Error** - Perhaps it might be useful to send an error signal that many different kinds of module could interpret
- **Flags** - sometimes a tiny bit of extra data is critical to have along side a data word, could a general facility be developed around a generic "flags" field of a certain width.

### Spec Checking
- Under Icarus, a kind of conditional compile time error can be created that can be used to cause errors when necessary.  Errors of configuration could stop the build process with an error message.  This would be very handy to allow modules to insist that connected pipes have certain features, for example, that their data width is greater or less than a certin amount, that the Start Stop signals are supported, etc.  What is a technique that works universally?

### Code Cleanup
- the macro's are a little scruffy still, they need another pass or two

### Libraries
- we need a "rich library of components"

## Appendix

### Fast Pipeline Programming

Ready - Valid handshaking is a great way for modules to connect together, at its best permitting controlled data transfers on every clock cycle.  Pure pipeline Producers Consumers are relatively easy to implement, but in a situation where a module is sending *and* receiving, things get complex.

There is the ugly possibility that the middle module-in-a-chain, while receiving valid data from upstream, has its `ready` signal withdrawn from the downstream module, resulting in the need for the middle module to retain its data *and* store the next one.  Effects ripple back up the chain.

<div id="pipe_pipeline"></div>

<script type="text/javascript">

    var graph = {
        children: [
            { id: "p1", type:"Producer", outPorts: ["out_data", "out_valid", "out_ready"] },
            { id: "p2", type:"In & Out", inPorts: [ "in_data", "in_valid", "in_ready"], outPorts: ["out_data", "out_valid", "out_ready"] },
            { id: "p3", type:"Consumer", inPorts: [ "in_data", "in_valid", "in_ready"] }
        ],
        edges: [
            {route:["p1.out_data","p2.in_data"], bus:1 },
            {route:["p1.out_valid","p2.in_valid"] },
            {route:["p2.in_ready","p1.out_ready"] },
            {route:["p2.out_data","p3.in_data"], bus:1 },
            {route:["p2.out_valid","p3.in_valid"] },
            {route:["p3.in_ready","p2.out_ready"] }
        ]
    }

    hdelk.layout( graph, "pipe_pipeline" );
</script>

<script type="WaveDrom">
{ signal: [
   { name: 'clock', wave: 'p............'},
   { name: 'p1.out_data',  wave: 'x.222224.2x..', data:'d1 d2 d3 d4 d5 d6 d7'},
   { name: 'p1.out_valid', wave: '0.1.......0..' },
   { name: 'p2.in_ready', wave: '01.....01....' },
   { name: 'p2.data_overflow', wave: '0......40....', data:'d5' },
   { name: 'p2.out_data',  wave: 'x..2224.222x.', data:'d1 d2 d3 d4 d5 d6 d7'},
   { name: 'p2.out_valid', wave: '0..1.......0.' },
   { name: 'p3.in_ready', wave: '0.1...01.....' }
  ], 
  head:{ tock:1 },
  config:{skin:"lowkey"} }
</script>

Let's see what's happening in this train wreck.  The trouble starts at Cycle 7 when **p3** decides to be not ready for a cycle.

| Cycle | p1 -> p2 | p2 -> p3 |
|   - | - | - | - |
|  <3 | Ready, No Data | Ready, No Data |
|   3 | **d1** transfered | Ready, No Data |
|   4 | **d2** transfered | **d1** transfered | 
|   5 | **d3** transfered | **d2** transfered | 
|   6 | **d4** transfered | **d3** transfered | 
|   7 | **d5** transfered | **d4** waiting, **p3** *not ready*, nothing transfered | 
|   8 | **d6** waiting, **p2** *not ready*, **d5** stored in overflow | **d4** transfered, **p3** *ready again* | 
|   9 | **d6** transfered, **p2** *ready again*, overflow cleared | **d5** transfered | 
|  10 | **d7** transfered | **d6** transfered | 
|  11 | Ready, No Data  | **d7** transfered | 
| >11 | Ready, No Data | Ready, No Data |

The consequences of the hold-up propagate back up through the pipeline, one module per cycle.

Codewise, this isn't too dire for a Producer or Consumer.  They just wait for conditions to be right again for transfers.  Any module in the middle, dealing with both its commitments downstream and upstream, however has to have provisions for stalling. And unstalling.  It can be quite a mind-bender.  

Codewise, pipeline modules with pipes in and out will have states much like the following:

- **STATE_STARVING** - we are ready for `in_data` (`in_ready` is high), but the upstream module doesn't have any (`in_valid` was low), there may be `out_data` until `out_ready` when we set `out_valid` to false.
- **STATE_TRANSFERING** - we are ready for data (`in_ready` is high), there was valid `in_data`, out `out_ready` was asserted by the downstream module, if all is well, we transfer the data to `out_data` and `out_valid` is asserted.
- **STATE_STALLED** - we are not ready for new data (`in_ready` was low.  And we have `out_data` (`out_valid` is true), but the downstream module was not ready (`out_ready` was low). 
- **STATE_OVERFLOWED** - we are not ready for `in_data`, since we're full up.  We have data in `data_overflow`.  The downstream module was not ready (`out_ready` was low).  We have `out_data` waiting to be transfered and `out_valid` asserted. 

It can (did) take many weeks of sober contemplation to get this all straight.

## Reviewer Questions

If you are kindly reviewing this **thank you**!

What do you think about the general concept?

What do you think about the general presentation?

Is a macro scheme to cut back on typing worth it?

Is the macro scheme presented here reasonable?

Is the pipeline macro and function naming too terse?

Any other comments?

- @ me on Twitter - @davidthings
- leave issues in the repo
- email me - david@davidthings.com
