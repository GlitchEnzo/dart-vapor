part of vapor;

/**
 * Represents a collider for use with the Box2D physics engine.
 * The base class for all Collider objects.
 */
class Collider extends Component
{    
    String name = "Collider";
    
    /**
     * The rigid body attached to the Collider's GameObject.
     */
    RigidBody attachedRigidbody;
    
    /**
     * True if the body associated with this Collider is used as a Box2D sensor.
     * Defaults to false.
     */
    bool isSensor = false;
    
    /**
     * The FixtureDef that was used to create this collider.
     */
    Box2D.FixtureDef _fixtureDef;
    
    /**
     * The FixtureDef that was used to create this collider.
     */
    Box2D.FixtureDef get FixtureDefinition => _fixtureDef;
    
    /**
     * The actual Fixture that this collider represents.
     */
    Box2D.Fixture _fixture;
    
    void Start()
    {
        // first just set to the rigid body attached to this object
        attachedRigidbody = gameObject.rigidbody;
        
        // next try to find a rigid body on the parents
        GameObject parent = gameObject.parent;
        while (parent != null)
        {
            window.console.log("Parent = " + parent.name);
            
            if (parent.rigidbody != null)
            {
                attachedRigidbody = parent.rigidbody;
            }
            
            parent = parent.parent;
        }
        
        if (attachedRigidbody == null)
        {
            window.console.error("You must first attach a RigidBody component.");
        }
    }
}