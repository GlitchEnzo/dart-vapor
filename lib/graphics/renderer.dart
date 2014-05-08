part of vapor;

/**
 * The base behavior that is used to render anything.
 * @class Represents a Renderer
 * @see Vapor.Behavior
 */
class Renderer extends Component
{
    String name = "Renderer";
    
    /**
     * The Vapor.Material that this Renderer uses.
     * @type Vapor.Material
     */
    Material material = null;
    
    /**
     * @private
     */
    void Update()
    {
      //console.log("Renderer Update");
      
      //Vapor.Behavior.prototype.Update.call(this); // call super
    }

    /**
     * @private
     */
    void Render()
    {
      //console.log("Renderer Draw");
      
      //Vapor.Behavior.prototype.Draw.call(this); // call super
    }
}

