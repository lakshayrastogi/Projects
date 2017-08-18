//perspective/ortho vars
var aspect;
var fovy = 60.0;
var NEAR = 1;
var FAR = 100;

//camera parameters
var horizPos = 0;
var verticalPos = -3.5;
var depthPos = -8;

//Shade Types
var TEX_MAP = 0;
var PHONG = 1;

//GameObject vars
var objList = [];
var SPAWN_Z = -30;
var MIN_X = -7;
var MAX_X = 7;
var obstacleSpeed = 0.3;
var COLL_THRESH_X = 0.5;
var COLL_THRESH_Y = 0.4;
var COLL_THRESH_Z = 0.5;
var gameOver = false;
var maxJumpCubes = 2;
var maxSpinCubes = 2;
var maxCoins = 2;
var maxBlockCubes = 1;
var MAX_OBSTACLES = 5;
var MAX_OBSTACLE_SPEED = 1;
var score = 0;
var slowCoinTimeoutID;
var speedCoinTimeoutID;
var rampScrollSpeed = obstacleSpeed*0.008;
//player vars
var PLAYER_SPEED = 0.5;
var playerJumping = false;
var playerRising = false;
var playerSpinning = false;
var playerRotAngle = 0;
//object type vars
var PLAYER = 0;
var JUMP_CUBE = 1;
var SPIN_CUBE = 2;
var BLOCK_CUBE = 3;
var SLOW_COIN = 4;
var SPEED_COIN = 5;


//***************************************CUBE***************************************//
var len = 0.5
var cubeVertices = [
        vec3(  len,   len, len ), //vertex 0
        vec3(  len,  -len, len ), //vertex 1
        vec3( -len,   len, len ), //vertex 2
        vec3( -len,  -len, len ),  //vertex 3 
        vec3(  len,   len, -len ), //vertex 4
        vec3(  len,  -len, -len ), //vertex 5
        vec3( -len,   len, -len ), //vertex 6
        vec3( -len,  -len, -len )  //vertex 7     
    ];

var texCoords1 = [
    vec2(0, 0),
    vec2(1, 0),
    vec2(1, 1),
    vec2(0, 0),
    vec2(1, 1),
    vec2(0, 1)
];
var texCoords2 = [
    vec2(-0.5, -0.5),
    vec2(1.5, -0.5),
    vec2(1.5, 1.5),
    vec2(-0.5, -0.5),
    vec2(1.5, 1.5),
    vec2(-0.5, 1.5)
];

var cubePointList = [];
var cubeNormList = [];

var texCoordsArrayBlock = [];
var texCoordsArrayJump = [];
var texCoordsArraySpin = [];

//*************************************PYRAMID***************************************//
var pyramidVertices = [
                vec3(len, -len, len), //vertex 0
                vec3(len, -len, -len), //vertex 1
                vec3(-len, -len, -len), //vertex 2
                vec3(-len, -len, len), //vertex 3
                vec3(0, len, 0),  //vertex 4 (top of pyramid)
            ];

var playerPointList = [];
var playerNormList = [];
var texCoordsArrayPlayer = [];

//***************************************SPHERE***************************************//

var sphereRotAngle = 0;
// sphere construction
var spherePointList = [];
var sphereNormList = [];
var sphereIndex = 0;

// core data for sphere
var va = vec4(0.0, 0.0, -1.0,1);
var vb = vec4(0.0, 0.942809, 0.333333, 1);
var vc = vec4(-0.816497, -0.471405, 0.333333, 1);
var vd = vec4(0.816497, -0.471405, 0.333333,1);

var SPEED_COLOR = vec4(0.8, 0.0, 0.8, 1.0);
var SLOW_COLOR = vec4(0.0, 0.6, 0.0, 1.0);
var ambientProduct = [
    mult(vec4(0.4, 0.4, 0.4, 1.0), SPEED_COLOR),
    mult(vec4(0.4, 0.4, 0.4, 1.0), SLOW_COLOR)
];
var diffuseProduct = [
    mult(vec4(0.5, 0.5, 0.5, 1.0), SPEED_COLOR),
    mult(vec4(0.5, 0.5, 0.5, 1.0), SLOW_COLOR)
    ];
var specularProduct = [
    mult(vec4(0.8, 0.8, 0.8, 1.0), SPEED_COLOR),
    mult(vec4(0.8, 0.8, 0.8, 1.0), SLOW_COLOR)
    ];

var shininess = 50;
var lightPosition = vec4(0.0, 5.0, -5.0, 1.0);

//Background Audio
var backgroundAudio;

//Main menu
var main = document.getElementById('main');
var menu = document.getElementById('menu');
var scoreText = document.getElementById('score');
//var canvas = document.getElementById( "gl-canvas");

//hide element from html
function hide(el)
{
    el.style.display = 'none';
}

//show element from html
function show(el)
{
    el.style.display ='block';
}

//when play button is pressed start game
document.querySelectorAll('.play')[0].addEventListener('click', function()
{
    hide(main);
    hide(menu);
    show(scoreText);
    init();
});

function init()
{
    canvas = document.getElementById( "gl-canvas");
    gl = WebGLUtils.setupWebGL( canvas );
    if( !gl ) { alert("WebGL isn't available" ); }
    //  Configure WebGL
    gl.viewport(0, 0, canvas.width, canvas.height);
    aspect = canvas.width / canvas.height;
    gl.clearColor( 0.0, 0.0, 0.0, 0.0 );
    //enable z-buffer
    gl.enable(gl.DEPTH_TEST);
    // initialize shaders
    program = initShaders( gl, "vertex-shader", "fragment-shader" );
    gl.useProgram( program );
    //global time vars
    curTime = 0.0;
    timer = new TimeClass();
    //enable position and normal arrays
    vPosition = gl.getAttribLocation(program, "vPosition");
    gl.enableVertexAttribArray(vPosition);
    vNormal = gl.getAttribLocation(program, "vNormal"); 
    gl.enableVertexAttribArray(vNormal);
    //Load geometry and texture data

    initSphereData();
    initCubeData();
    initPyramidData();
    initBackground();

    lightPositionLoc = gl.getUniformLocation(program, "lightPosition");
    gl.uniform4fv(lightPositionLoc, flatten(lightPosition));
    //set uniform vars
    modelViewMatrixLoc = gl.getUniformLocation(program, "modelViewMatrix");
    projectionMatrixLoc = gl.getUniformLocation(program, "projectionMatrix");
    
    texMapLoc = gl.getUniformLocation(program, "texMap");
    setShadingType(TEX_MAP);
    // set camera position and perspective
    mvMat = mat4();
    projMat = perspective(fovy, aspect, NEAR, FAR);
    gl.uniformMatrix4fv(projectionMatrixLoc, false, flatten(projMat));
    player = new Pyramid(vec3(0, 0, 0));
    //start playing background audio
    playBackgroundAudio();
    setIntervals();
    //alert("Whooosh! Click OK to start")
    timer.reset();
    render();
};

function render() {
    gl.clear( gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    curTime += timer.getTimePassed() / 1000;
    player.display();
    rampScrollSpeed = obstacleSpeed*0.008;
    displayBackground();
    if (!gameOver) {
        for (var i = 0; i < objList.length; i++) {
            var obj = objList[i];
           //if the z position gets larger than 0 its off the screen
            //so we delete the object from the objectlist
            if(obj.center[2] > 4)
            {
                objList.splice(i, 1);
            }
            obj.display();
            if (intersect(player, obj)) {
                var type = obj.objType;
                if (type == BLOCK_CUBE || type == SPIN_CUBE && !playerSpinning) {
                    playCollisionAudio();
                    stopBackgroundAudio();
                    gameOver = true;
                    break;
                }
                else {
                    //make object disappear
                    objList.splice(i, 1);
                    switch (type) {
                        case SPIN_CUBE:
                            updateScore(50);
                            playPointAddedAudio();
                            break;
                        case JUMP_CUBE:
                            //add to score
                            updateScore(100);
                            playPointAddedAudio();
                            break;
                        case SLOW_COIN:
                            obstacleSpeed -=0.2;
                            slowCoinTimeoutID = setTimeout(function() {if (!gameOver) obstacleSpeed += 0.2;}, 3000);
                            updateScore(100);
                            playPowerUpAudio();
                            break;
                        case SPEED_COIN:
                            obstacleSpeed += 0.2;
                            speedCoinTimeoutID = setTimeout(function() {if (!gameOver) obstacleSpeed -= 0.2;}, 3000);
                            updateScore(200);
                            playPowerUpAudio();
                            break;
                    }
                }
            }
        }
    }
    else
        resetGame();
    requestAnimFrame(render);
}
function updateScore(points) {
    score += points;
    scoreText.innerHTML = "Score: "+ score;
}
function setIntervals() {
    generateCubesID = setInterval(generateCubes, 1000);
    generateCoinsID = setInterval(generateCoins, 5000);
    updatePositionsID = setInterval(updatePositions, 50);
    //advance level, make obstacles move faster and clear old obstacles
    advanceLevelID = setInterval(advanceLevel, 15000);
    animateJumpID = setInterval(animateJump, 50);
    animateSpinID = setInterval(animateSpin, 20);
    scoreID = setInterval(incrementScore, 1000);
}

var rampTexArray = [];
var circleTexArray = [];
var starVertices = [];
function initBackground() {
    rampTex = gl.createTexture();
    rampTex.image = new Image();
    rampTex.image.onload = function(){
        gl.bindTexture(gl.TEXTURE_2D, rampTex); 
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, rampTex.image); 
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.REPEAT); 
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT);
        gl.bindTexture(gl.TEXTURE_2D, null);
    }
    rampTex.image.src = "Images/space.jpg";

    squareVertexPositionBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, squareVertexPositionBuffer);
    var vertices = [
            vec3( MAX_X + 1, -1.0,  SPAWN_Z - 50), //correct
            vec3( MIN_X - 1, -1.0,  SPAWN_Z - 50), //correct
            vec3( MIN_X - 1, -1.0,  1.0), //correct
            vec3( MAX_X + 1, -1.0,  SPAWN_Z - 50),
            vec3( MIN_X - 1, -1.0,  1.0),
            vec3( MAX_X + 1, -1.0,  1.0)
    ];
    gl.bufferData(gl.ARRAY_BUFFER, flatten(vertices), gl.STATIC_DRAW);
    gl.vertexAttribPointer(vPosition, 3, gl.FLOAT, false, 0, 0);

    for (var i=0; i < texCoords2.length; i++)
        rampTexArray.push(texCoords2[i]);

    rampBuf = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, rampBuf);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(rampTexArray), gl.STATIC_DRAW);
}

function displayBackground() {

    // setShadingType(PHONG);
    // gl.disableVertexAttribArray(vTexCoord);
    gl.enableVertexAttribArray(vTexCoord);
    setShadingType(TEX_MAP);
    // //bind textures
    gl.activeTexture(gl.TEXTURE0);
    gl.bindTexture(gl.TEXTURE_2D, rampTex);
    //scroll texture
    for (var i = 0; i < rampTexArray.length; i++) {
        //translate x and y components of texture by 0.01 to give scroll effect
        rampTexArray[i] = [rampTexArray[i][0], 
                              (rampTexArray[i][1]-rampScrollSpeed)]

    }
    // bind/load data into buffer
    gl.bindBuffer(gl.ARRAY_BUFFER, rampBuf);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(rampTexArray), gl.STATIC_DRAW);

    gl.uniform1i(textureLoc, 0);
    gl.vertexAttribPointer(vTexCoord, 2, gl.FLOAT, false, 0, 0);


    gl.bindBuffer(gl.ARRAY_BUFFER, squareVertexPositionBuffer);
    gl.vertexAttribPointer(vPosition, 3, gl.FLOAT, false, 0, 0);

    //Set model view
    transMat = mat4();
    transMat = mult(transMat, mvMat);
    //Camera control
    transMat = mult(transMat, translate(horizPos, verticalPos, depthPos))
    //cube1 position
    //transMat = mult(transMat, translate([0.0, 0.0, 0.0]));
    //update modelview matrix in shader
    gl.uniformMatrix4fv(modelViewMatrixLoc, false, flatten(transMat));

    //draw cube on screen
    gl.drawArrays(gl.TRIANGLES, 0, 6);
}

function resetGame() {
    clearInterval(generateCubesID);
    clearInterval(generateCoinsID);
    clearInterval(updatePositionsID);
    clearInterval(advanceLevelID);
    clearInterval(animateJumpID);
    clearInterval(animateSpinID);
    clearInterval(scoreID);
    clearTimeout(slowCoinTimeoutID);
    clearTimeout(speedCoinTimeoutID);
    alert('Game Over! Score: ' + score);
    gameOver = false;
    score = 0;
    scoreText.innerHTML= "Score: 0";
    objList = [];
    player.center = vec3(0,0,0);
    playerJumping = false;
    playerRising = false;
    playerSpinning = false;
    playerRotAngle = 0;
    obstacleSpeed = 0.3;
    maxObstacles = 3;
    maxJumpCubes = 2;
    maxSpinCubes = 2;
    maxCoins = 2;
    maxBlockCubes = 1;
    timer.reset();
    playBackgroundAudio();
    setIntervals();
}
function setShadingType(shadeType) {
    if (shadeType == TEX_MAP) {
        gl.uniform1f(texMapLoc, true);
        gl.uniform1f(phongLoc, false);
        gl.enableVertexAttribArray(vTexCoord);
    }
    else if (shadeType == PHONG) {
        gl.uniform1f(texMapLoc, false);
        gl.uniform1f(phongLoc, true);
        gl.disableVertexAttribArray(vTexCoord);
    }
}

function initCubeData() {
    //initialize geometry for cube
    createCube(texCoordsArrayBlock, texCoords1);
    textureBlock = gl.createTexture();
    textureBlock.image = new Image();
    textureBlock.image.onload = function(){
        gl.bindTexture(gl.TEXTURE_2D, textureBlock); 
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, textureBlock.image); 
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE); 
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
        gl.bindTexture(gl.TEXTURE_2D, null);
    }
    textureBlock.image.src = "Images/Lava Cropped.jpg";

    createCube(texCoordsArraySpin, texCoords1);
    textureSpin = gl.createTexture();
    textureSpin.image = new Image();
    textureSpin.image.onload = function(){
        gl.bindTexture(gl.TEXTURE_2D, textureSpin); 
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, textureSpin.image); 
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE); 
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
        gl.bindTexture(gl.TEXTURE_2D, null);
    }
    textureSpin.image.src = "Images/spin_arrow.png";

    createCube(texCoordsArrayJump, texCoords2);
    textureJump = gl.createTexture();
    textureJump.image = new Image();
    textureJump.image.onload = function(){
        gl.bindTexture(gl.TEXTURE_2D, textureJump); 
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, textureJump.image);     
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR); 
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_LINEAR); 
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.REPEAT); 
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT); 
        gl.generateMipmap(gl.TEXTURE_2D);
        gl.bindTexture(gl.TEXTURE_2D, null);
    }
    textureJump.image.src = "Images/jump_arrow.png";

    //load position and normal buffers
    //position buffer
    vBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, vBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(cubePointList), gl.STATIC_DRAW);
    gl.vertexAttribPointer(vPosition, 3, gl.FLOAT, false, 0, 0);
    
    //normal buffer
    nBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, nBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(cubeNormList), gl.STATIC_DRAW);
    gl.vertexAttribPointer(vNormal, 3, gl.FLOAT, false, 0, 0);

    //texture coordinate buffers
    tBufferBlock = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, tBufferBlock);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(texCoordsArrayBlock), gl.STATIC_DRAW);

    tBufferSpin = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, tBufferSpin);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(texCoordsArraySpin), gl.STATIC_DRAW);
    
    tBufferJump = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, tBufferJump);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(texCoordsArrayJump), gl.STATIC_DRAW);

    vTexCoord = gl.getAttribLocation(program, "vTexCoord");
    textureLoc = gl.getUniformLocation(program, "texture");
    texMapLoc = gl.getUniformLocation(program, "texMap");
}
//gets data points for 6 faces using quad on each face
function createCube(texCoordsArray, texCoords){
    
    quad(0, 1, 2, 3, vec3(0, 0, 1), texCoordsArray, texCoords);
    quad(4, 0, 6, 2, vec3(0, 1, 0), texCoordsArray, texCoords);
    quad(4, 5, 0, 1, vec3(1, 0, 0), texCoordsArray, texCoords);
    quad(2, 3, 6, 7, vec3(1, 0, 1), texCoordsArray, texCoords);
    quad(6, 7, 4, 5, vec3(0, 1, 1), texCoordsArray, texCoords);
    quad(1, 5, 3, 7, vec3(1, 1, 0 ), texCoordsArray, texCoords);
    
}

//adds points needed for each cube face
function quad( v0, v1, v2, v3, norm, texCoordsArray, texCoords){

    var triangleVertices = [v0, v2, v3, v0, v3, v1];
    for ( var i = 0; i < 6; ++i ) {
        cubePointList.push( cubeVertices[triangleVertices[i]] );
        cubeNormList.push(norm);
        texCoordsArray.push(texCoords[i]);
    }
}
function initSphereData() {
    
    //low complexity
    tetrahedron(va, vb, vc, vd, 1, false);
    lowCompIndex = sphereIndex;
    sphereIndex = 0;
    lowPosBuff = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, lowPosBuff);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(spherePointList), gl.STATIC_DRAW);
    lowNormBuff = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, lowNormBuff);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(sphereNormList), gl.STATIC_DRAW);
    spherePointList = [];
    sphereNormList = [];
    
    //medium-high complexity
    tetrahedron(va, vb, vc, vd, 3, true);
    medCompIndex = sphereIndex;
    sphereIndex = 0;
    medPosBuff = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, medPosBuff);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(spherePointList), gl.STATIC_DRAW);
    medNormBuff = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, medNormBuff);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(sphereNormList), gl.STATIC_DRAW);

    //fragment shader uniforms
    fAmbientProductLoc = gl.getUniformLocation(program, "fAmbientProduct");
    fDiffuseProductLoc = gl.getUniformLocation(program, "fDiffuseProduct");
    fSpecularProductLoc = gl.getUniformLocation(program, "fSpecularProduct");
    fShininessLoc = gl.getUniformLocation(program, "fShininess");
    phongLoc = gl.getUniformLocation(program, "phong");


    gl.uniform1f(fShininessLoc, shininess);

}
//sphere generating functions from textbook
function tetrahedron(a, b, c, d, n, isSmooth) {
    divideTriangle(a, b, c, n, isSmooth);
    divideTriangle(d, c, b, n, isSmooth);
    divideTriangle(a, d, b, n, isSmooth);
    divideTriangle(a, c, d, n, isSmooth);
}

function divideTriangle(a, b, c, count, isSmooth) {
    if ( count > 0 ) {
        var ab = normalize(mix(a, b, 0.5), true);
        var ac = normalize(mix(a, c, 0.5), true);
        var bc = normalize(mix(b, c, 0.5), true);                       
        divideTriangle(a, ab, ac, count-1, isSmooth);
        divideTriangle(ab, b, bc, count-1, isSmooth);
        divideTriangle(bc, c, ac, count-1, isSmooth);
        divideTriangle(ab, bc, ac, count-1, isSmooth);
    }
    else { 
        triangle(a, b, c, isSmooth);
    }
}

function triangle(a, b, c, isSmooth) {
    spherePointList.push(a);
    spherePointList.push(b);
    spherePointList.push(c);
    sphereIndex += 3;
    
    //modify normals for correct shading
    if(isSmooth) { //smooth shading
        sphereNormList.push(scale1(-1,a));
        sphereNormList.push(scale1(-1,b));
        sphereNormList.push(scale1(-1,c));
    }
    else { //flat shading
        var norm = vec4(normalize(cross(subtract(b, a), subtract(c, a))));
        sphereNormList.push(norm);
        sphereNormList.push(norm);
        sphereNormList.push(norm);
    }
}

//This function creates the buffer and set up the arrays necessary
//for creation of the player object
function initPyramidData()
{
    createPyramid(texCoordsArrayPlayer, texCoords1);

    texturePlayer = gl.createTexture();
    texturePlayer.image = new Image();
    texturePlayer.image.onload = function(){
        gl.bindTexture(gl.TEXTURE_2D, texturePlayer); 
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, texturePlayer.image); 
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE); 
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
        gl.bindTexture(gl.TEXTURE_2D, null);
    }
    texturePlayer.image.src = "Images/pyramid_texture.jpg";


    //load position and normal buffers
    //position buffer
    playerBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, playerBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(playerPointList), gl.STATIC_DRAW);
    gl.vertexAttribPointer(vPosition, 3, gl.FLOAT, false, 0, 0);
    
    //normal buffer
    nPlayerBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, nPlayerBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(playerNormList), gl.STATIC_DRAW);
    gl.vertexAttribPointer(vNormal, 3, gl.FLOAT, false, 0, 0);

    //texture coordinate buffers
    tBufferPlayer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, tBufferPlayer);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(texCoordsArrayPlayer), gl.STATIC_DRAW);
    //vTexCoord = gl.getAttribLocation(program, "vTexCoord");
    //BUG: This causes spheres to fail to draw for some reason
    //gl.enableVertexAttribArray(vTexCoord);


    textureLoc = gl.getUniformLocation(program, "texture");
    texMapLoc = gl.getUniformLocation(program, "texMap");

}

//adds points needed for each cube face
function quad1( v0, v1, v2, v3, norm, texCoordsArray, texCoords){

    var triangleVertices = [v0, v2, v3, v0, v3, v1];
    for ( var i = 0; i < 6; ++i ) {
        playerPointList.push( pyramidVertices[triangleVertices[i]] );
        playerNormList.push(norm);
        texCoordsArray.push(texCoords[i]);
    }
}

function createPyramid(texCoordsArray ,texCoords)
{  
    quad1(4, 0, 4, 3, vec3(0, 0, 1), texCoordsArray, texCoords);
    //quad(4, 4, 4, 4, vec3(0, 1, 0), texCoordsArray, texCoords);
    quad1(4, 1, 4, 0, vec3(1, 0, 0), texCoordsArray, texCoords);
    quad1(4, 3, 4, 2, vec3(1, 0, 1), texCoordsArray, texCoords);
    quad1(4, 2, 4, 1, vec3(0, 1, 1), texCoordsArray, texCoords);
    quad1(0, 1, 2, 3, vec3(1, 1, 0 ), texCoordsArray, texCoords);  //base of pyramid
}

function generateCubes() {
    var cubeList = [];

    //generate block-cubes
    var blockIntersect = false;
    var blockCube = new Cube(vec3(randNum(MIN_X, MAX_X),0,SPAWN_Z), BLOCK_CUBE);
    cubeList.push(blockCube);
    for (var i = 0; i < randNum(1, maxBlockCubes); i++) {
        var blockCube = new Cube(vec3(randNum(MIN_X, MAX_X),0,SPAWN_Z), BLOCK_CUBE);
        for (var k = 0; k < cubeList.length; k++) {
            if (blockIntersect)
                break;
            if (intersect(blockCube, cubeList[k]))
                blockIntersect = true;
        }
        if (!blockIntersect)
            cubeList.push(blockCube);
    }
    if (randNum(0,1) > 0.5) {
        //generate jump-cubes
        var jumpIntersect = false;
        for (var i = 0; i < randNum(1, maxJumpCubes); i++) {
            jumpCube = new Cube(vec3(randNum(MIN_X, MAX_X),randNum(1, 2),SPAWN_Z), JUMP_CUBE);
            for (var k = 0; k < cubeList.length; k++) {
                if (jumpIntersect)
                    break;
                if (intersect(jumpCube, cubeList[k]))
                    jumpIntersect = true;
            }
            if (!jumpIntersect)
                cubeList.push(jumpCube);
        }
    }
    if (randNum(0, 1) > 0.5) {
        //generate spin-cubes
        var spinIntersect = false;
        for (var i = 0; i < randNum(1, maxSpinCubes); i++) {
            var spinCube = new Cube(vec3(randNum(MIN_X, MAX_X),0,SPAWN_Z), SPIN_CUBE);
            for (var k = 0; k < cubeList.length; k++) {
                if (spinIntersect)
                    break;
                if (intersect(spinCube, cubeList[k]))
                    spinIntersect = true;
            }
            if (!spinIntersect)
                cubeList.push(spinCube);
        }
    }
    objList = objList.concat(cubeList);
}

function generateCoins() {
    
    var coinList = [];
    if (randNum(0,1) > 0.5) {
        var slowCoinIntersect = false;
        var coin = new Sphere(vec3(randNum(MIN_X, MAX_X),0,SPAWN_Z), SLOW_COIN);
        coinList.push(coin);
        for (var i = 0; i < randNum(1, maxCoins-1); i++) {
            coin = new Sphere(vec3(randNum(MIN_X, MAX_X),0,SPAWN_Z), SLOW_COIN);
            for (var k = 0; k < coinList.length; k++) {
                if (slowCoinIntersect)
                    break;
                if (intersect(coin, coinList[k]))
                    slowCoinIntersect = true;
            }
            if (!slowCoinIntersect)
                coinList.push(coin);
        } 
    }
    if (randNum(0,1) > 0.5) {
        var speedCoinIntersect = false;
        for (var i = 0; i < randNum(1, maxCoins); i++) {
            var coin = new Sphere(vec3(randNum(MIN_X, MAX_X),0,SPAWN_Z), SPEED_COIN);
            for (var k = 0; k < coinList.length; k++) {
                if (speedCoinIntersect)
                    break;
                if (intersect(coin, coinList[k]))
                    speedCoinIntersect = true;
            }
            if (!speedCoinIntersect)
                coinList.push(coin);
        } 
    }
    objList = objList.concat(coinList);
}

function updatePositions() {
    for (var i = 0; i < objList.length; i++) {
        objList[i].center[2] += obstacleSpeed;
    }
}

function incrementScore() {
    updateScore(10);
}

function updateObjectGenerationTimers() {
    clearInterval(generateCubesID);
    clearInterval(generateCoinsID);
    generateCubesID = setInterval(generateCubes, 1300-1000*obstacleSpeed); //300/obstacleSpeed
    generateCoinsID = setInterval(generateCoins, 5300-1000*obstacleSpeed); //1500/obstacleSpeed
}
function advanceLevel() {
    //objList = [];
    if (!gameOver){
        if (maxBlockCubes < MAX_OBSTACLES) {
            maxBlockCubes += 1;
        }
        if (obstacleSpeed < MAX_OBSTACLE_SPEED) {
            obstacleSpeed += 0.1;
        }
        updateObjectGenerationTimers();
    }
}
function playerJump() {
    playerJumping = true;
    playerRising = true;
}
function animateJump() {
    if (playerJumping) {
        if (player.center[1] <= 2 && playerRising)
            if (player.center[1] >= 1.9)
                player.center[1] += 0.05;
            else
                player.center[1] += 0.25;
        else {
            playerRising = false;
            if (player.center[1] >= 1.9)
                player.center[1] -= 0.05;
            else
                player.center[1] -= 0.25;
        }
        if (player.center[1] <= 0) {
            player.center[1] = 0;
            playerJumping = false;
        }
    }
}
function playerSpin() {
    playerSpinning = true;
}
function animateSpin() {
    if (playerSpinning) {
        playerRotAngle += 6;
        if (playerRotAngle > 0 && playerRotAngle <= 360)
            playerRotAngle += 6;
        else {
            playerRotAngle = 0;
            playerSpinning = false;
        }
    }
}

function randNum(min, max) {
    if (max < min) return -1;
    else return Math.random() * (max - min) + min;
}

function intersect(a, b) {
     // Exit if separated along an axis
     if ( a.center[0]+COLL_THRESH_X < b.center[0]-COLL_THRESH_X || 
          a.center[0]-COLL_THRESH_X > b.center[0]+COLL_THRESH_X ||
          a.center[1]+COLL_THRESH_Y < b.center[1]-COLL_THRESH_Y || 
          a.center[1]-COLL_THRESH_Y > b.center[1]+COLL_THRESH_Y ||
          a.center[2]+COLL_THRESH_Z < b.center[2]-COLL_THRESH_Z || 
          a.center[2]-COLL_THRESH_Z > b.center[2]+COLL_THRESH_Z  ) 
        return 0;
    // Overlapping on all axes means there is an intersection
     return 1;
};
//CLASSES
var TimeClass = function() {
  this.lastTime = 0;
};
TimeClass.prototype.reset = function() {
  this.lastTime = (new Date()).getTime();
};
TimeClass.prototype.getTimePassed = function() {
  var timePassed = (new Date()).getTime() - this.lastTime;
  this.lastTime += timePassed;
  return timePassed;
};

var GameObject = function (center, objType) {
    this.center = center;
    this.objType = objType;
};
GameObject.prototype.display = function() {
    //console.log("display GameObject");
};

var Cube = function (center, cubeType) {
    GameObject.call(this, center, cubeType);
};
Cube.prototype = Object.create(GameObject.prototype);
Cube.prototype.constructor = Cube;
Cube.prototype.display = function() {
    gl.enableVertexAttribArray(vTexCoord);
    setShadingType(TEX_MAP);
    //bind textures
    gl.activeTexture(gl.TEXTURE0);
    if (this.objType == BLOCK_CUBE) {
        gl.bindTexture(gl.TEXTURE_2D, textureBlock);
        gl.bindBuffer(gl.ARRAY_BUFFER, tBufferBlock);
    }
    
    else if (this.objType == SPIN_CUBE) {
        gl.bindTexture(gl.TEXTURE_2D, textureSpin);
        var rotTexArr = texCoordsArraySpin.slice();
        //apply rotation to texture array
        var rotAngle = radians(curTime*90) //15 rpm
        for (var i = 0; i < rotTexArr.length; i++) {
            //translate coordinates back 0.5 to rotate around proper axis
            var xVal = rotTexArr[i][0]-0.5;
            var yVal = rotTexArr[i][1]-0.5;
            //do rotation and translate back to original location
            rotTexArr[i] = [( xVal*Math.cos(rotAngle)+yVal*Math.sin(rotAngle)+0.5),
                            (-xVal*Math.sin(rotAngle)+yVal*Math.cos(rotAngle)+0.5)];
        }
        // bind/load data into buffer
        gl.bindBuffer(gl.ARRAY_BUFFER, tBufferSpin);
        gl.bufferData(gl.ARRAY_BUFFER, flatten(rotTexArr), gl.STATIC_DRAW);
    }
    else if (this.objType == JUMP_CUBE) {
        gl.bindTexture(gl.TEXTURE_2D, textureJump);
        for (var i = 0; i < texCoordsArrayJump.length; i++) {
            //translate x and y components of texture by 0.01 to give scroll effect
            texCoordsArrayJump[i] = [texCoordsArrayJump[i][0], 
                                  (texCoordsArrayJump[i][1]+0.01)]

        }
        // bind/load data into buffer
        gl.bindBuffer(gl.ARRAY_BUFFER, tBufferJump);
        gl.bufferData(gl.ARRAY_BUFFER, flatten(texCoordsArrayJump), gl.STATIC_DRAW);
    }
   
    gl.uniform1i(textureLoc, 0);
    gl.vertexAttribPointer(vTexCoord, 2, gl.FLOAT, false, 0, 0);
    
    gl.bindBuffer(gl.ARRAY_BUFFER, vBuffer);
    gl.vertexAttribPointer(vPosition, 3, gl.FLOAT, false, 0, 0);
    gl.bindBuffer(gl.ARRAY_BUFFER, nBuffer);
    gl.vertexAttribPointer(vNormal, 3, gl.FLOAT, false, 0, 0);

    //Set model view
    transMat = mat4();
    transMat = mult(transMat, mvMat);
    //Camera control
    transMat = mult(transMat, translate(horizPos, verticalPos, depthPos))
    //cube1 position
    transMat = mult(transMat, translate(this.center));
    //update modelview matrix in shader
    gl.uniformMatrix4fv(modelViewMatrixLoc, false, flatten(transMat));

    //draw cube on screen
    gl.drawArrays( gl.TRIANGLES, 0, 36 );
};

var Sphere = function(center, sphereType) {
    GameObject.call(this, center, sphereType);
};

Sphere.prototype = Object.create(GameObject.prototype);
Sphere.prototype.constructor = Sphere;
Sphere.prototype.display = function() {
    var index = 0;
    setShadingType(PHONG);
    gl.enableVertexAttribArray(vPosition);
    gl.enableVertexAttribArray(vNormal);

    if (this.objType == SLOW_COIN) {
        gl.uniform4fv(fAmbientProductLoc, flatten(ambientProduct[0]));
        gl.uniform4fv(fDiffuseProductLoc, flatten(diffuseProduct[0]));
        gl.uniform4fv(fSpecularProductLoc, flatten(specularProduct[0]));
        gl.bindBuffer(gl.ARRAY_BUFFER, medPosBuff);
        gl.vertexAttribPointer(vPosition, 4, gl.FLOAT, false, 0, 0);
        gl.bindBuffer(gl.ARRAY_BUFFER, medNormBuff);
        gl.vertexAttribPointer(vNormal, 4, gl.FLOAT, false, 0, 0);
        index = medCompIndex;
    }
    else if (this.objType == SPEED_COIN) {
        gl.uniform4fv(fAmbientProductLoc, flatten(ambientProduct[1]));
        gl.uniform4fv(fDiffuseProductLoc, flatten(diffuseProduct[1]));
        gl.uniform4fv(fSpecularProductLoc, flatten(specularProduct[1]));
        gl.bindBuffer(gl.ARRAY_BUFFER, lowPosBuff);
        gl.vertexAttribPointer(vPosition, 4, gl.FLOAT, false, 0, 0);
        gl.bindBuffer(gl.ARRAY_BUFFER, lowNormBuff);
        gl.vertexAttribPointer(vNormal, 4, gl.FLOAT, false, 0, 0);
        index = lowCompIndex;
    }
    sphereRotAngle = sphereRotAngle%360 + 1;
    //Set model view
    transMat = mat4();
    transMat = mult(transMat, mvMat);
    //Camera control
    transMat = mult(transMat, translate(horizPos, verticalPos, depthPos))
    transMat = mult(transMat, translate(this.center));
    transMat = mult(transMat, rotate(sphereRotAngle, [0, 1, 0]));
    transMat = mult(transMat, scale(vec3(0.5,0.5,0.5)));
    //update modelview matrix in shader
    gl.uniformMatrix4fv(modelViewMatrixLoc, false, flatten(transMat));
    for (var i = 0; i < index; i+=3) {
        gl.drawArrays(gl.TRIANGLES, i, 3);
    }
};

var Pyramid = function (center) {
    GameObject.call(this, center, PLAYER);
};
Pyramid.prototype = Object.create(GameObject.prototype);
Pyramid.prototype.constructor = Pyramid;
Pyramid.prototype.display = function() {
     //Player object - cube
    //bind texture 
    setShadingType(TEX_MAP);
    gl.bindBuffer(gl.ARRAY_BUFFER, tBufferPlayer);
    gl.vertexAttribPointer(vTexCoord, 2, gl.FLOAT, false, 0, 0);

    gl.bindBuffer(gl.ARRAY_BUFFER, playerBuffer);
    gl.vertexAttribPointer(vPosition, 3, gl.FLOAT, false, 0, 0);
    
    gl.bindBuffer(gl.ARRAY_BUFFER, nPlayerBuffer);
    gl.vertexAttribPointer(vNormal, 3, gl.FLOAT, false, 0, 0);
    
    //Set model view
    transMat = mat4();
    transMat = mult(transMat, mvMat);
    //Camera control
    transMat = mult(transMat, translate(horizPos, verticalPos, depthPos))
    //player position
    transMat = mult(transMat, translate(this.center));
    transMat = mult(transMat, rotate(playerRotAngle, 0, 1, 0));
    //update modelview matrix in shader
    gl.uniformMatrix4fv(modelViewMatrixLoc, false, flatten(transMat));
    //bind texture1
    gl.activeTexture(gl.TEXTURE0);
    gl.bindTexture(gl.TEXTURE_2D, texturePlayer);
    gl.uniform1i(textureLoc, 0)
    //draw cube on screen
    gl.drawArrays( gl.TRIANGLES, 0, 30 );
};

function playSpinAudio()
{
    var audio = new Audio('Sounds/spin.mp3');
    audio.play();
}

function playJumpAudio()
{
    var audio = new Audio('Sounds/jump.mp3');
    audio.play();
}

function playCollisionAudio()
{
    var audio = new Audio('Sounds/hit.mp3');
    audio.play();
}

function playPointAddedAudio()
{
    var audio = new Audio('Sounds/clink_sound.mp3');
    audio.play();
}

function playPowerUpAudio()
{
    var audio = new Audio('Sounds/power_up.mp3');
    audio.play();
}

function playBackgroundAudio()
{
    backgroundAudio = new Audio('Sounds/background.mp3');
    backgroundAudio.addEventListener('ended', function(){
        this.currentTime = 0;
        this.play();
    },false);
    backgroundAudio.play();
}

function stopBackgroundAudio()
{
    backgroundAudio.pause();
    backgroundAudio.currentTime = 0;
}

//key input events
window.onkeydown = function(event) {
    var key = event.keyCode ? event.keyCode : event.which;
    switch (key) {
        case 37:
            if (player.center[0] > -7) {
                player.center[0] -= PLAYER_SPEED;
            }
            break;
        case 39:
            if (player.center[0] < 7) {
                player.center[0] += PLAYER_SPEED;
            }
            break;
        case 88:
            if (!playerSpinning) {
                playerSpin();
                playSpinAudio();
            }
            
            break;
        case 90:
            if (!playerJumping) {
                playerJump();
                playJumpAudio();
            }
            break;
    }
}
