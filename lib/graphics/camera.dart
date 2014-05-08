part of vapor;

/**
 * A Camera is what renders the GameObjects in the Scene.
 * @class Represents a Camera
 */
class Camera extends Component
{    
    String name = "Camera";
    
    /**
     * The Color to clear the background to.  Defaults to UnityBlue.
     */
    Vector4 backgroundColor = Color.UnityBlue;
    
    /**
     * The angle, in degrees, of the field of view of the Camera.  Defaults to 45.
     */
    double fieldOfView = 45.0;
    
    /**
     * The aspect ratio (width/height) of the Camera.  Defaults to the GL viewport dimensions.
     */
    double aspect;// = gl.viewportWidth / gl.viewportHeight;
    
    /**
     * The distance to the near clipping plane of the Camera.  Defaults to 0.1.
     */
    double nearClipPlane = 0.1;
    
    /**
     * The distance to the far clipping plane of the Camera.  Defaults to 1000.
     */
    double farClipPlane = 1000.0;
    
    /**
     * The current projection Matrix of the Camera.
     */
    Matrix4 projectionMatrix;
    
    Camera()
    {
        // NOTE: Can NOT do anything with Transform in the constructor, since
        //       it is not yet attached to a GameObject with a Transform.
        //       Must do it in Awake...
      
        this.aspect = gl.canvas.width / gl.canvas.height;
        this.projectionMatrix = makePerspectiveMatrix(radians(this.fieldOfView), this.aspect, nearClipPlane, farClipPlane);
    }
    
    /**
     * @private
     */
    void Awake()
    {    
        // initialize the view matrix
        this.transform.position = new Vector3(0.0, 0.0, -10.0);
        this.transform.LookAt(new Vector3(0.0, 0.0, 0.0), new Vector3(0.0, 1.0, 0.0));
    }
    
    /**
     * @private
     */
    void Update()
    {    
        /*
        var position = this.transform.position;
        
        if (Vapor.Input.GetKey(Vapor.Input.KeyCode.W))
            position[2] += 1;
            
        if (Vapor.Input.GetKey(Vapor.Input.KeyCode.S))
            position[2] -= 1;
            
            if (Vapor.Input.GetKey(Vapor.Input.KeyCode.A))
            position[0] += 1;
            
        if (Vapor.Input.GetKey(Vapor.Input.KeyCode.D))
            position[0] -= 1;
            */
            
        //this.transform.position = position;
        
        //if (Vapor.Input.touchCount == 3)
        //    alert("3 touches");
            
        //if (Vapor.Input.touchCount != 0)
        //    alert(Vapor.Input.touchCount + " touches");
    }
    
    /**
     * @private
     * Clears the depth and color buffer.
     */
    void Clear()
    {
        gl.clearColor(this.backgroundColor.r, this.backgroundColor.g, this.backgroundColor.b, this.backgroundColor.a);
        gl.clear(WebGL.RenderingContext.COLOR_BUFFER_BIT | WebGL.RenderingContext.DEPTH_BUFFER_BIT);
    }
    
    /**
     * @private
     * Resets the projection matrix based on the window size.
     */
    void OnWindowResized(Event event)
    {
      aspect = gl.canvas.width / gl.canvas.height;
      projectionMatrix = makePerspectiveMatrix(radians(fieldOfView), aspect, nearClipPlane, farClipPlane);
    }
    
    Vector3 ScreenToWorld(Vector3 screenPoint, [double z = 0.0])
    {        
//        Vector3 screenSpace = new Vector3.copy(screenPoint);
//        screenSpace.x /= window.innerWidth;
//        screenSpace.y /= window.innerHeight;
//        
//        screenSpace.x = screenSpace.x * 2 - 1;
//        screenSpace.y = screenSpace.y * 2 - 1;
//        
//        screenSpace.y = -screenSpace.y;
//        
//        Matrix4 inverseProjection = new Matrix4.identity();
//        inverseProjection.copyInverse(projectionMatrix);
//        
//        screenSpace = inverseProjection * screenSpace;
//        screenSpace = transform.modelMatrix * screenSpace;
        
        Vector3 pickWorld = new Vector3.zero();
        unproject(projectionMatrix * transform.modelMatrix, 
                0.0, window.innerWidth,
                0.0, window.innerHeight,
                screenPoint.x, screenPoint.y, z,
                pickWorld);
        
//        if (!unproject(projectionMatrix * transform.modelMatrix, 
//                       0.0, window.innerWidth,
//                       0.0, window.innerHeight,
//                       screenPoint.x, screenPoint.y, z,
//                       pickWorld))
//            window.console.log("Unproject failed!");
        
        // reverse the y value
        pickWorld[1] = -pickWorld[1];
        
        return pickWorld;
    }
    
    Vector3 WorldToScreen(Vector3 worldPoint)
    {        
        Vector3 screenPoint = new Vector3.copy(worldPoint);
        screenPoint.applyProjection(projectionMatrix * transform.modelMatrix);
        
        // Now:
        // (-1, 1)  (1, 1)
        // (-1, -1) (1, -1)
        
        // Convert to:
        // (0, 0)           (pixelWidth, 0)
        // (0, pixelHeight) (pixelWidth, pixelHeight)
        
        // convert from [-1,1] to [0,1]
        screenPoint.x = (screenPoint.x + 1.0) * 0.5;
        screenPoint.y = (-screenPoint.y + 1.0) * 0.5; //y needs to be reversed
        
        // convert [0,1] to [0,pixelWidth/pixelHeight]
        screenPoint.x *= window.innerWidth;
        screenPoint.y *= window.innerHeight;
        
        //window.console.log(screenPoint.toString());
        
        return screenPoint;
    }
}



