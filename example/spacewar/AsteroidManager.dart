part of Spacewar;

class AsteroidManager extends Component
{        
    List<Asteroid> asteroids = new List();
    double minVelocity = 0.05;
    double maxVelocity = 0.2;
    Material material;
    int maxCount = 5;
    
    double _elapsed = 0.0;
    double _nextTime = 1.0;
    
    //Math.Random _random = new Math.Random();
    
    void Awake()
    {
        //_nextTime = _random.nextDouble();
        //_nextTime = _random.nextInt(5) * 1.0;
        _nextTime = Rand.NextDoubleRange(1.0, 5.0);
    }
    
    void Update()
    {
        _elapsed += Time.deltaTime;
        
        // spawn a new asteroid if the time has passed and there are not the max number out already
        if (_elapsed >= _nextTime && asteroids.length < maxCount)
        {
            GameObject asteroidObject = GameObject.CreateQuad();
            Asteroid asteroid = new Asteroid();
            asteroidObject.AddComponent(asteroid);
            asteroidObject.renderer.material = material;
            
            asteroids.add(asteroid);
            
            double size = Rand.NextDoubleRange(0.3, 1.0);
            asteroidObject.transform.modelMatrix.scale(size, size, size);
            
            asteroid.width = size;
            asteroid.height = size;
            
            asteroidObject.transform.position = new Vector3(Rand.NextDoubleRange(10.0, 15.0), Rand.NextDoubleRange(10.0, 15.0), 0.0);
            gameObject.scene.AddGameObject(asteroidObject);
            
            asteroid.velocity = -asteroid.transform.position.normalized() * 0.15;
            
            _elapsed = 0.0;
            _nextTime = Rand.NextDoubleRange(1.0, 5.0);
        }
    }
}