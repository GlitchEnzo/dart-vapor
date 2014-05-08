part of vapor;

/**
 * The base class for all functionality that is added to GameObjects.
 * @class Represents a Component
 */
class Component
{
    /**
     * The name of this Component.  Defaults to "Component".
     */
    String name = "Component";
    
    /**
     * True if the component is enabled, and therefore Updated and Rendered.
     */
    bool enabled = true;
    
    /**
     * The GameObject this Component is attached to
     */
    GameObject gameObject = null;
     
    /**
     * The Transform of the GameObject
     */
    Transform get transform => gameObject.transform;
    
    /**
     * The Scene that this Component belongs to.
     */
    Scene get scene => gameObject.scene;
    
    /**
     * Called as soon as this Component gets added to a GameObject
     */
    void Awake() {}
    
    /**
     * Called when the parent GameObject gets added to a Scene.
     */
    void Start() {}
    
    /**
     * Called once per frame.
     */
    void Update() {}
    
    /**
     * Called once per frame.  Put rendering code inside here.
     */
    void Render() {}
    
    /**
     * Called whenver collisions are detected via the physics engine (Box2D).
     */
    void OnCollision(Box2D.Contact contact) {}
}