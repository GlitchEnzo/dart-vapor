library OrbitalGolf;

//import 'dart:math' as Math;

import 'package:vapor/vapor.dart';
import 'package:box2d/box2d.dart' as Box2D;

part 'ApplyGravity.dart';
part 'Ball.dart';
part 'Planet.dart';
part 'PlanetManager.dart';

/**
 * Global reference to the current scene.
 */
Scene scene;

Box2D.World predictWorld;

/**
 * Global list of planets currently in the scene.
 */
List<Planet> planets = new List();

Material whiteMaterial;
Material blueMaterial;
Material greenMaterial;
Material checkerboardMaterial;

int currentLevel = 1;
int maxLevel = 3;

Texture2D checkerboard;

void main() 
{    
    querySelector("#prev").onClick.listen(onPrevClicked);
    querySelector("#prev").onTouchStart.listen(onPrevTouched);
    querySelector("#next").onClick.listen(onNextClicked);
    querySelector("#next").onTouchStart.listen(onNextTouched);
    querySelector("#fullscreen").onClick.listen(onFullscreenClicked);
    querySelector("#fullscreen").onTouchStart.listen(onFullscreenTouched);
    
    scene = new Scene();
    
    checkerboard = new Texture2D("../textures/checkerboard.png");
    checkerboard.LoadedCallback = LoadedCallback;
    
    Shader whiteShader = Shader.FromFile("../shaders/white.glsl");
    whiteMaterial = new Material(whiteShader);
    
    Shader blueShader = Shader.FromFile("../shaders/colored.glsl");
    blueMaterial = new Material(blueShader);
    blueMaterial.SetVector("uMainColor", Color.Blue);
    
    Shader greenShader = Shader.FromFile("../shaders/colored.glsl");
    greenMaterial = new Material(greenShader);
    greenMaterial.SetVector("uMainColor", Color.Green);
    
    Shader checkerboardShader = Shader.FromFile("../shaders/textured.glsl");
    checkerboardMaterial = new Material(checkerboardShader);
    
    LoadLevel1();
}

void LoadedCallback(Texture2D texture)
{
    checkerboardMaterial.SetTexture("uMainTexture", texture);
}

void onPrevClicked(MouseEvent event)
{
    currentLevel--;
    if (currentLevel <= 0)
    {
        currentLevel = maxLevel;
    }
    LoadLevel(currentLevel);
}

void onPrevTouched(TouchEvent event)
{
    currentLevel--;
    if (currentLevel <= 0)
    {
        currentLevel = maxLevel;
    }
    LoadLevel(currentLevel);
}

void onNextClicked(MouseEvent event)
{
    currentLevel++;
    if (currentLevel > maxLevel)
    {
        currentLevel = 1;
    }
    LoadLevel(currentLevel);
}

void onNextTouched(TouchEvent event)
{
    currentLevel++;
    if (currentLevel > maxLevel)
    {
        currentLevel = 1;
    }
    LoadLevel(currentLevel);
}

void onFullscreenClicked(MouseEvent event)
{
    if (document.fullscreenEnabled)
    {
        if (document.fullscreenElement == null)
        {
            document.body.requestFullscreen();
        }
        else
        {
            document.exitFullscreen();
        }
    }
    else
    {
        window.console.log("Fullscreen not supported!");
    }
}

void onFullscreenTouched(TouchEvent event)
{
    if (document.fullscreenEnabled)
    {
        if (document.fullscreenElement == null)
        {
            document.body.requestFullscreen();
        }
        else
        {
            document.exitFullscreen();
        }
    }
    else
    {
        window.console.log("Fullscreen not supported!");
    }
}

void LoadLevel(int index)
{
    switch (index)
    {
        case 1:
            LoadLevel1();
            break;
        case 2:
            LoadLevel2();
            break;
        case 3:
            LoadLevel3();
            break;
    }
}

void ClonePhysicsWorld()
{
    predictWorld = new Box2D.World(new Vector2(0.0, 0.0), true, new Box2D.DefaultWorldPool());
    
    // clone the planets
    for (Planet planet in planets)
    {
        predictWorld.createBody(planet.gameObject.collider.BodyDefinition);
    }
}

GameObject CreatePlanet(double radius, Material material, Vector3 position)
{
    GameObject planetObject = GameObject.CreateCircle(radius, 40);
    planetObject.renderer.material = material;
    planetObject.transform.position = position;
    
    CircleCollider circleCollider = new CircleCollider();
    circleCollider.radius = radius;
    circleCollider.bodyType = Box2D.BodyType.STATIC;
    planetObject.AddComponent(circleCollider);
    
    Planet planet = new Planet();
    planet.surfaceGravity *= radius; // make the gravity relative to the radius 
    planetObject.AddComponent(planet);
    
    planets.add(planet);
    
    scene.AddGameObject(planetObject);
    
    return planetObject;
}

void LoadLevel1()
{
    querySelector("#hits").text = "0 hits";
    querySelector("#win").text = "";
    planets.clear();
    scene.Clear();
    
    GameObject camera = GameObject.CreateCamera();
    camera.transform.position = new Vector3(0.0, 0.0, -15.0);
    camera.camera.backgroundColor = Color.SolidBlack;
    scene.AddGameObject(camera);
    
    GameObject boxObject = GameObject.CreateQuad();
    boxObject.AddComponent(new BoxCollider());
    boxObject.renderer.material = blueMaterial;
    boxObject.transform.position = new Vector3(-3.5, 0.0, 0.0);
    boxObject.AddComponent(new ApplyGravity());
    scene.AddGameObject(boxObject);
    
    GameObject ballObject = GameObject.CreateCircle(0.5, 35);
    ballObject.renderer.material = greenMaterial;
    ballObject.transform.position = new Vector3(-3.0, 2.0, 0.0);
    CircleCollider circle = new CircleCollider();
    circle.radius = 0.5;
    ballObject.AddComponent(circle);
    Ball ball = new Ball();
    ball.lineMaterial = whiteMaterial;
    ballObject.AddComponent(ball);
    ballObject.AddComponent(new ApplyGravity());
    scene.AddGameObject(ballObject);
    
    CreatePlanet(2.0, blueMaterial, new Vector3(0.0, 0.0, 0.0));
    
    // create goal
    GameObject goalObject = GameObject.CreateCircle(0.5, 35);
    goalObject.renderer.material = checkerboardMaterial;
    goalObject.transform.position = new Vector3(6.5, 3.0, 0.0);
    CircleCollider circleCollider = new CircleCollider();
    circleCollider.radius = 0.5;
    circleCollider.bodyType = Box2D.BodyType.STATIC;
    circleCollider.isSensor = true;
    goalObject.AddComponent(circleCollider);
    scene.AddGameObject(goalObject);
}

void LoadLevel2()
{
    querySelector("#hits").text = "0 hits";
    querySelector("#win").text = "";
    planets.clear();
    scene.Clear();
    
    GameObject camera = GameObject.CreateCamera();
    camera.transform.position = new Vector3(0.0, 0.0, -15.0);
    camera.camera.backgroundColor = Color.SolidBlack;
    scene.AddGameObject(camera);
    
    GameObject boxObject = GameObject.CreateQuad();
    boxObject.AddComponent(new BoxCollider());
    boxObject.renderer.material = blueMaterial;
    boxObject.transform.position = new Vector3(-3.5, 0.0, 0.0);
    boxObject.AddComponent(new ApplyGravity());
    scene.AddGameObject(boxObject);
    
    GameObject ballObject = GameObject.CreateCircle(0.5, 35);
    ballObject.renderer.material = greenMaterial;
    ballObject.transform.position = new Vector3(-3.0, 2.0, 0.0);
    CircleCollider circle = new CircleCollider();
    circle.radius = 0.5;
    ballObject.AddComponent(circle);
    Ball ball = new Ball();
    ball.lineMaterial = whiteMaterial;
    ballObject.AddComponent(ball);
    ballObject.AddComponent(new ApplyGravity());
    scene.AddGameObject(ballObject);
    
    CreatePlanet(1.0, blueMaterial, new Vector3(4.0, 3.0, 0.0));
    CreatePlanet(1.0, blueMaterial, new Vector3(4.0, -3.0, 0.0));
    
    // create goal
    GameObject goalObject = GameObject.CreateCircle(0.5, 35);
    goalObject.renderer.material = checkerboardMaterial;
    goalObject.transform.position = new Vector3(6.5, 3.0, 0.0);
    CircleCollider circleCollider = new CircleCollider();
    circleCollider.radius = 0.5;
    circleCollider.bodyType = Box2D.BodyType.STATIC;
    circleCollider.isSensor = true;
    goalObject.AddComponent(circleCollider);
    scene.AddGameObject(goalObject);
}

void LoadLevel3()
{
    querySelector("#hits").text = "0 hits";
    querySelector("#win").text = "";
    planets.clear();
    scene.Clear();
    
    GameObject camera = GameObject.CreateCamera();
    camera.transform.position = new Vector3(0.0, 0.0, -15.0);
    camera.camera.backgroundColor = Color.SolidBlack;
    scene.AddGameObject(camera);
    
    GameObject boxObject = GameObject.CreateQuad();
    boxObject.AddComponent(new BoxCollider());
    boxObject.renderer.material = blueMaterial;
    boxObject.transform.position = new Vector3(-3.5, 0.0, 0.0);
    boxObject.AddComponent(new ApplyGravity());
    scene.AddGameObject(boxObject);
    
    GameObject ballObject = GameObject.CreateCircle(0.5, 35);
    ballObject.renderer.material = greenMaterial;
    ballObject.transform.position = new Vector3(-3.0, 2.0, 0.0);
    CircleCollider circle = new CircleCollider();
    circle.radius = 0.5;
    ballObject.AddComponent(circle);
    Ball ball = new Ball();
    ball.lineMaterial = whiteMaterial;
    ballObject.AddComponent(ball);
    ballObject.AddComponent(new ApplyGravity());
    scene.AddGameObject(ballObject);
    
    CreatePlanet(1.0, blueMaterial, new Vector3(4.0, 3.0, 0.0));
    CreatePlanet(1.0, blueMaterial, new Vector3(-4.0, -3.0, 0.0));
    CreatePlanet(2.0, blueMaterial, new Vector3(0.0, 0.0, 0.0));
    
    // create goal
    GameObject goalObject = GameObject.CreateCircle(0.5, 35);
    goalObject.renderer.material = checkerboardMaterial;
    goalObject.transform.position = new Vector3(6.5, 3.0, 0.0);
    CircleCollider circleCollider = new CircleCollider();
    circleCollider.radius = 0.5;
    circleCollider.bodyType = Box2D.BodyType.STATIC;
    circleCollider.isSensor = true;
    goalObject.AddComponent(circleCollider);
    scene.AddGameObject(goalObject);
}