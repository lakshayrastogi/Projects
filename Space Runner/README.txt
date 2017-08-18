SPACE RUNNER - WebGL 3D Runner Game
Team 14:
Nadir Merchant (ID: 204289925)
Mitchell De Keyser (ID: 304300362)
Lakshay Rastogi (ID: 204303974)

Open space_runner.html to play.

Controls: 
z - jump
x - spin
left arrow - move left
right arrow - move right

Objective:
Gain points by staying alive and colliding with objects that give points (see below)

Gameplay:
Player controls the pyramid with left and right arrows.
Avoid ember-textured cubes.
Spin through cubes with rotating arrows to collect 50 points. If you do not spin when colliding with a "spin cube" you will lose.
Jump to collect cubes with upward scrolling arrows to collect 100 points.

Collecting purple medium-complexity spheres results in 100 points and a slow-down effect for 3 seconds.
Collecting green low-complexity spheres results in 200 points and a speed-up effect for 3 seconds.

10 points are gained every second that player remains alive.

Difficulty increases over time through increased speeds and frequencies of oncoming objects.

Game ends when the pyramid collides with a ember-textured cube, or with a "spin" cube, when the pyramid is not spinning.

Graphics Concepts Used:
Stationary perspective view setup for camera.
Geometries for plane, cube, pyramid, and sphere.
Texture mapping applied to plane, cube, and pyramid.
Point light source placed above main plane.
Phong shading applied to both purple (medium complexity) and green (low complexity) spheres.
Advanced Topic: Collision Detection
Axis Aligned Bounding Box collision detection implemented. Because all game objects are more or less the same size, the same bounding box dimensions are used for each object. Both the x and z axis collision thresholds are 0.5 units while the y-axis threshold is at a more generous 0.4 in order to allow players to more easily jump over obstacles and thus encourage jumping to both dodge and collect objects.