part of vapor;

class Texture2D
{
    /**
     * The name of the Texture2D.  Defaults to "Texture2D".
     */
    String name = "Texture2D";
    
    /**
     * The actual HTML image element.
     */
    ImageElement image = new ImageElement();
    
    /**
     * The OpenGL Texture object.
     */
    WebGL.Texture glTexture;// = gl.createTexture();
    
    /**
     * The callback that is called when the texture is done loading.
     * In the form: void Callback(Texture2D texture)
     */
    Function LoadedCallback;
    //void LoadedCallback(Texture2D texture);
    
    Texture2D(String texturePath)
    {
        this.image.crossOrigin = "anonymous"; //???
        this.image.onLoad.listen(_Loaded);
        this.image.src = texturePath;
        
        glTexture = gl.createTexture();
    }
    
    void _Loaded(Event e)
    {
        //window.console.log("Texture loaded.");
        
        // bind the texture and set parameters for it
        gl.bindTexture(WebGL.TEXTURE_2D, this.glTexture);
        gl.texImage2D(WebGL.TEXTURE_2D, 0, WebGL.RGBA, WebGL.RGBA, WebGL.UNSIGNED_BYTE, this.image);
        gl.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MAG_FILTER, WebGL.LINEAR);
        gl.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MIN_FILTER, WebGL.LINEAR);
        
        // unbind the texture
        gl.bindTexture(WebGL.TEXTURE_2D, null);
        
        if (this.LoadedCallback != null)
            this.LoadedCallback(this);
    }
}