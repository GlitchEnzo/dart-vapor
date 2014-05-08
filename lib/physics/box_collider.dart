part of vapor;

/**
 * Represents a collider that is a box shape.
 */
class BoxCollider extends Collider
{    
    String name = "BoxCollider";
    
    Vector2 center = new Vector2(0.0, 0.0);
    
    Vector2 size = new Vector2(1.0, 1.0);
    
    void Awake()
    {        
        Box2D.PolygonShape shape = new Box2D.PolygonShape();
        shape.setAsBoxWithCenterAndAngle(size.x / 2, size.y / 2, center, 0.0);

        _fixtureDef = new Box2D.FixtureDef();
        _fixtureDef.restitution = 0.5;
        _fixtureDef.density = 0.05;
       //_fixtureDef.friction = 0.1;
        _fixtureDef.shape = shape;
        _fixtureDef.isSensor = isSensor;
    }
    
    void Start()
    {      
        super.Start();
        
        _fixture = attachedRigidbody.body.createFixture(_fixtureDef); 
    }
    
    void Update()
    {
        Box2D.PolygonShape polygon = _fixture.shape as Box2D.PolygonShape;        
        Vector2 pos = Box2D.Transform.mul(attachedRigidbody.body.originTransform, polygon.centroid);
        
        transform.position = new Vector3(pos.x, pos.y, transform.position.z);
        transform.eulerAngles = new Vector3(transform.eulerAngles.x, transform.eulerAngles.y, attachedRigidbody.body.angle);
        
        //transform.position = new Vector3(gameObject.rigidbody.body.position.x, gameObject.rigidbody.body.position.y, transform.position.z);
        //transform.eulerAngles = new Vector3(transform.eulerAngles.x, transform.eulerAngles.y, gameObject.rigidbody.body.angle);
    }
}