part of vapor;

/**
 * Represents an instance of a Shader, with variables to set.
 * @class Represents a Material
 * @param {Vapor.Shader} shader The backing shader that this Material uses.
 */
class Material
{
    Shader shader;
    //??? textures = [];
    int textureCount = 0;
    
    /**
     * A cache of variable locations in the shader to optimize rendering.
     */
    Map<String, WebGL.UniformLocation> _cache;
    
    /**
     * A map of texture indices.
     */
    Map<String, int> _textureIndices;
    
    Material(Shader shader)
    {
        this.shader = shader;
        this.textureCount = 0;
        this._cache = new Map<String, WebGL.UniformLocation>();
        this._textureIndices = new Map<String, int>();
        this.Use();
    }
    
//    Material.Copy(Material other)
//    {
//        this.shader = other.shader;
//        this.textureCount = other.textureCount;
//        this._cache = new Map.from(other._cache);
//        this.Use();
//    }
    
    /**
     * Sets up WebGL to use this Material (and backing Shader).
     */
    void Use()
    {
        this.shader.Use();
    }
    
    /**
     * Sets up OpenGL to use this Material (and backing Shader) and sets up
     * the required vertex attributes (position, normal, tex coord, etc).
     */
    void Enable()
    {
        this.shader.Use();
        
        gl.enableVertexAttribArray(this.shader.vertexPositionAttribute);
        
        if (this.shader.usesTexCoords)
            gl.enableVertexAttribArray(this.shader.textureCoordAttribute);
        
        if (this.shader.usesNormals)
            gl.enableVertexAttribArray(this.shader.vertexNormalAttribute);
    }
    
    /**
     * Disables the vertex attributes (position, normal, tex coord, etc).
     */
    void Disable()
    {
        this.shader.Use();
        
        gl.disableVertexAttribArray(this.shader.vertexPositionAttribute);
        
        if (this.shader.usesTexCoords)
            gl.disableVertexAttribArray(this.shader.textureCoordAttribute);
        
        if (this.shader.usesNormals)
            gl.disableVertexAttribArray(this.shader.vertexNormalAttribute);
    }
    
    /**
     * Sets the matrix of the given name on this Material.
     * @param {string} name The name of the matrix variable to set.
     * @param {mat4} matrix The matrix value to set the variable to.
     */
    void SetMatrix(String name, Matrix4 matrix)
    {
        if (matrix == null)
        {
            window.console.log("Matrix is undefined! (" + name + ")");
            return;
        }
        
        this.Use();
        
        // cache the location of the variable for faster access
        if (!this._cache.containsKey(name))
            this._cache[name] = gl.getUniformLocation(this.shader.program, name);
        
        // (location, transpose, value)
        gl.uniformMatrix4fv(this._cache[name], false, matrix.storage);
    }
    
    /**
     * Sets the vector of the given name on this Material.
     * @param {string} name The name of the vector variable to set.
     * @param {Vector4} vector The vector value to set the variable to.
     */
    void SetVector(String name, Vector4 vector)
    {
        if (vector == null)
        {
            window.console.log("Vector is undefined! (" + name + ")");
            return;
        }
        
        this.Use();
        
        // cache the location of the variable for faster access
        if (!this._cache.containsKey(name))
            this._cache[name] = gl.getUniformLocation(this.shader.program, name);
        
        // (location, value)
        gl.uniform4fv(this._cache[name], vector.storage);
    }
    
    /**
     * Sets the texture of the given name on this Material.
     * @param {String} name The name of the texture variable to set.
     * @param {Texture2D} texture The texture value to set the variable to.
     */
    void SetTexture(String name, Texture2D texture)
    {
        if (texture == null)
        {
            window.console.log("Texture is undefined! (" + name + ")");
            return;
        }
        
        this.Use();
        
        // cache the location of the variable for faster access
        if (!this._cache.containsKey(name))
        {
            if (this.textureCount >= 31)
            {
                window.console.log("The maximum number of textures (32) is already bound!");
                return;
            }
            this._cache[name] = gl.getUniformLocation(this.shader.program, name);
            this._textureIndices[name] = this.textureCount;
            this.textureCount++;
        }
        
        // Does this need to be done each draw? - No, it shouldn't have to be.
        gl.activeTexture(_TextureIndex(this._textureIndices[name]));
        gl.bindTexture(WebGL.TEXTURE_2D, texture.glTexture);
        gl.uniform1i(this._cache[name], this._textureIndices[name]);
        // TODO: Unbind texture?
    }
    
    /**
     * Converts a normal int index into a WebGL.Texture# int index.
     */
    int _TextureIndex(int index)
    {
        return WebGL.TEXTURE0 + index;
    }
}



