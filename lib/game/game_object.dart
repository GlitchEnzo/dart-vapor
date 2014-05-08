part of vapor;

/**
 * Represents the base object of everything that is in a Scene.
 * @class Represents a GameObject
 */
class GameObject
{
    /**
     * The name of this GameObject.  Defaults to "GameObject".
     */
    String name = "GameObject";
    
    /**
     * The list of Components attached to this GameObject.
     */
    List<Component> components = new List();
    
    /**
     * The list of GameObjects that are children to this GameObject.
     */
    List<GameObject> children = new List();
    
    /**
     * The parent that this GameObject is a child of.
     */
    GameObject parent = null;
    
    /**
     * The Scene that this GameObject belongs to.
     */
    Scene scene;
    
    /**
     * The Transform attached to this GameObject.
     */
    Transform transform;
    
    /**
     * The Renderer attached to this GameObject, if there is one.
     */
    Renderer renderer;
    
    /**
     * The Collider attached to this GameObject, if there is one.
     */
    Collider collider;
    
    /**
     * The Box2D Body attached to this GameObject, if there is one.
     */
    RigidBody rigidbody;
    
    /**
     * The Camera attached to this GameObject, if there is one.
     */
    Camera camera;
    
    GameObject()
    {
        transform = new Transform();
        AddComponent(transform);
    }
    
    /**
     * Adds the given Component to this GameObject.
     * @param {Vapor.Component} component The Component to add.
     */
    void AddComponent(Component component)
    {
        component.gameObject = this;
        
        if (component is Renderer)
        {    
            this.renderer = component;
        }
        else if (component is Camera)
        {    
            this.camera = component;
        }
        else if (component is Collider)
        {    
            this.collider = component;
        }
        else if (component is RigidBody)
        {
            this.rigidbody = component;
        }
            
        this.components.add(component);
        
        component.Awake();
    }
    
    /**
     * Called when the GameObject gets added to a Scene.
     */
    void Start()
    {
        for (var i = 0; i < this.components.length; i++)
        {
            this.components[i].Start();
        }
    }
    
    /**
     * Gets the Component with the given name attached to this GameObject.
     * @param {string} name The name of the Component to get.
     * @returns {Vapor.Component} The Component, if it's found. Otherwise, null.
     */
    Component GetComponentByName(String name)
    {
        var found = null;
        for (var i = 0; i < this.components.length; i++)
        {
            if (this.components[i].name == name)
            {
                found = this.components[i];
                break;
            }
        }
        
        return found;
    }
    
    /**
     * Gets the component of the given type attached to this GameObject, if there is one.
     * Note: Due to limitations with Dart, this can only find components of a SPECIFIC type, not child types.
     */
    Component GetComponentByType(Type type)
    {
        var found = null;
        for (var i = 0; i < this.components.length; i++)
        {
            if (this.components[i].runtimeType == type)
            {
                found = this.components[i];
                break;
            }
        }
        
        return found;
    }
    
    /**
     * Adds the given GameObject as a child to this GameObject.
     * @param {Vapor.GameObject} child The GameObject child to add.
     */
    void AddChild(GameObject child)
    {
        child.parent = this;
        //child.rigidbody = this.rigidbody;
        this.children.add(child);
    }
    
    /**
     * @private
     */
    void Update()
    {
        for (var i = 0; i < this.components.length; i++)
        {
            if (this.components[i].enabled)
            {
                this.components[i].Update();
            }
        }
    }
    
    /**
     * @private
     */
    void Render()
    {
        for (var i = 0; i < this.components.length; i++)
        {
            if (this.components[i].enabled)
            {
                this.components[i].Render();
            }
        }
    }
    
    void OnCollision(Box2D.Contact contact)
    {
        for (var i = 0; i < this.components.length; i++)
        {
            this.components[i].OnCollision(contact);
        }
    }
    
    // ------ Static Creation Methods -------------------------------------------
    
    /**
     * Creates a GameObject with a Camera Behavior already attached.
     * @returns {Vapor.GameObject} A new GameObject with a Camera.
     */
    static GameObject CreateCamera()
    {
        var cameraObject = new GameObject();
        cameraObject.name = "Camera";
        
        var camera = new Camera();
        cameraObject.AddComponent(camera);
        
        return cameraObject;
    }
    
    /**
     * Creates a GameObject with a triangle Mesh and a MeshRenderer Behavior already attached.
     * @returns {Vapor.GameObject} A new GameObject with a triangle Mesh.
     */
    static GameObject CreateTriangle()
    {
        var triangleObject = new GameObject();
        triangleObject.name = "Triangle";
        
        var meshRenderer = new MeshRenderer();
        meshRenderer.mesh = Mesh.CreateTriangle();
        triangleObject.AddComponent(meshRenderer);
        
        return triangleObject;
    }
    
    /**
     * Creates a GameObject with a quad Mesh and a MeshRenderer Behavior already attached.
     * @returns {Vapor.GameObject} A new GameObject with a quad Mesh.
     */
    static GameObject CreateQuad()
    {
        var quadObject = new GameObject();
        quadObject.name = "Quad";
        
        var meshRenderer = new MeshRenderer();
        meshRenderer.mesh = Mesh.CreateQuad();
        quadObject.AddComponent(meshRenderer);
        
        return quadObject;
    }
    
    /**
     * Creates a GameObject with a line Mesh and a MeshRenderer Behavior already attached.
     * @returns {Vapor.GameObject} A new GameObject with a line Mesh.
     */
    static GameObject CreateLine(List<Vector3> points, [double width = 0.1])
    {
        var lineObject = new GameObject();
        lineObject.name = "Line";
        
        var meshRenderer = new MeshRenderer();
        meshRenderer.mesh = Mesh.CreateLine(points, width);
        lineObject.AddComponent(meshRenderer);
        
        return lineObject;
    }
    
    /**
     * Creates a GameObject with a circle Mesh and a MeshRenderer Behavior already attached.
     * @returns {Vapor.GameObject} A new GameObject with a quad Mesh.
     */
    static GameObject CreateCircle([double radius = 1.0, int segments = 15, double startAngle = 0.0, double angularSize = Math.PI * 2.0])
    {
        var circleObject = new GameObject();
        circleObject.name = "Circle";
        
        var meshRenderer = new MeshRenderer();
        meshRenderer.mesh = Mesh.CreateCircle(radius, segments, startAngle, angularSize);
        circleObject.AddComponent(meshRenderer);
        
        return circleObject;
    }
}