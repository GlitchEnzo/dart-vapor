part of LongJump;

class Car extends Component
{
    double distance = 0.0;
    double maxDistance = 0.0;
    
    void Update()
    {
        // only allow input on the left of the ramp
        if (distance <= 1)
        {
            if (Keyboard.GetKey(KeyCode.RIGHT) || Keyboard.GetKey(KeyCode.D))
            {
                //gameObject.rigidbody.body.applyForce(new Vector2(-3.0, 0.0), transform.position.xy);
                //gameObject.rigidbody.body.applyForce(new Vector2(-3.0, 0.0), gameObject.rigidbody.body.localCenter);
                gameObject.rigidbody.body.applyForce(new Vector2(-3.0, 0.0), gameObject.rigidbody.body.worldCenter);
            }
            
            if (Keyboard.GetKey(KeyCode.LEFT) || Keyboard.GetKey(KeyCode.A))
            {
                //gameObject.rigidbody.body.applyForce(new Vector2(3.0, 0.0), transform.position.xy);
                //gameObject.rigidbody.body.applyForce(new Vector2(3.0, 0.0), gameObject.rigidbody.body.localCenter);
                gameObject.rigidbody.body.applyForce(new Vector2(3.0, 0.0), gameObject.rigidbody.body.worldCenter);
            }
        }
        
        distance = -transform.position.x;
        querySelector("#distance").text = distance.toStringAsFixed(2) + " meters";
        
        if (distance > maxDistance)
        {
            maxDistance = distance;
            querySelector("#max").text = maxDistance.toStringAsFixed(2) + " meters";
        }
    }
}