part of OrbitalGolf;

class Ball extends Component
{
    int hits = 0;
    int pixelSize = 50;
    bool mouseDown = false;
    bool touched = false;
    
    Vector3 _firstPoint;
    Vector3 _lastPoint;
    
    GameObject forceLineRenderer;
    Material lineMaterial;
    List<Vector3> _points = new List();
    
    void Awake()
    {
        forceLineRenderer = GameObject.CreateLine(_points, 0.1);
        forceLineRenderer.renderer.material = lineMaterial;
        forceLineRenderer.renderer.enabled = false;
        scene.AddGameObject(forceLineRenderer);
    }
    
    void Update()
    {
        _firstPoint = gameObject.scene.camera.ScreenToWorld(gameObject.scene.camera.WorldToScreen(transform.position), 0.99);
        
        if (Mouse.GetMouseButtonDown(0))
        {
            Vector3 screenPosition = gameObject.scene.camera.WorldToScreen(transform.position);
            if (Mouse.mousePosition.x >= screenPosition.x - pixelSize &&
                Mouse.mousePosition.x <= screenPosition.x + pixelSize &&
                Mouse.mousePosition.y >= screenPosition.y - pixelSize &&
                Mouse.mousePosition.y <= screenPosition.y + pixelSize)
            {
                mouseDown = true;
                forceLineRenderer.renderer.enabled = true;
            }
        }
        
        if (mouseDown)
        {
            MeshRenderer renderer = forceLineRenderer.renderer as MeshRenderer;
            _points.clear();
            _points.add(_firstPoint);
            _points.add(gameObject.scene.camera.ScreenToWorld(Mouse.mousePosition, 0.99));
            renderer.mesh = Mesh.CreateLine(_points, 0.1);
            
            if (Mouse.GetMouseButtonUp(0))
            {
                mouseDown = false;
                
                Vector3 delta = gameObject.scene.camera.ScreenToWorld(Mouse.mousePosition, 0.99) - _firstPoint;
                Vector2 force = delta.xy * 15.0;
                gameObject.collider.body.applyForce(force, transform.position.xy);
                
                hits++;
                querySelector("#hits").text = hits.toString() + " hits";
                
                forceLineRenderer.renderer.enabled = false;
            }
        }
        
        if (!touched && Touch.touchCount > 0)
        {
            TouchData touch = Touch.GetTouch(0);
            
            Vector3 screenPosition = gameObject.scene.camera.WorldToScreen(transform.position);
            if (touch.position.x >= screenPosition.x - pixelSize &&
                touch.position.x <= screenPosition.x + pixelSize &&
                touch.position.y >= screenPosition.y - pixelSize &&
                touch.position.y <= screenPosition.y + pixelSize)
            {
                touched = true;                
                forceLineRenderer.renderer.enabled = true;
            }
        }
        
        if (touched)
        {
            if (Touch.touchCount > 0)
            {
                TouchData touch = Touch.GetTouch(0);
                
                _lastPoint = gameObject.scene.camera.ScreenToWorld(touch.position, 0.99);
                
                MeshRenderer renderer = forceLineRenderer.renderer as MeshRenderer;
                _points.clear();
                _points.add(_firstPoint);
                _points.add(_lastPoint);
                renderer.mesh = Mesh.CreateLine(_points, 0.1);                
            }
            else // no longer touching
            {
                touched = false;
                
                Vector3 delta = _lastPoint - _firstPoint;
                Vector2 force = delta.xy * 15.0;
                gameObject.collider.body.applyForce(force, transform.position.xy);
                
                hits++;
                querySelector("#hits").text = hits.toString() + " hits";
                
                forceLineRenderer.renderer.enabled = false;
            }
        }
    }
    
    void OnCollision(Box2D.Contact contact)
    {
        if (contact.fixtureA.isSensor || contact.fixtureB.isSensor)
        {
            querySelector("#win").text = "You win!";
        }
    }
}