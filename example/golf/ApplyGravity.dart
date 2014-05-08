part of OrbitalGolf;

class ApplyGravity extends Component
{    
    void Update()
    {
        for (Planet planet in planets)
        {
            Vector2 gravity = planet.GetGravity(transform.position);
            Vector2 force = gravity * gameObject.collider.body.mass;
            gameObject.collider.body.applyForce(force, transform.position.xy);
        }
    }
}