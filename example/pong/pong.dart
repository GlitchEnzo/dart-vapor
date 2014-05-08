library Pong;

import 'dart:html';
import 'dart:math';
import 'package:Vapor/Vapor.dart';

part 'Ball.dart';
part 'Paddle.dart';

void main() 
{
    Scene scene = new Scene();
    
    Shader shader = Shader.FromFile("../shaders/white.glsl");
    Material material = new Material(shader);
    
    GameObject camera = GameObject.CreateCamera();
    camera.transform.position = new Vector3(0.0, 0.0, -7.0);
    scene.AddGameObject(camera);
    
    GameObject paddle1 = GameObject.CreateQuad();
    paddle1.transform.scale = new Vector3(1.0, 2.0, 1.0);
    Paddle paddle1Comp = new Paddle();
    paddle1.AddComponent(paddle1Comp);
    paddle1.renderer.material = material;
    paddle1.transform.position = new Vector3(3.5, 0.0, 0.0);
    scene.AddGameObject(paddle1);
    
    GameObject paddle2 = GameObject.CreateQuad();
    paddle2.transform.scale = new Vector3(1.0, 2.0, 1.0);
    Paddle paddle2Comp = new Paddle();
    paddle2Comp.AI = true;
    paddle2.AddComponent(paddle2Comp);
    paddle2.renderer.material = material;
    paddle2.transform.position = new Vector3(-3.5, 0.0, 0.0);
    scene.AddGameObject(paddle2);
    
    GameObject ball = GameObject.CreateQuad();
    ball.transform.scale = new Vector3(0.5, 0.5, 1.0);
    Ball ballComp = new Ball();
    ballComp.paddle1 = paddle1Comp;
    ballComp.paddle2 = paddle2Comp;
    ball.AddComponent(ballComp);
    ball.renderer.material = material;
    scene.AddGameObject(ball);
    
    paddle2Comp.ball = ballComp;
}