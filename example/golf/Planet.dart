part of OrbitalGolf;

class Planet extends Component
{
    /**
     * The strength of the gravity (in meters per second) at the planet's surface.
     */
    double surfaceGravity = 9.8;
    
    Vector2 GetGravity(Vector3 worldPosition)
    {
        Vector3 direction = transform.position - worldPosition;
        double distance = direction.length;
        double strength = surfaceGravity / distance;
        
        direction.normalize();
        
        Vector3 gravity = direction * strength;
        
        return gravity.xy;
    }
}