part of vapor;

/**
 * 
 */
class CircleCollider extends Collider
{    
    String name = "CircleCollider";
    
    /**
     * Does nothing since there is no way to set the center point of a Circle fixture.
     * I belive this is a bug with the Dart port of Box2D.
     */
    Vector2 center = new Vector2(0.0, 0.0);
    
    double radius = 1.0;
    
    CircleCollider([double radius = 1.0])
    {
        this.radius = radius;
    }
    
    void Awake()
    {
        Box2D.CircleShape shape = new Box2D.CircleShape();
        //shape.position = center;
        shape.radius = radius;

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
        Box2D.CircleShape circle = _fixture.shape as Box2D.CircleShape;        
        Vector2 pos = Box2D.Transform.mul(attachedRigidbody.body.originTransform, circle.position);
        
        transform.position = new Vector3(pos.x, pos.y, transform.position.z);
        transform.eulerAngles = new Vector3(transform.eulerAngles.x, transform.eulerAngles.y, attachedRigidbody.body.angle);
        
        //transform.position = new Vector3(gameObject.rigidbody.body.position.x, gameObject.rigidbody.body.position.y, transform.position.z);
        //transform.eulerAngles = new Vector3(transform.eulerAngles.x, transform.eulerAngles.y, gameObject.rigidbody.body.angle);
        
        if (attachedRigidbody.body.contactList != null && attachedRigidbody.body.contactList.contact != null)
        {
            if (attachedRigidbody.body.contactList.contact.touching)
            {
                gameObject.OnCollision(attachedRigidbody.body.contactList.contact);
            }
        }
    }
}