part of Pong;

class Paddle extends Component
{
    int upKey = KeyCode.W;
    int downKey = KeyCode.S;
    
    bool AI = false;
    Ball ball;
    
    double topLimit = 3.0;
    double bottomLimit = -3.0;
    
    Aabb2 boundingBox;
    double width = 1.0;
    double height = 2.0;
    
    double halfWidth;
    double halfHeight;
    
    void Awake()
    {
        halfWidth = width / 2.0;
        halfHeight = height / 2.0;
    }
    
    void Update()
    {
        boundingBox = new Aabb2.minMax(new Vector2(transform.position.x - halfWidth, transform.position.y - halfHeight), 
                                       new Vector2(transform.position.x + halfWidth, transform.position.y + halfHeight));
        if (!AI)
        {
            if (Keyboard.GetKey(upKey) && transform.position.y + halfHeight < topLimit)
            {
                // move up
                Vector3 position = transform.position;
                position.y += 0.2;
                transform.position = position;
            }
            
            if (Keyboard.GetKey(downKey)  && transform.position.y - halfHeight > bottomLimit)
            {
                // move down
                Vector3 position = transform.position;
                position.y -= 0.2;
                transform.position = position;
            }
        }
        else // move via AI
        {
            // only react when the ball is coming toward me (ASSUMES only right paddle is AI)
            if (ball.velocity.x < 0)
            {
                if (ball.transform.position.y < transform.position.y)
                {
                    // move down
                    Vector3 position = transform.position;
                    position.y -= 0.03;
                    transform.position = position;
                }
                else
                {
                    // move up
                    Vector3 position = transform.position;
                    position.y += 0.03;
                    transform.position = position;
                }
            }
        }
    }
}