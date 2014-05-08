part of vapor;

/**
 * Represents a shader program.
 * @class Represents a Shader
 */
class Shader
{
    WebGL.Shader vertexShader = null;
    WebGL.Shader pixelShader = null;
    WebGL.Program program = null;
    
    // the filepath to the shader, if it was loaded from a file
    String filepath = null;
    
    bool usesTexCoords = false;
    bool usesNormals = false;
    
    int vertexPositionAttribute;
    int textureCoordAttribute;
    int vertexNormalAttribute;
    
    //Shader() {}
    
//    Shader.Copy(Shader other)
//    {
//        
//    }
    
    /**
     * Sets up WebGL to use this Shader.
     */
    void Use()
    {
        gl.useProgram(this.program);
    }
    
    /**
     * Loads a shader from the given file path.
     * @param {string} filepath The filepath of the shader to load.
     * @returns {Vapor.Shader} The newly created Shader.
     */
    static Shader FromFile(String filepath)
    {
        window.console.log("Loading shader = " + filepath.substring(filepath.lastIndexOf("/")+1));
        
        HttpRequest request = FileDownloader.Download(filepath);
        
        var shader = Shader.FromSource(request.responseText, filepath);
        shader.filepath = filepath;
        return shader;
    }
    
    /**
     * Loads a shader from a script tag with the given ID.
     * @param {string} shaderScriptID The ID of the script tag to load as a Shader.
     * @returns {Vapor.Shader} The newly created Shader.
     */
    static Shader FromScript(String shaderScriptID)
    {
        var shaderSource = Shader.LoadShaderSourceFromScript(shaderScriptID);
        return Shader.FromSource(shaderSource, null);
    }
    
    /**
     * Loads a shader from the given source code (text).
     * @param {string} shaderSource The full source (text) of the shader.
     * @param {string} [filepath] The current filepath to work from. (Used for including other shader code.)
     * @returns {Vapor.Shader} The newly created Shader.
     */
    static Shader FromSource(String shaderSource, String filepath)
    {
        Shader shader = new Shader();
        
        shaderSource = Shader._PreprocessSource(shaderSource, filepath);
        
        shader.vertexShader = Shader._CompileShader(ShaderType.VertexShader, shaderSource);
        shader.pixelShader = Shader._CompileShader(ShaderType.FragmentShader, shaderSource);
        
        shader.program = gl.createProgram();
        gl.attachShader(shader.program, shader.vertexShader);
        gl.attachShader(shader.program, shader.pixelShader);
        gl.linkProgram(shader.program);
    
        if (!gl.getProgramParameter(shader.program, WebGL.RenderingContext.LINK_STATUS)) 
        {
            window.console.log("Link error! Could not initialise shaders.");
        }
        
        // setup the default attributes
        shader.vertexPositionAttribute = gl.getAttribLocation(shader.program, "aVertexPosition");
        //console.log("Pos attrib = " + shader.program.vertexPositionAttribute);
        //gl.enableVertexAttribArray(shader.program.vertexPositionAttribute);
        
        
        shader.textureCoordAttribute = gl.getAttribLocation(shader.program, "aTextureCoord");
        if (shader.textureCoordAttribute != -1)
        {
            //console.log("Uses Tex coords! - " + this.filepath);
            
            //gl.enableVertexAttribArray(shader.program.textureCoordAttribute);
            shader.usesTexCoords = true;
        }
        
        shader.vertexNormalAttribute = gl.getAttribLocation(shader.program, "aVertexNormal");
        if (shader.vertexNormalAttribute != -1)
        {
            //console.log("Uses Normals! - " + this.filepath);
            
            //gl.enableVertexAttribArray(shader.program.vertexNormalAttribute);
            shader.usesNormals = true;
        }
    
        return shader;
    }
    
    /**
        @private
    */
    static String LoadShaderSourceFromScript(String shaderScriptID)
    {
        var shaderScript = document.getElementById(shaderScriptID);
        if (shaderScript == null) 
        {
            return null;
        }
    
        String shaderSource = "";
        Node k = shaderScript.firstChild;
        while (k != null) 
        {
            if (k.nodeType == 3) 
            {
                shaderSource += k.text;
            }
            k = k.nextNode;
        }
    
        return shaderSource;
    }
    
    /**
      * @private
      * Process the shader source and pull in the include code
    */
    static String _PreprocessSource(String shaderSource, String filepath)
    {    
        //window.console.log("Preprocessing shader source...");
        
        var relativePath = "";
        if (filepath != null)
        {
            relativePath = filepath.substring(0, filepath.lastIndexOf("/")+1);
        }
        
        // \s* = any whitespace before the #include (0 or more spaces)
        // \s+ = any whitespace after the #include (1 or more spaces)
        // .* = any non-whitespace characters (1 or more)
        RegExp findIncludes = new RegExp(r'\s*#include\s+\".+\"');
        var matches = findIncludes.allMatches(shaderSource);
        
        //window.console.log("Found matches = " + matches.length.toString());
        RegExp stripIncludes = new RegExp(r'\s*#include\s+\"');
        RegExp stripEnd = new RegExp(r'\"');
        for (var match in matches)
        {
            //window.console.log("Match = " + match.group(0));
            String includeFile = match.group(0).replaceAll(stripIncludes, "");
            includeFile = includeFile.replaceAll(stripEnd, "");
            
            window.console.log("Including shader = " + includeFile);
            
            HttpRequest request = FileDownloader.Download(relativePath + includeFile);
            
            if (request.status != 200)
                window.console.log("Could not load shader include! " + includeFile);
            
            shaderSource = shaderSource.replaceAll(match.group(0), request.responseText + "\n");
        }
        
        //window.console.log(shaderSource);
        
        return shaderSource;
    }
    
    /**
        @private
    */
    static WebGL.Shader _CompileShader(String shaderType, String source)
    {
        //window.console.log("Compiling " + shaderType);
        
        int type = WebGL.RenderingContext.VERTEX_SHADER;
        if (shaderType == ShaderType.FragmentShader)
            type = WebGL.RenderingContext.FRAGMENT_SHADER;
        
        WebGL.Shader shaderObject = gl.createShader(type);
        source = '#define ' + shaderType + '\n' + source;
        
        gl.shaderSource(shaderObject, source);
        gl.compileShader(shaderObject);
        
        if (!gl.getShaderParameter(shaderObject, WebGL.RenderingContext.COMPILE_STATUS)) 
        {
            window.console.log("Shader compilation error: " + shaderType + " - " + gl.getShaderInfoLog(shaderObject));
        }
        
        return shaderObject;
    }
}