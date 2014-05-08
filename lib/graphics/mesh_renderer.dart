part of vapor;

/**
 * Represents a Renderer behavior that is used to render a mesh.
 * @class Represents a MeshRenderer
 */
class MeshRenderer extends Renderer
{
    String name = "MeshRenderer";
    
    /**
     * The mesh that this MeshRenderer will draw.
     */
    Mesh mesh = null;

    /**
     * @private
     */
    void Render()
    {      
      this.material.Use();
      //this.material.SetMatrix("uModelViewMatrix", this.gameObject.transform.modelMatrix);
      this.material.SetMatrix("uModelMatrix", this.gameObject.transform.scaledModelMatrix);
      this.mesh.Render(this.material);
    }
}

