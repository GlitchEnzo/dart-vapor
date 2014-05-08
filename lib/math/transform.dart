part of vapor;

/**
 * Represents a Transform.
 * A Transform is what determines the translation (position), rotation (orientation),
 * and scale of a GameObject.
 */
class Transform extends Component
{    
    String name = "Transform";
    
    /**
     * Gets the model (aka world, aka transformation) Matrix of the GameObject (before scaling).
     */
    Matrix4 modelMatrix;
    
    /**
     * The model matrix with the current scaling applied.
     */
    Matrix4 get scaledModelMatrix
    {
        // TODO: Optimize this to only do the multiplication when needed.
        return this.modelMatrix * this._scaleMatrix;
    }
    
    /**
     * Gets the Quaternion representing the rotation of the GameObject.
     */
    Quaternion rotation;
    
    Vector3 _eulerAngles;
    Vector3 _scale;
    Matrix4 _scaleMatrix;
    
    Transform()
    {     
      this.modelMatrix = new Matrix4.identity();
      this.rotation = new Quaternion.identity();
      this._eulerAngles = new Vector3.zero();
      this._scale = new Vector3.all(1.0);
      _scaleMatrix = new Matrix4.identity();
    }
    
    /**
     * Gets and sets the position of the Transform.
     * @name Vapor.Transform.prototype.position
     * @property
     */
    Vector3 get position 
    {
        return new Vector3(this.modelMatrix[12],
                           this.modelMatrix[13],
                           this.modelMatrix[14]);
    }
    
    void set position(Vector3 val) 
    {
        for (GameObject child in gameObject.children)
        {
            // TODO: Set the position in local space, not world space.
            child.transform.position = val + child.transform.localPosition;
        }
        
        this.modelMatrix[12] = val[0];
        this.modelMatrix[13] = val[1];
        this.modelMatrix[14] = val[2];
        
        // Change RigidBody position as well, if there is one
        if (gameObject.rigidbody != null && gameObject.rigidbody.body != null)
        {
            // use the body's angle, since we only care about position here
            gameObject.rigidbody.body.setTransform(position.xy, gameObject.rigidbody.body.angle);
        }
    }
    
    /**
     * Gets the location relative to its parent.
     */
    Vector3 get localPosition 
    {
        // if there is no parent, the local position is the world position
        Vector3 local = position;
        if (gameObject.parent != null)
        {
            // TODO: Use local space, not world space.
            local = local - gameObject.parent.transform.position;
        }
        return local;
    }
    
    /**
     * Sets the location relative to its parent.
     */
    void set localPosition(Vector3 val) 
    {
        if (gameObject.parent != null)
        {
            // TODO: Use local space, not world space.
            position = gameObject.parent.transform.position + val;
        }
        else
        {
            position = val;
        }
    }
    
    /**
     * Gets and sets the right Vector of the Transform.
     * TODO: Convert to use Quaternion:
     * http://nic-gamedev.blogspot.com/2011/11/quaternion-math-getting-local-axis.html
     * @name Vapor.Transform.prototype.right
     */
    Vector3 get right
    {
        return new Vector3(this.modelMatrix[0],
                           this.modelMatrix[1],
                           this.modelMatrix[2]);
    }
    
    void set right(Vector3 val) 
    {
        this.modelMatrix[0] = val[0];
        this.modelMatrix[1] = val[1];
        this.modelMatrix[2] = val[2];
        
        // TODO: Recalc forward and up
    }
    
    /**
     * Gets and sets the up Vector of the Transform.
     * @name Vapor.Transform.prototype.up
     * @field
     */
    Vector3 get up
     {
        return new Vector3(this.modelMatrix[4],
                           this.modelMatrix[5],
                           this.modelMatrix[6]);
    }
    
    void set up(Vector3 val)
    {
        this.modelMatrix[4] = val[0];
        this.modelMatrix[5] = val[1];
        this.modelMatrix[6] = val[2];
        
        // TODO: Recalc forward and right
    }
    
    /**
     * Gets and sets the forward Vector of the Transform.
     * @name Vapor.Transform.prototype.forward
     * @field
     */
    Vector3 get forward 
    {
        return new Vector3(-this.modelMatrix[8],
                           -this.modelMatrix[9],
                           -this.modelMatrix[10]);
    }

    void set forward(Vector3 val)
    {
        this.modelMatrix[8] = -val[0];
        this.modelMatrix[9] = -val[1];
        this.modelMatrix[10] = -val[2];
        
        // TODO: Recalc up and right
    }
    
    /**
     * Gets and sets the euler angles (rotation around X, Y, and Z) of the Transform.
     * @name Vapor.Transform.prototype.eulerAngles
     * @field
     */
    Vector3 get eulerAngles 
    {
        // TODO: Actually calculate the angles instead of using old values.
        return this._eulerAngles;
    }

    void set eulerAngles(Vector3 val)
    {
        this._eulerAngles = val;
        this.rotation.setEuler(val.x, val.y, val.z);
        this.modelMatrix.setFromTranslationRotation(position, rotation);
    }
    
    /**
     * Gets and sets the position of the Transform.
     * @name Vapor.Transform.prototype.position
     * @property
     */
    Vector3 get scale 
    {
        return _scale;
    }
    
    void set scale(Vector3 val) 
    {
        this._scale = val;
        this._scaleMatrix.scale(this._scale);
    }
    
    /**
     * Sets the Transform to point at the given target position with the given world up vector.
     * @param {vec3} targetPosition The target position to look at.
     * @param {vec3} worldUp The world up vector.
     */
    void LookAt(Vector3 targetPosition, Vector3 worldUp)
    {   
      // TODO: worldUp should only be a hint, not "solid"
      this.modelMatrix = makeViewMatrix(this.position, targetPosition, worldUp);
    }

    void Rotate(Vector3 axis, double angle)
    {
      this.modelMatrix.rotate(axis, angle);
    }

    void RotateLocalX(double angle)
    {
      this.Rotate(this.right, angle);
    }

    void RotateLocalY(angle)
    {
      this.Rotate(this.up, angle);
    }
}

/*
// Get roll, pitch, yaw from Quaternion
// From: http://stackoverflow.com/questions/6870469/convert-opengl-4x4-matrix-to-rotation-angles
final double roll = Math.atan2(2 * (quat.getW() * quat.getX() + quat.getY() * quat.getZ()),
            1 - 2 * (quat.getX() * quat.getX() + quat.getY() * quat.getY()));
final double pitch = Math.asin(2 * (quat.getW() * quat.getY() - quat.getZ() * quat.getY()));
final double yaw = Math.atan2(2 * (quat.getW() * quat.getZ() + quat.getX() * quat.getY()), 1 - 2 * (quat.getY()
            * quat.getY() + quat.getZ() * quat.getZ()));
*/

/*
public sealed class Transform : Component, IEnumerable
{
    public Vector3 localScale { get; set; }
    public Matrix4x4 localToWorldMatrix { get; }
    public Vector3 lossyScale { get; }
    public Matrix4x4 worldToLocalMatrix { get; }

    public Vector3 InverseTransformDirection(Vector3 direction);
    public Vector3 InverseTransformDirection(float x, float y, float z);
    public Vector3 InverseTransformPoint(Vector3 position);
    public Vector3 InverseTransformPoint(float x, float y, float z);
    public void LookAt(Transform target);
    public void LookAt(Vector3 worldPosition);
    public void Rotate(Vector3 eulerAngles);
    public void Rotate(Vector3 axis, float angle);
    public void Rotate(Vector3 eulerAngles, Space relativeTo);
    public void Rotate(float xAngle, float yAngle, float zAngle);
    public void Rotate(Vector3 axis, float angle, Space relativeTo);
    public void Rotate(float xAngle, float yAngle, float zAngle, Space relativeTo);
    public void RotateAround(Vector3 axis, float angle);
    public void RotateAround(Vector3 point, Vector3 axis, float angle);
    public void RotateAroundLocal(Vector3 axis, float angle);
    public Vector3 TransformDirection(Vector3 direction);
    public Vector3 TransformDirection(float x, float y, float z);
    public Vector3 TransformPoint(Vector3 position);
    public Vector3 TransformPoint(float x, float y, float z);
    public void Translate(Vector3 translation);
    public void Translate(Vector3 translation, Space relativeTo);
    public void Translate(Vector3 translation, Transform relativeTo);
    public void Translate(float x, float y, float z);
    public void Translate(float x, float y, float z, Space relativeTo);
    public void Translate(float x, float y, float z, Transform relativeTo);
}
*/