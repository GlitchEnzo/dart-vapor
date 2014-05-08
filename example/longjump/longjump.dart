library LongJump;

import 'dart:math' as Math;

import 'package:vapor/vapor.dart';
import 'package:box2d/box2d.dart' as Box2D;

part 'car.dart';
part 'follow_object.dart';
//part 'ramp_collider.dart';

/**
 * Global reference to the current scene.
 */
Scene scene;

/**
 * Global reference to the current car object.
 */
GameObject carObject;

GameObject wheel1;
GameObject wheel2;

Material whiteMaterial;
Material blueMaterial;
Material greenMaterial;
Material checkerboardMaterial;

Texture2D checkerboard;

void main() 
{
    querySelector("#reset").onClick.listen(onResetClicked);
    querySelector("#reset").onTouchStart.listen(onResetClicked);
    querySelector("#fullscreen").onClick.listen(onFullscreenClicked);
    querySelector("#fullscreen").onTouchStart.listen(onFullscreenClicked);
    
    scene = new Scene();
    
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
    
    checkerboard = new Texture2D("../textures/checkerboard.png");
    checkerboard.LoadedCallback = LoadedCallback;
    
    LoadLevel1();
}

void LoadedCallback(Texture2D texture)
{
    checkerboardMaterial.SetTexture("uMainTexture", texture);
}

void onFullscreenClicked(event)
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

void onResetClicked(event)
{
    //querySelector("#distance").text = "0 meters";
    carObject.transform.position = new Vector3(5.0, 3.0, 0.0);
    carObject.rigidbody.body.awake = true;
    
    wheel1.transform.position = new Vector3(5.0, 2.0, 0.0);
    wheel2.transform.position = new Vector3(7.0, 2.0, 0.0);
}

void LoadLevel1()
{
    //querySelector("#distance").text = "0 meters";
    scene.Clear();
    
    GameObject camera = GameObject.CreateCamera();
    camera.transform.position = new Vector3(0.0, 0.0, -15.0);
    camera.camera.backgroundColor = Color.CornflowerBlue;
    scene.AddGameObject(camera);
    
    carObject = GameObject.CreateQuad();
    carObject.name = "carObject";
    carObject.AddComponent(new RigidBody());
    carObject.AddComponent(new BoxCollider());
    carObject.AddComponent(new Car());
    carObject.renderer.material = blueMaterial;
    carObject.transform.position = new Vector3(5.0, 3.0, 0.0);
    scene.AddGameObject(carObject);
    
    //GameObject carPiece1 = GameObject.CreateCircle(0.5);
    GameObject carPiece1 = GameObject.CreateQuad();
    carPiece1.name = "carPiece1";
    BoxCollider carPiece1Collider = new BoxCollider();
    //CircleCollider carPiece1Collider = new CircleCollider();
    carPiece1Collider.center = new Vector2(1.0, 0.0);
    carPiece1.AddComponent(carPiece1Collider);
    carPiece1.renderer.material = whiteMaterial;
    carObject.AddChild(carPiece1);
    scene.AddGameObject(carPiece1);
    
    GameObject carPiece2 = GameObject.CreateQuad();
    carPiece2.name = "carPiece2";
    BoxCollider carPiece2Collider = new BoxCollider();
    carPiece2Collider.center = new Vector2(2.0, 0.0);
    carPiece2.AddComponent(carPiece2Collider);
    carPiece2.renderer.material = blueMaterial;
    carObject.AddChild(carPiece2);
    scene.AddGameObject(carPiece2);
    
    wheel1 = GameObject.CreateCircle(0.5);
    wheel1.name = "wheel1";
    wheel1.AddComponent(new RigidBody());
    wheel1.AddComponent(new CircleCollider(0.5));
    wheel1.renderer.material = whiteMaterial;
    wheel1.transform.position = new Vector3(5.0, 2.0, 0.0);
    RevoluteJoint wheel1Joint = new RevoluteJoint();
    wheel1Joint.connectedRigidBody = carObject.rigidbody;
    wheel1Joint.anchor = wheel1.transform.position.xy;
    wheel1.AddComponent(wheel1Joint);
    scene.AddGameObject(wheel1);
    
    wheel2 = GameObject.CreateCircle(0.5);
    wheel2.name = "wheel2";
    wheel2.AddComponent(new RigidBody());
    wheel2.AddComponent(new CircleCollider(0.5));
    wheel2.renderer.material = whiteMaterial;
    wheel2.transform.position = new Vector3(7.0, 2.0, 0.0);
    RevoluteJoint wheel2Joint = new RevoluteJoint();
    wheel2Joint.connectedRigidBody = carObject.rigidbody;
    wheel2Joint.anchor = wheel2.transform.position.xy;
    wheel2.AddComponent(wheel2Joint);
    scene.AddGameObject(wheel2);
    
    // make markers for every 10 meters
    BuildMarkers(50);
    
    // make the ground 1 km long (10 * 100m)
    BuildGround(10);
    
    FollowObject follow = new FollowObject();
    follow.target = carPiece1;
    camera.AddComponent(follow);
    
    GameObject rampObject = GameObject.CreateQuad();
    rampObject.renderer.material = checkerboardMaterial;
    rampObject.transform.position = new Vector3(0.0, 0.5, 0.0);
    rampObject.transform.scale = new Vector3(3.0, 1.0, 1.0);
    rampObject.transform.eulerAngles = new Vector3(0.0, 0.0, -Math.PI / 6.0); //30 degree slant
    rampObject.AddComponent(new RigidBody(Box2D.BodyType.STATIC));
    BoxCollider ramp = new BoxCollider();
    ramp.size = rampObject.transform.scale.xy;
    rampObject.AddComponent(ramp);
    scene.AddGameObject(rampObject);
}

void BuildGround(int groundPieces)
{
    double startX = 40.0;
    
    GameObject leftWallObject = GameObject.CreateQuad();
    leftWallObject.renderer.material = greenMaterial;
    leftWallObject.transform.position = new Vector3(startX, 50.0, 0.0);
    leftWallObject.transform.scale = new Vector3(1.0, 100.0, 1.0);
    leftWallObject.AddComponent(new RigidBody(Box2D.BodyType.STATIC));
    BoxCollider leftWall = new BoxCollider();
    leftWall.size = leftWallObject.transform.scale.xy;
    leftWallObject.AddComponent(leftWall);
    scene.AddGameObject(leftWallObject);
    
    for (int i = 0; i < groundPieces; i++)
    {
        GameObject groundObject = GameObject.CreateQuad();
        groundObject.renderer.material = greenMaterial;
        groundObject.transform.scale = new Vector3(100.0, 1.0, 1.0);
        double halfWidth = groundObject.transform.scale.x / 2.0;
        double positionX = -halfWidth + startX - i * groundObject.transform.scale.x;
        groundObject.transform.position = new Vector3(positionX, 0.0, 0.0);
        
        groundObject.AddComponent(new RigidBody(Box2D.BodyType.STATIC));
        
        BoxCollider ground1 = new BoxCollider();
        ground1.size = groundObject.transform.scale.xy;
        groundObject.AddComponent(ground1);
        
        scene.AddGameObject(groundObject);
    }
}

void BuildMarkers(int numMarkers)
{
    double startX = -10.0;
    double stepX = 10.0;
    for (int i = 0; i < numMarkers; i++)
    {
        GameObject markerObject = GameObject.CreateQuad();
        markerObject.renderer.material = whiteMaterial;
        markerObject.transform.scale = new Vector3(0.1, 5.0, 1.0);
        double positionX = startX - i * stepX;
        markerObject.transform.position = new Vector3(positionX, 0.0, 0.0);
        
        scene.AddGameObject(markerObject);
    }
}