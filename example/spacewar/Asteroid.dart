part of Spacewar;

class Asteroid extends Component
{    
    Vector3 acceleration = new Vector3.zero();
    Vector3 velocity = new Vector3.zero();
    
    double topLimit = 6.0;
    double bottomLimit = -6.0;
    double leftLimit = -10.0;
    double rightLimit = 10.0;
        
    Aabb2 boundingBox;
    double width = 1.0;
    double height = 1.0;
    
    double halfWidth;
    double halfHeight;
    
    List<Asteroid> _remove = new List();
    
    void Awake()
    {
        halfWidth = width / 2.0;
        halfHeight = height / 2.0;
        
        boundingBox = new Aabb2.minMax(new Vector2(transform.position.x - halfWidth, transform.position.y - halfHeight), 
                                       new Vector2(transform.position.x + halfWidth, transform.position.y + halfHeight));
    }
    
    void Update()
    {
        boundingBox = new Aabb2.minMax(new Vector2(transform.position.x - halfWidth, transform.position.y - halfHeight), 
                                       new Vector2(transform.position.x + halfWidth, transform.position.y + halfHeight));

        // affect acceleration based upon the planet(s)
        velocity += acceleration;
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
        
        if (this.boundingBox.intersectsWithAabb2(ship.boundingBox))
        {
            //window.console.log("Asteroid Game Over!");
            querySelector("#gameover").text = "Game Over!";
            gameObject.scene.Paused = true;
        }
        
        //check collision with other asteroids
        for (Asteroid asteroid in asteroidManager.asteroids)
        {
            if (asteroid != this)
            {
                if (asteroid.boundingBox.intersectsWithAabb2(this.boundingBox))
                {
                    //window.console.log("Collision!");
                    gameObject.scene.RemoveGameObject(asteroid.gameObject);
                    gameObject.scene.RemoveGameObject(this.gameObject);
                    
                    //this.manager.asteroids.remove(asteroid);
                    //this.manager.asteroids.remove(this);
                    
                    _remove.add(this);
                    _remove.add(asteroid);
                }
            }
        }
        
        for (Asteroid asteroid in _remove)
        {
            asteroidManager.asteroids.remove(asteroid);
        }
        _remove.clear();
    }
}