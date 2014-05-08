part of Pong;

class Ball extends Component
{
    Vector3 velocity = new Vector3(-0.1, -0.1, 0.0);
    
    double topLimit = 3.0;
    double bottomLimit = -3.0;
    double leftLimit = -5.0;
    double rightLimit = 5.0;
    
    Paddle paddle1;
    Paddle paddle2;
    
    int score1 = 0;
    int score2 = 0;
    
    bool paddle1Enabled = true;
    
    //Aabb2 boundingBox;
    double width = 0.5;
    double height = 0.5;
    
    Random _random = new Random();
    
    void Update()
    {
        //Vector3 position = transform.position;
        //position += velocity;
        //transform.position = position;
        
        transform.position += velocity;
        
        if (transform.position.x < leftLimit)
        {
            //window.console.log("Player 2 Scored!");
            score1++;
            querySelector("#score1").text = score1.toString();
            velocity.x = -velocity.x;
            transform.position = new Vector3(0.0, 0.0, 0.0);
            velocity.y = _random.nextDouble() * 0.1;
            
            paddle1Enabled = true;
        }
        else if (transform.position.x > rightLimit)
        {
            //window.console.log("Player 1 Scored!");
            score2++;
            querySelector("#score2").text = score2.toString();
            velocity.x = -velocity.x;
            transform.position = new Vector3(0.0, 0.0, 0.0);
            velocity.y = _random.nextDouble() * 0.1;
            
            paddle1Enabled = false;
        }
        
        double halfWidth = width / 2.0;
        double halfHeight = height / 2.0;
        Aabb2 boundingBox = new Aabb2.minMax(new Vector2(transform.position.x - halfWidth, transform.position.y - halfHeight), new Vector2(transform.position.x + halfWidth, transform.position.y + halfHeight));
                
        if (transform.position.y - halfHeight <= bottomLimit || transform.position.y + halfHeight >= topLimit)
        {
            velocity.y = -velocity.y;
        }
                
        // check collision with the paddles
        double errorMargin = 0.1;
        if (paddle1Enabled && boundingBox.intersectsWithAabb2(paddle1.boundingBox))
        {
            // if the ball is beyond the right most edge of the paddle
            if (transform.position.x <= paddle1.transform.position.x + paddle1.halfWidth - errorMargin)
            {
                // if the ball is hitting the TOP of the paddle
//                if (paddle1.transform.position.y + paddle1.halfHeight >= transform.position.y - halfHeight)
//                {
//                    //window.console.log("TOP 1");
//                    velocity.y = -velocity.y;
//                }
//                else if (paddle1.transform.position.y - paddle1.halfHeight <= transform.position.y + halfHeight) // BOTTOM of paddle
//                {
//                    //window.console.log("BOTTOM 1");
                    velocity.y = -velocity.y;
//                }
            }
            
            // always reverse the horizontal direction
            velocity.x = -velocity.x;
            
            paddle1Enabled = false;
        }
        else if (!paddle1Enabled && boundingBox.intersectsWithAabb2(paddle2.boundingBox))
        {
            // if the ball is beyond the left most edge of the paddle
            if (transform.position.x >= paddle2.transform.position.x - paddle2.halfWidth + errorMargin)
            {
                // if the ball is hitting the TOP of the paddle
//                if (paddle2.transform.position.y + paddle2.halfHeight >= transform.position.y - halfHeight)
//                {
//                    //window.console.log("TOP 2");
//                    velocity.y = -velocity.y;
//                }
//                else if (paddle2.transform.position.y - paddle2.halfHeight <= transform.position.y + halfHeight) // BOTTOM of paddle
//                {
//                    //window.console.log("BOTTOM 2");
                    velocity.y = -velocity.y;
//                }
            }
            
            // always reverse the horizontal direction
            velocity.x = -velocity.x;
            
            paddle1Enabled = true;
        }
        
//        if (Keyboard.GetKeyDown(KeyCode.P))
//        {
//            window.console.log("Ball = " + transform.position.toString());
//        }
    }
}