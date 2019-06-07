---
layout: single_tech
title: "Documentation Tools"
permalink : /documentation_tools
toc: true
toc_label: Contents
toc_sticky: true
wavedrom : 1
threejs: 1
header:
  title: Tutorial
  overlay_image: /assets/images/spokefpga_banner_thin.png
---

# Documentation Tools

## ThreeJS

ThreeJS - Based on WebGL

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


## WaveDrom

<script type="WaveDrom">
{ signal : [
  { name: "Clock",  wave: "p......" },
  { name: "Data",  wave: "x.34.5x",   data: "head body tail" },
  { name: "Start", wave: "0.10..." },
  { name: "Stop", wave: "0....10" },
  { name: "Valid", wave: "0.1...0" },
  { name: "Ready", wave: "1......" },
], config:{skin:"lowkey"}}
</script>

## WaveDrom Register

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


## Diagramming with SVG.JS

<div id="drawing"></div>

<script type="text/javascript">
    var svg_draw = function() {
        var draw = SVG('drawing').size(400, 120)
        var rect = draw.rect(75, 75).attr({ fill: '#f06' })
        var rect = draw.rect(75, 75).attr({ fill: '#f06' }).move( 200, 0 )
        var line = draw.polyline( [[75,38],[200,38]]).fill('none').stroke( { color:'#999', width:4 } )
    }
    svg_draw();
</script>



## HDElk Diagrams

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

    hdelk.layout( just_right_graph, "just_right_diagram" );

    const graph = {
        id: "main",
        color:"#F7F7F7",
        children: [
            { id: "input", port:1 },
            { id: "node_one", ports: ["in", {id:"p1",label:"Loop"},"p2"] },
            { id: "n2", label: "n_2", type:"output", ports: ["p1", "p2", {id:"p3",label:"Long Label"},"p4"] },
            { id: "n3", type:"pipe",  ports: ["p1","p2", "p3"] },
            { id: "n4", type:"pipeA", ports: ["p1","p2"]  },
            { id: "n5", type:"pipeB", ports: ["p1","p2","p3"]  },
            { id: "n6", type:"pipeC", ports: ["p1","p2","p3","p4"]  },
            { id: "n7",
                highlight:1,
                ports: ["p1","p2","pIn"],
                children: [
                    { id: "pIn", highlight:1, label:"", port:1, ports: ["pIn", "Valid","Ready"] },
                    { id: "c1", highlight:5, type:"compA", ports: ["Valid", "Ready", {id:"p1",label:"Loop"},"p2","p3"] },
                    { id: "c2", highlight:3, type:"compB", ports: ["p1","p2","p3"] },
                    { id: "c3", highlight:4, type:"compC", ports: ["p1","p2","p3","p4"] },
                    { id: "c4", highlight:2, type:"compD", ports: ["p1","p2"] }
                ],
                edges: [
                    { sources:["c1.p2"], targets:["c2.p1"], bus:1, highlight:5 },
                    { source:"n7.p1", target:"c1.p1" },
                    { route:[ "c2.p2", "c4.p1" ], bus:1, highlight:3 },
                    { route:[ "c4.p2", "n7.p2" ], bus:1, highlight:2 },
                    { route:["c1.p3","c3.p3"], highlight:5  },
                    { route:[ "c3.p4", "c2.p3" ], bus:1, highlight:4 },
                    { route:[ "c3.p1", "c3.p2"], highlight:4 },
                    [ "pIn.Valid", "c1.Valid"],
                    [ "pIn.Ready", "c1.Ready"],
                    [ "n7.pIn", "pIn.pIn", 1]
                ]
            }
        ],
        edges: [
            ["input","node_one.in"],
            {source:"node_one.p1", target:"n2.p1", bus:1 },
            {source:"node_one.p2", target:"n3.p1" },
            ["n3.p2", "n4.p1" ],
            ["n4.p2", "n5.p1" ],
            {source:"n5.p2", target:"n6.p1" },
            {source:"n5.p3", target:"n6.p3", bus:1 },
            {route:["n6.p2", "n2.p2" ]},
            {route:["n6.p4", "n2.p4" ], bus:1},
            ["n3.p2", "n7.p1" ],
            ["n7.p2", "n2.p3", 1 ],
            ["n3.p3", "n7.pIn", 1 ]
        ]
    }

    hdelk.layout( graph, "diagram" );

</script>

<div id="simple_diagram"></div>

<div id="just_right_diagram"></div>


<div id="diagram"></div>
