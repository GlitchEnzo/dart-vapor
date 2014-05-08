part of vapor;

/**
 * 
 */
class RevoluteJoint extends Component
{    
    String name = "RevoluteJoint";
    
    double radius = 1.0;
    
    Box2D.RevoluteJointDef _jointDef;
    
    bool enableMotor = false;
    
    /**
     * The other RigidBody object that the one with the joint is connected to. If this is null then the othen end of the joint will be fixed at a point in space.
     */
    RigidBody connectedRigidBody;
    
    /**
     * Coordinate in local space where the end point of the joint is attached.
     */
    Vector2 anchor;
    
    Box2D.RevoluteJoint _revoluteJoint;
    
    void Awake()
    {
        _jointDef = new Box2D.RevoluteJointDef();
        _jointDef.enableMotor = enableMotor;
        //_jointDef.initialize(gameObject.rigidbody.body, connectedRigidBody.body, anchor);
    }
    
    void Start()
    {
        _jointDef.initialize(gameObject.rigidbody.body, connectedRigidBody.body, anchor);
        _revoluteJoint = scene.world.createJoint(_jointDef);
    }
    
    void Update()
    {
        
    }
}