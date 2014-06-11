library Test;

import 'package:Vapor/Vapor.dart';

void main() 
{
    Scene scene = new Scene();
    
    Shader shader = Shader.FromFile("../shaders/white.glsl");
    Material material = new Material(shader);
    
    GameObject camera = GameObject.CreateCamera();
    camera.transform.position = new Vector3(0.0, 0.0, 0.0);
    scene.AddGameObject(camera);
    
    GameObject triangle = GameObject.CreateTriangle();
    triangle.renderer.material = material;
    triangle.transform.position = new Vector3(-1.5, 0.0, 7.0);
    scene.AddGameObject(triangle);
    
    GameObject square = GameObject.CreateQuad();
    square.renderer.material = material;
    square.transform.position = new Vector3(1.5, 0.0, 7.0);
    scene.AddGameObject(square);
}