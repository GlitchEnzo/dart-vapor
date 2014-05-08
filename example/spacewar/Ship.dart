part of Spacewar;

class Ship extends Component
{
    int forwardKey = KeyCode.W;
    int backwardKey = KeyCode.S;
    int leftKey = KeyCode.A;
    int rightKey = KeyCode.D;
    int fireKey = KeyCode.SPACE;
    
    Material bulletMaterial;
    
    Vector3 acceleration = new Vector3.zero();
    Vector3 velocity = new Vector3.zero();
    Vector3 _newVelocity = new Vector3.zero();
    
    double maxVelocity = 0.2;
    
    double topLimit = 6.0;
    double bottomLimit = -6.0;
    double leftLimit = -10.0;
    double rightLimit = 10.0;
    
    Aabb2 boundingBox;
    double width = 0.25;
    double height = 0.25;
    
    double halfWidth;
    double halfHeight;
    
    List<Bullet> bullets = new List(); 
    int maxBullets = 5;
    
    void Awake()
    {
        halfWidth = width / 2.0;
        halfHeight = height / 2.0;
    }
    
    void Update()
    {
        boundingBox = new Aabb2.minMax(new Vector2(transform.position.x - halfWidth, transform.position.y - halfHeight), 
                                       new Vector2(transform.position.x + halfWidth, transform.position.y + halfHeight));

        if (Keyboard.GetKeyDown(fireKey) && bullets.length < maxBullets)
        {
            //bulletCount++;
            GameObject bulletObj = GameObject.CreateTriangle();
            Bullet bullet = new Bullet();
            bulletObj.AddComponent(bullet);
            bulletObj.renderer.material = bulletMaterial;
            
            bullets.add(bullet);
            
            // ROTATE --> SCALE --> TRANSLATE
            // we must set the orientation before scaling
            bulletObj.transform.up = transform.up;
            bulletObj.transform.right = transform.right;
            bulletObj.transform.forward = transform.forward;
            
            //bulletObj.transform.scale = new Vector3(0.5, 0.5, 0.5);
            bulletObj.transform.modelMatrix.scale(0.5, 0.5, 0.5);
            
            bulletObj.transform.position = transform.position + transform.up * 1.2;
            gameObject.scene.AddGameObject(bulletObj);
            
            bullet.velocity = transform.up * 0.25;
            
            //window.console.log(bulletObj.transform.modelMatrix.toString());
        }
        
        if (Keyboard.GetKeyDown(forwardKey))
        {
            // move forward
            acceleration = transform.up * 0.01;
        }
        else if (Keyboard.GetKeyUp(forwardKey))
        {
            acceleration = new Vector3.zero();
        }
        
        if (Keyboard.GetKeyDown(backwardKey))
        {
            // move backward
            acceleration = transform.up * -0.01;
        }
        else if (Keyboard.GetKeyUp(backwardKey))
        {
            acceleration = new Vector3.zero();
        }
        
        if (Keyboard.GetKey(leftKey))
        {
            // rotate left
            Vector3 angles = transform.eulerAngles;
            angles.z -= 0.1;
            transform.eulerAngles = angles;
            
            //window.console.log(angles.z);
        }
        
        if (Keyboard.GetKey(rightKey))
        {
            // rotate right
            Vector3 angles = transform.eulerAngles;
            angles.z += 0.1;
            transform.eulerAngles = angles;
            
            //window.console.log(angles.z);
        }
        
        _newVelocity += acceleration;
        if (_newVelocity.length <= maxVelocity)
        {
            velocity = _newVelocity;
        }
        transform.position += velocity;
        
        Vector3 position = transform.position;
        if (position.y > topLimit)
        {
            position.y = bottomLimit;
        }
        else if (position.y < bottomLimit)
        {
            position.y = topLimit;
        }
        
        if (position.x > rightLimit)
        {
            position.x = leftLimit;
        }
        else if (position.x < leftLimit)
        {
            position.x = rightLimit;
        }
        transform.position = position;
    }
}