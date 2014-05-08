part of OrbitalGolf;

class PlanetManager
{
    static GameObject CreatePlanet(double radius, Material material)
    {
        GameObject planetObject = GameObject.CreateCircle(radius, 35);
        planetObject.renderer.material = material;
        //planetObject.transform.position = new Vector3(3.0, -2.0, 0.0);
        
        CircleCollider circleCollider = new CircleCollider();
        circleCollider.radius = radius;
        circleCollider.bodyType = Box2D.BodyType.STATIC;
        planetObject.AddComponent(circleCollider);
        
        Planet planet = new Planet();
        planetObject.AddComponent(planet);
        
        planets.add(planet);
        
        //planet.gameObject.transform.position = new Vector3(3.0, -2.0, 0.0);
        
        scene.AddGameObject(planetObject);
        
        return planetObject;
    }
}