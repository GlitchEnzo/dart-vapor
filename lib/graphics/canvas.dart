part of vapor;

class Canvas
{
    /**
     * The HTML Canvas Element that is being used for rendering.
     */
    CanvasElement element;
    
    Canvas() 
    {
        element = new CanvasElement(width: window.innerWidth, height: window.innerHeight);
        element.id = "VaporCanvas";
        
        //element.style.zIndex = "0";
        element.tabIndex = 0;
        element.focus();
        
        document.body.append(element);

        try 
        {
            gl = element.getContext("webgl");
            if (gl == null)
            {
                window.console.log("Using experimental context.");
                gl = element.getContext("experimental-webgl");
            }
            //gl.viewportWidth = element.width;
            //gl.viewportHeight = element.height;
            gl.viewport(0, 0, element.width, element.height);
        }
        catch(e) 
        {
            window.console.error("Exception caught. " + e);
        }
        
        if (gl == null) 
        {
            window.alert("Unable to initialize WebGL.");
        }
    }
    
    Canvas.FromElement(CanvasElement canvasElement) 
    {
        element = canvasElement;
        
        try 
        {
            gl = element.getContext("webgl");
            if (gl == null)
            {
                window.console.log("Using experimental context.");
                gl = element.getContext("experimental-webgl");
            }
            //gl.viewportWidth = element.width;
            //gl.viewportHeight = element.height;
            gl.viewport(0, 0, element.width, element.height);
        }
        catch(e) 
        {
            window.console.error("Exception caught. " + e);
        }
        
        if (gl == null) 
        {
            window.alert("Unable to initialize WebGL.");
        }
    }
    
    /**
     *  Resizes the canvas based upon the current browser window size.
     */ 
    void Resize()
    {
        //window.console.log("Resized. " + window.innerWidth.toString() + "x" + window.innerHeight.toString());
        
        element.width = window.innerWidth;
        element.height = window.innerHeight;
        
        gl.viewport(0, 0, element.width, element.height);
    }
}