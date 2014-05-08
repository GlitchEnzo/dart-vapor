library Spacewar;

import 'package:Vapor/Vapor.dart';

import 'dart:math' as Math;

part 'Asteroid.dart';
part 'AsteroidManager.dart';
part 'Bullet.dart';
part 'Rand.dart';
part 'Ship.dart';

/**
 * Global asteroid manager.
 */
AsteroidManager asteroidManager;

/**
 * Global score.
 */
int score = 0;

/**
 * Global number of bullets currently in the scene.
 */
int bulletCount = 0;

/**
 * Global reference to the player ship.
 */
Ship ship;

void main() 
{
    Scene scene = new Scene();
    
    Shader whiteShader = Shader.FromFile("../shaders/white.glsl");
    Material whiteMaterial = new Material(whiteShader);
    
    Shader coloredShader = Shader.FromFile("../shaders/colored.glsl");
    Material coloredMaterial = new Material(coloredShader);
    
    GameObject camera = GameObject.CreateCamera();
    camera.transform.position = new Vector3(0.0, 0.0, -15.0);
    camera.camera.backgroundColor = Color.SolidBlack;
    scene.AddGameObject(camera);
    
    GameObject shipObj = GameObject.CreateTriangle();
    //ship1Obj.transform.scale = new Vector3(1.0, 1.0, 1.0);
    ship = new Ship();
    ship.bulletMaterial = whiteMaterial;
    shipObj.AddComponent(ship);
    shipObj.renderer.material = coloredMaterial;
    shipObj.renderer.material.SetVector("uMainColor", Color.Blue);
    shipObj.transform.position = new Vector3(-3.5, 0.0, 0.0);
    scene.AddGameObject(shipObj);
    
    GameObject manager = new GameObject();
    asteroidManager = new AsteroidManager();
    asteroidManager.material = whiteMaterial;
    manager.AddComponent(asteroidManager);
    scene.AddGameObject(manager);
    
//    GameObject paddle2 = GameObject.CreateQuad();
//    paddle2.transform.scale = new Vector3(1.0, 2.0, 1.0);
//    Paddle paddle2Comp = new Paddle();
//    paddle2Comp.AI = true;
//    paddle2.AddComponent(paddle2Comp);
//    paddle2.renderer.material = material;
//    paddle2.transform.position = new Vector3(3.5, 0.0, -7.0);
//    scene.AddGameObject(paddle2);
//    
//    GameObject ball = GameObject.CreateQuad();
//    ball.transform.scale = new Vector3(0.5, 0.5, 1.0);
//    Ball ballComp = new Ball();
//    ballComp.paddle1 = paddle1Comp;
//    ballComp.paddle2 = paddle2Comp;
//    ball.AddComponent(ballComp);
//    ball.renderer.material = material;
//    ball.transform.position = new Vector3(0.0, 0.0, -7.0);
//    scene.AddGameObject(ball);
//    
//    paddle2Comp.ball = ballComp;
}