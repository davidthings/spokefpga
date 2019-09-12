---
layout: single_tech
title: "Documentation Tools"
permalink : /documentation_tools
toc: true
toc_label: Contents
toc_sticky: true
wavedrom : 1
threejs: 1
railroad: 1
header:
  title: Tutorial
  overlay_image: /assets/images/spokefpga_banner_thin.png
---

# Documentation Tools

Documentation of FPGA systems can be greatly assisted by the many documentation tools available.  Here are some examples.

One common theme that unites them is that the diagrams are initially described in code, rather than via WYSIWYG.  Possibly this is a technique that only an engineer could love, but there are some distinct advantages to code-generated diagrams.

- designs are trivially changeable - sometimes changing a WYSIWYG is not too bad.  Changing 100 at a time is prohibitive.  Code can be put into functions and changed in one place.  Code can be search and replaced.
- style changes are automatic.  If you want your diagrams to appear a little different, when you change the style, they are all changed
- code can be generated.  If diagrams come from some data source, they can be created automatically by writing a route to do so.
- domain specificity.  Tools can be created that address very specific needs.
- code-based diagrams can be interactive

For each tool below, there is an example or two and the code that created it.

## Diagramming with SVG.JS

[SVG.js](https://svgjs.com/) is a small library that makes creating SVG diagrams very easy.

<div id="drawing"></div>

<script type="text/javascript">
    var svg_draw = function() {
        var draw = SVG('drawing').size(600, 120)
        var line = draw.polyline( [[75,25],[400,25]]).fill('none').stroke( { color:'#999', width:4 } )
        var line = draw.polyline( [[75,50],[400,50]]).fill('none').stroke( { color:'#999', width:4 } )
        var rect = draw.rect(75, 75).attr({ fill: '#800080' }).stroke( { color:'#600060', width:2 } )
        var rect = draw.rect(75, 75).attr({ fill: '#800080' }).stroke( { color:'#600060', width:2 } ).move( 200, 0 )
        var rect = draw.rect(75, 75).attr({ fill: '#800080' }).stroke( { color:'#600060', width:2 } ).move( 400, 0 )
    }
    svg_draw();
</script>

```js
var svg_draw = function() {
    var draw = SVG('drawing').size(600, 120)
    var line = draw.polyline( [[75,25],[400,25]]).fill('none').stroke( { color:'#999', width:4 } )
    var line = draw.polyline( [[75,50],[400,50]]).fill('none').stroke( { color:'#999', width:4 } )
    var rect = draw.rect(75, 75).attr({ fill: '#800080' }).stroke( { color:'#600060', width:2 } )
    var rect = draw.rect(75, 75).attr({ fill: '#800080' }).stroke( { color:'#600060', width:2 } ).move( 200, 0 )
    var rect = draw.rect(75, 75).attr({ fill: '#800080' }).stroke( { color:'#600060', width:2 } ).move( 400, 0 )
}
svg_draw();
```

## WaveDrom

[WaveDrom](https://wavedrom.com/) draws Wave, Register and more diagrams from [JSON](https://www.json.org/) descriptions.

### Wave

The Wave diagrams produced can be very helpful understanding and communicating designs.

<script type="WaveDrom">
{ signal: [
  {    name: 'clk',   wave: 'p..Pp..P'},
  ['Master',
    ['ctrl',
      {name: 'write', wave: '01.0....'},
      {name: 'read',  wave: '0...1..0'}
    ],
    {  name: 'addr',  wave: 'x3.x4..x', data: 'A1 A2'},
    {  name: 'wdata', wave: 'x3.x....', data: 'D1'   },
  ],
  {},
  ['Slave',
    ['ctrl',
      {name: 'ack',   wave: 'x01x0.1x'},
    ],
    {  name: 'rdata', wave: 'x.....4x', data: 'Q2'},
  ]
], config:{skin:"lowkey"}}
</script>

```js
{ signal: [
  {    name: 'clk',   wave: 'p..Pp..P'},
  ['Master',
    ['ctrl',
      {name: 'write', wave: '01.0....'},
      {name: 'read',  wave: '0...1..0'}
    ],
    {  name: 'addr',  wave: 'x3.x4..x', data: 'A1 A2'},
    {  name: 'wdata', wave: 'x3.x....', data: 'D1'   },
  ],
  {},
  ['Slave',
    ['ctrl',
      {name: 'ack',   wave: 'x01x0.1x'},
    ],
    {  name: 'rdata', wave: 'x.....4x', data: 'Q2'},
  ]
], config:{skin:"lowkey"}}
```

### Register

WaveDrom also allows easy depiction of registers and protocols.

<script type="WaveDrom">
{
reg:[
    {bits: 8,  name: 'Data'},
    {bits: 1,  name: 'Stop'},
    {bits: 1,  name: 'Start'},
    {bits: 1,  name: 'Valid'},
    {bits: 1,  name: 'Ready'},
    {bits: 4 },
], config: {skin:"lowkey", hspace: 800, bits: 12, lanes:1, bigendian: true}
}
</script>

```js
{
reg:[
    {bits: 8,  name: 'Data'},
    {bits: 1,  name: 'Stop'},
    {bits: 1,  name: 'Start'},
    {bits: 1,  name: 'Valid'},
    {bits: 1,  name: 'Ready'},
    {bits: 4 },
], config: {skin:"lowkey", hspace: 800, bits: 12, lanes:1, bigendian: true}
}
```

## HDElk Diagrams

[HDElk](https://davidthings.github.io/hdelk/) (also written by DavidThings!) Was created to draw simple node-port diagrams.

<div id="simple_diagram"></div>

```js
const simple_graph = {
    id: "",
    children: [
        { id: "in", port: 1 },
        { id: "one", ports: ["in", "out"] },
        { id: "two", highlight:1, ports: ["in", "out"] },
        { id: "three", ports: ["in", "out"] },
        { id: "out", port: 1 }
    ],
    edges: [
        ["in","one.in"],
        {route:["one.out","two.in"],highlight:1},
        {route:["two.out","three.in"],highlight:1,bus:1},
        {route:["three.out","out"], bus:1 }
    ]
}
```
<div id="just_right_diagram"></div>

```js
const just_right_graph = {
    id: "",
    children: [
        { id: "in", port: 1 },
        { id: "one", type:"preprocess", ports: ["in", "out", "extra", "bypass"] },
        { id: "two", highlight:0, color:"#F0F0F0",
            ports: ["in", "out", "extra"],
            children:[
            {id:"Child1", ports:["in", "out", "extra", "feedback"]},
            {id:"Child2", ports:["in", "out", "feedback"]},
            {id:"Child3", highlight:2, ports:["in", "out"]}
            ],
            edges:[
            [ "two.in", "Child1.in" ],
            [ "two.extra", "Child1.extra" ],
            [ "Child1.out", "Child2.in" ],
            [ "Child2.feedback", "Child1.feedback" ],
            [ "Child2.out", "Child3.in" ],
            [ "Child3.out", "two.out" ]
            ] },
        { id: "three", type:"postprocess", ports: ["in", "bypass", "out"] },
        { id: "out", port: 1 }
    ],
    edges: [
        ["in","one.in"],
        {route:["one.out","two.in"],highlight:1},
        {route:["one.extra","two.extra"],highlight:1},
        {route:["two.out","three.in"],highlight:1,bus:1},
        {route:["three.out","out"], bus:1 },
        {route:["one.bypass","three.bypass"],highlight:1}
    ]
}
```


<script type="text/javascript">

    const simple_graph = {
        id: "",
        children: [
            { id: "in", port: 1 },
            { id: "one", ports: ["in", "out"] },
            { id: "two", highlight:1, ports: ["in", "out"] },
            { id: "three", ports: ["in", "out"] },
            { id: "out", port: 1 }
        ],
        edges: [
            ["in","one.in"],
            {route:["one.out","two.in"],highlight:1},
            {route:["two.out","three.in"],highlight:1,bus:1},
            {route:["three.out","out"], bus:1 }
        ]
    }

    hdelk.layout( simple_graph, "simple_diagram" );

    const just_right_graph = {
        id: "",
        children: [
            { id: "in", port: 1 },
            { id: "one", type:"preprocess", ports: ["in", "out", "extra", "bypass"] },
            { id: "two", highlight:0, color:"#F0F0F0",
              inPorts: ["in", "extra"],
              outPorts: ["out"],
              children:[
                {id:"Child1", inPorts:["in", "extra", "feedback"], outPorts:["out"]},
                {id:"Child2", inPorts:["in", "extra", "feedback"], ports:[ "out"]},
                {id:"Child3", highlight:2, ports:["in", "out"]}
               ],
              edges:[
                [ "two.in", "Child1.in" ],
                [ "two.extra", "Child1.extra" ],
                [ "Child1.out", "Child2.in" ],
                [ "Child2.feedback", "Child1.feedback", -1 ],
                [ "Child2.out", "Child3.in" ],
                [ "Child3.out", "two.out" ]
              ] },
            { id: "three", type:"postprocess", ports: ["in", "bypass", "out"] },
            { id: "out", port: 1 }
        ],
        edges: [
            ["in","one.in"],
            {route:["one.out","two.in"],highlight:1},
            {route:["one.extra","two.extra"],highlight:1},
            {route:["two.out","three.in"],highlight:1,bus:1},
            {route:["three.out","out"], bus:1 },
            {route:["one.bypass","three.bypass"],highlight:1}
        ]
    }

    hdelk.layout( just_right_graph, "just_right_diagram" );


</script>

## Railroad-Diagrams

[Railroad-Diagram](https://github.com/tabatkins/railroad-diagrams) Generator from tabatkins

>A small JS+SVG library for drawing railroad syntax diagrams, like on JSON.org. Now with a Python port!

### Value
<script>
ComplexDiagram(
  Sequence( Terminal('type-tag'),
      Choice( 0, NonTerminal('int'),
                NonTerminal('float'),
                NonTerminal('fixed'),
                NonTerminal('string'),
                NonTerminal('object'),
                NonTerminal('array')
                )
  )
).addTo();
</script>

### Object
<script>
ComplexDiagram(
  Choice( 0,  Sequence(
                  ZeroOrMore(
                      Sequence(
                          NonTerminal('value'),
                          NonTerminal('value')
                      )
                  ),
                 Terminal('end-object')
             ) )
).addTo();
</script>

### Array
<script>
ComplexDiagram(
  Choice( 0,  Sequence(
                  ZeroOrMore(
                      NonTerminal('value'),
                  ),
                 Terminal('end-array')
             ) )
).addTo();
</script>

## ThreeJS

ThreeJS - Library based on WebGL.  Easy 3D diagrams.

<div id="threejs_d1"></div>

<script>
// these need to be accessed inside more than one function so we'll declare them first
let container;
let camera;
let renderer;
let scene;
let mesh;

let width = 600;
let height = 200;

function init() {

  // Get a reference to the container element that will hold our scene
  container = document.getElementById( "threejs_d1" );

  // create a Scene
  scene = new THREE.Scene();

  scene.background = new THREE.Color( 0xF0F0F0 );

  // set up the options for a perspective camera
  const fov = 20; // fov = Field Of View
  const aspect = width / height;
  const near = 0.1;
  const far = 100;

  camera = new THREE.PerspectiveCamera( fov, aspect, near, far );

  // every object is initially created at ( 0, 0, 0 )
  // we'll move the camera back a bit so that we can view the scene
  camera.position.set( 0, 0, 10 );

  // create a geometry
  const geometry = new THREE.BoxBufferGeometry( 2, 2, 2 );

  // create a purple Standard material
  const material = new THREE.MeshStandardMaterial( { color: 0x800080 } );

  // create a Mesh containing the geometry and material
  mesh = new THREE.Mesh( geometry, material );

  // add the mesh to the scene object
  scene.add( mesh );

  // Create a directional light
  const light = new THREE.DirectionalLight( 0xffffff, 5.0 );

  // move the light back and up a bit
  light.position.set( 10, 10, 10 );

  // remember to add the light to the scene
  scene.add( light );

  // create a WebGLRenderer and set its width and height
  renderer = new THREE.WebGLRenderer( { antialias: true } );
  renderer.setSize( width,height );

  renderer.setPixelRatio( window.devicePixelRatio );

  // add the automatically created <canvas> element to the page
  container.appendChild( renderer.domElement );

}

function animate() {

  // call animate recursively
  requestAnimationFrame( animate );

  // increase the mesh's rotation each frame
  mesh.rotation.z += 0.01;
  mesh.rotation.x += 0.01;
  mesh.rotation.y += 0.01;

  // render, or 'create a still image', of the scene
  // this will create one still image / frame each time the animate
  // function calls itself
  renderer.render( scene, camera );

}

// call the init function to set everything up
init();

// then call the animate function to render the scene
animate();

</script>

```js
  ...

  // create a geometry
  const geometry = new THREE.BoxBufferGeometry( 2, 2, 2 );

  // create a purple Standard material
  const material = new THREE.MeshStandardMaterial( { color: 0x800080 } );

  // create a Mesh containing the geometry and material
  mesh = new THREE.Mesh( geometry, material );

  // add the mesh to the scene object
  scene.add( mesh );

  // Create a directional light
  const light = new THREE.DirectionalLight( 0xffffff, 5.0 );

  // move the light back and up a bit
  light.position.set( 10, 10, 10 );

  ...
  ```

## Highlight

Javascript-based Code Highlighter

<link rel="stylesheet" href="{{site.baseurl}}/assets/css/highlight.default.min.css">
<script src="{{site.baseurl}}/assets/js/highlight.min.js"></script>

<div id="highlight_ex"></div>

<script>

var s = "assign a_thing = another_thing;"

var dp = document.getElementById( "highlight_ex" );
dp.innerHTML = s;
dp.classList.add("verilog");

hljs.highlightBlock(dp);

</script>

```js
var s = "assign a_thing = another_thing;"

var dp = document.getElementById( "highlight_ex" );
dp.innerHTML = s;
dp.classList.add("verilog");

hljs.highlightBlock(dp);
```

## CodeMirror

<script src="{{site.baseurl}}/assets/js/codemirror.js"></script>
<link rel="stylesheet" href="{{site.baseurl}}/assets/css/codemirror.css">
<script src="{{site.baseurl}}/assets/js/cm_javascript.js"></script>


<div>
  <textarea rows="4" cols="50" id="codesnippet" name="codesnippet">

var g = { };

  </textarea>
</div>

<script>
    var codeMirror = CodeMirror.fromTextArea(document.getElementById('codesnippet'), {
        mode: "javascript",
        theme: "default",
        lineNumbers: true,
        readOnly: false
    });
</script>

``` html

<div>
  <textarea rows="4" cols="50" id="codesnippet" name="codesnippet">

var g = { };

  </textarea>
</div>

<script>
    var codeMirror = CodeMirror.fromTextArea(document.getElementById('codesnippet'), {
        mode: "javascript",
        theme: "default",
        lineNumbers: true,
        readOnly: false
    });
</script>
```