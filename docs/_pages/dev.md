---
layout: single_tech
title: "Dev"
permalink : /dev
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

# Dev Area

## Diagramming with SVG.JS

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

## WaveDrom

### Wave

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


### Register


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

## HDElk Diagrams

<div id="simple_diagram"></div>

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

</script>

## Railroad-Diagrams


### Value

<script>
ComplexDiagram(
    Choice( 0,
            Terminal('null'),
            Terminal('error'),
            Terminal('true'),
            Terminal('false'),
            NonTerminal('uint7-tag|uint7'),
            Sequence( Terminal('ref-uint8-tag'), NonTerminal('uint8') ),
            Sequence( Terminal('ref-uint16-tag'), NonTerminal('uint16') ),
            Sequence( Terminal('int8-tag'), NonTerminal('int8') ),
            Sequence( Terminal('int16-tag'), NonTerminal('int16') ),
            Sequence( Terminal('int32-tag'), NonTerminal('int32') ),
            Sequence( Terminal('uint8-tag'), NonTerminal('uint8') ),
            Sequence( Terminal('uint16-tag'), NonTerminal('uint16') ),
            Sequence( Terminal('uint32-tag'), NonTerminal('uint32') ),
            Sequence( Terminal('float-tag'), NonTerminal('float') ),
            Sequence( Terminal('fp-n.m-tag'), NonTerminal('fixed-point-n.m') ),
            Sequence( Terminal('string-z-tag'), NonTerminal('string'), Terminal('0') ),
            Sequence( Terminal('string-l8-tag'), NonTerminal('uint8'), NonTerminal('string') ),
            Sequence( Terminal('string-l16-tag'), NonTerminal('uint16'), NonTerminal('string') ),
            Sequence( Terminal('binary-l8-tag'), NonTerminal('uint8'), NonTerminal('binary') ),
            Sequence( Terminal('binary-l16-tag'), NonTerminal('uint16'), NonTerminal('binary') ),
            Sequence( Terminal('array-tag'), ZeroOrMore( NonTerminal('value') ), Terminal('end-array-tag') ),
            Sequence( Terminal('object-tag'), ZeroOrMore( Sequence( NonTerminal('value'), NonTerminal('value') ) ), Terminal( 'end-object-tag') )
            )
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
