part of vapor;

/**
 * A Scene is essentially a list of GameObjects.  It updates and renders all GameObjects
 * as well as holds a reference to a Canvas to render to.
 * @class Represents a Scene
 * @param {Vapor.Canvas} [canvas] The Canvas to use.  If not given, it creates its own.
 */
class Scene
{
    /**
     * The name of the Scene.  Defaults to "New Scene";
     */
    String name = "New Scene";
    
    /**
     * The list of GameObjects in the Scene.
     */
    List<GameObject> gameObjects = new List();
    
    /**
     * The list of Camera Components in the Scene. (Don't add to this list!  
     * Add the GameObject containing the Camera to Scene.gameObjects.)
     */
    List<Camera> cameras = new List();
    
    /**
     * True if the game is paused.
     */
    bool Paused = false;
    
    /**
     * Gets the first camera in the scene.
     */
    Camera get camera
    {
        return cameras[0];
    }
    
    // TODO: Figure out a good way to make gravity configurable.
    //Vector2 gravity = new Vector2(0.0, -9.8);
    
    /**
     * The [Canvas] used to render the Scene.
     */
    Canvas canvas = null;
    
    /**
     * The Box2D physics world.
     */
    Box2D.World world;// = new Box2D.World(new Vector2(0.0, 0.0), true, new Box2D.DefaultWorldPool());
    
    /**
     * The gravity vector used for Box2D.
     */
    Vector2 _gravity = new Vector2(0.0, -9.8);
    
    Scene([Vector2 gravity]) : this.FromCanvas(new Canvas());
    
    Scene.FromElement(CanvasElement canvasElement, [Vector2 gravity]) : this.FromCanvas(new Canvas.FromElement(canvasElement), gravity);
    
    Scene.FromCanvas(Canvas canvas, [Vector2 gravity])
    {
        this.canvas = canvas;
        
        if (gravity != null)
        {
            //gravity = new Vector2(0.0, -9.8);
            _gravity = gravity;
        }
        world = new Box2D.World(_gravity, true, new Box2D.DefaultWorldPool());
        
        // Tell the browser to call the Update method
        window.requestAnimationFrame(this.Update);
        
        // Hook the browser resize event and react accordingly
        //window.onresize = this.WindowResized.bind(this);
        window.onResize.listen(this.WindowResized);
        
        // We need to call the constructor on input classes to initilize values, but after that all calls are static.
        Keyboard keyboard = new Keyboard();
        Mouse mouse = new Mouse();
        Touch touch = new Touch();
    }

    /**
     * Adds the given GameObject to the Scene.
     * @param {Vapor.GameObject} gameObject The GameObject to add.
     */
    void AddGameObject(GameObject gameObject)
    {
        gameObject.scene = this;
        
        for (var i = 0; i < gameObject.components.length; i++)
        {
            // Check if gameObject contains Camera component.  Add to camera list if it does.
            if (gameObject.components[i] is Camera)
            {
                this.cameras.add(gameObject.components[i]);
            }
            // TODO: Check if gameObject contains Light component.  Add to light list if it does.
        }
        
        this.gameObjects.add(gameObject);
        
        gameObject.Start();
    }
    
    /**
     * Removes the given [GameObject] from the [Scene].
     */
    void RemoveGameObject(GameObject gameObject)
    {
        this.gameObjects.remove(gameObject);
    }
    
    /**
     * Clears all [GameObject]s out of the [Scene].
     */
    void Clear()
    {
        this.gameObjects.clear();
        world = new Box2D.World(_gravity, true, new Box2D.DefaultWorldPool());
    }
    
    /**
     * @private
     */
    void Update(double time)
    {
        if (!Paused)
        {
            //window.console.log("Scene Update");
            
            Time.Update();
            
            world.step(1 / 60, 10, 10);
            world.clearForces();
            
            // Call Update on each GameObject
            for (var i = 0; i < this.gameObjects.length; i++)
            {
                this.gameObjects[i].Update();
            }            
            
            // Update all of the Input
            Keyboard.Update();
            Mouse.Update();
            Touch.Update();
            
            this.Render();
        
            // Tell the browser to call the Update method
            window.requestAnimationFrame(this.Update);
        }
    }
    
    /**
     * @private
     */
    void Render()
    {
        gl.viewport(0, 0, gl.canvas.width, gl.canvas.height);
        //gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
        
        // Loop through every Camera
        for (var i = 0; i < this.cameras.length; i++)
        {
            this.cameras[i].Clear();
            
            // TODO: Perform frustum culling on each camera
            // TODO: Only draw the objects visible in each camera
            
            //console.log(this.cameras[i].transform.modelMatrix);
            
            // Loop through every GameObject
            for (var j = 0; j < this.gameObjects.length; j++)
            {
                // Set the view & projection matrix on each renderer
                if (this.gameObjects[j].renderer != null)
                {
                    Matrix4 viewMatrix = new Matrix4.copy(this.cameras[i].transform.modelMatrix);
                    viewMatrix.invert();
                    this.gameObjects[j].renderer.material.SetMatrix("uViewMatrix", viewMatrix);
                    this.gameObjects[j].renderer.material.SetMatrix("uProjectionMatrix", this.cameras[i].projectionMatrix);
                }
        
                this.gameObjects[j].Render();
            }
        }
    }
    
    /**
     * @private
     */
    void WindowResized(Event event)
    {
        //window.console.log("Scene - Window Resized");
        
        this.canvas.Resize();
        
        for (var i = 0; i < this.cameras.length; i++)
        {
            this.cameras[i].OnWindowResized(event);
        }
    }
}