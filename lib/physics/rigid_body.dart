part of vapor;

/**
 * Represents a Rigid Body for use with the Box2D physics engine.
 */
class RigidBody extends Component
{    
    String name = "RigidBody";
    
    /**
     * The backing Box2D Body object that this RigidBody represents.
     */
    Box2D.Body body;
    
    /**
     * The type of body (Dynamic, Static, or Kinematic) associated with this Collider.
     * Defaults to Dynamic.
     * The types are defined in Box2D.BodyType.
     */
    int _bodyType = Box2D.BodyType.DYNAMIC;
    
    /**
     * The Box2D.BodyDef that was used to create this Rigid Body.
     */
    Box2D.BodyDef _bodyDef;
    
    /**
     * The Box2D.BodyDef that was used to create this Rigid Body.
     */
    Box2D.BodyDef get BodyDefinition => _bodyDef;
    
    /**
     * Constructs a new RigidBody using the given body type.  Defaults to Box2D.BodyType.DYNAMIC.
     */
    RigidBody([int bodyType = Box2D.BodyType.DYNAMIC])
    {
        _bodyType = bodyType;
    }
    
    void Awake()
    {
        _bodyDef = new Box2D.BodyDef();
        _bodyDef.type = _bodyType;
        _bodyDef.position = transform.position.xy;
    }
    
    void Start()
    {
        body = gameObject.scene.world.createBody(_bodyDef);
        body.setTransform(transform.position.xy, transform.eulerAngles.z);
    }
}