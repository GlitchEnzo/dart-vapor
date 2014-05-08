part of vapor;

/**
 * Represents a 3D model that is rendered.
 * @class Represents a Mesh
 */
class Mesh
{
    /**
     * The name of this Mesh.  Defaults to "New Mesh".
     */
    String name = "New Mesh";
    
    Float32List _vertices;
    WebGL.Buffer vertexBuffer = null;
    int vertexCount = 0;
    
    /**
     * Gets and sets the vertices making up this Mesh.
     * @name Vapor.Mesh.prototype.vertices
     * @property
     */
    Float32List get vertices => this._vertices;
    void set vertices(Float32List newVertices)
    {
        // create vertex position buffer
        this._vertices = newVertices;
        gl.deleteBuffer(this.vertexBuffer);
        this.vertexBuffer = gl.createBuffer();
        gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, this.vertexBuffer);
        gl.bufferData(WebGL.RenderingContext.ARRAY_BUFFER, this._vertices, WebGL.RenderingContext.STATIC_DRAW);
        //this.vertexBuffer.stride = 3; // 3 floats per vertex position
        this.vertexCount = this._vertices.length ~/ 3;
    }
    
    Float32List _uv;
    WebGL.Buffer uvBuffer = null;
    
    /**
     * Gets and sets the texture coodinates for each vertex making up this Mesh.
     * @name Vapor.Mesh.prototype.uv
     * @property
     */
    Float32List get uv => this._uv;
    void set uv(Float32List newUVs)
    {
        // create texture coordinate buffer
        this._uv = newUVs;
        gl.deleteBuffer(this.uvBuffer);
        this.uvBuffer = gl.createBuffer();
        gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, this.uvBuffer);
        gl.bufferData(WebGL.RenderingContext.ARRAY_BUFFER, this._uv, WebGL.RenderingContext.STATIC_DRAW);
        //this.uvBuffer.stride = 2; // 2 floats per vertex position
    }
    
    Float32List _normals;
    WebGL.Buffer normalBuffer = null;
    
    /**
     * Gets and sets the normal vectors for each vertex making up this Mesh.
     * @name Vapor.Mesh.prototype.normals
     * @property
     */
    Float32List get normals => this._normals;
    void set normals(Float32List newNormals)
    {
        // create normal vector buffer
        this._normals = newNormals;
        gl.deleteBuffer(this.normalBuffer);
        this.normalBuffer = gl.createBuffer();
        gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, this.normalBuffer);
        gl.bufferData(WebGL.RenderingContext.ARRAY_BUFFER, this._normals, WebGL.RenderingContext.STATIC_DRAW);
        //this.normalBuffer.stride = 3; // 3 floats per vertex position
    }
    
    //tangents The tangents of the mesh.
    //uv2 The second texture coordinate set of the mesh, if present.
    //colors Vertex colors of the mesh.
    //colors32 Vertex colors of the mesh.

    Uint16List _triangles;
    WebGL.Buffer indexBuffer = null;
    int indexCount = 0;
    
    /**
     * Gets and sets the index buffer of this Mesh. This defines which vertices make up what triangles.
     * @name Vapor.Mesh.prototype.triangles
     * @property
     */
    Uint16List get triangles => this._triangles;
    void set triangles(Uint16List newTriangles)
    {
        // create index buffer
        this._triangles = newTriangles;
        gl.deleteBuffer(this.indexBuffer);
        this.indexBuffer = gl.createBuffer();
        gl.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, this.indexBuffer);
        gl.bufferData(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, this._triangles, WebGL.RenderingContext.STATIC_DRAW);
        this.indexCount = this._triangles.length;
    }
    
    /**
     * Draws the mesh using the given Material
     * @param {Vapor.Material} material The Material to use to render the mesh.
     */ 
    void Render(material)
    {    
        material.Enable();
        
        gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, this.vertexBuffer);
        gl.vertexAttribPointer(material.shader.vertexPositionAttribute, 3, WebGL.RenderingContext.FLOAT, false, 0, 0);
        
        if (material.shader.usesTexCoords)
        {
            if (this.uvBuffer != null)
            {
                //console.log("Setting tex coords " + material.shader.usesTexCoords);
                gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, this.uvBuffer);
                gl.vertexAttribPointer(material.shader.textureCoordAttribute, 2, WebGL.RenderingContext.FLOAT, false, 0, 0);
            }
            else
                window.console.log("Shader (" + material.shader.filepath + ") expects texure coords, but the mesh (" + this.name + ") doesn't have them.");
        }
        //else
        //{
        //    // disable tex coord attribute
        //    // TODO: determine the actual attribute index
        //    gl.disableVertexAttribArray(1);
        //}
        
        if (material.shader.usesNormals)
        {
            if (this.normalBuffer != null)
            {
                gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, this.normalBuffer);
                gl.vertexAttribPointer(material.shader.vertexNormalAttribute, 3, WebGL.RenderingContext.FLOAT, false, 0, 0);
            }
            else
                window.console.log("Shader (" + material.shader.filepath + ") expects normals, but the mesh (" + this.name + ") doesn't have them.");
        }
        
        gl.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, this.indexBuffer);
        gl.drawElements(WebGL.RenderingContext.TRIANGLES, this.indexCount, WebGL.RenderingContext.UNSIGNED_SHORT, 0);
        
        material.Disable();
    }
    
    // ----  Creation Methods
    
    /**
     * Creates a new Mesh containing data for a triangle.
     * @returns {Vapor.Mesh} The new Mesh representing a triangle.
     */ 
    static Mesh CreateTriangle()
    {
        //    0
        //   / \
        //  /   \
        // 1-----2

        var mesh = new Mesh();
        mesh.name = "Triangle";
        
        mesh.vertices = new Float32List.fromList([ 0.0,  0.5,  0.0,
                                                  -0.5, -0.5,  0.0,
                                                   0.5, -0.5,  0.0]);
        
        mesh.uv = new Float32List.fromList([0.5,  1.0,
                                            0.0,  0.0,
                                            1.0,  0.0]);
        
        mesh.normals = new Float32List.fromList([0.0, 0.0, 1.0,
                                                 0.0, 0.0, 1.0,
                                                 0.0, 0.0, 1.0]);
        
        mesh.triangles = new Uint16List.fromList([0, 1, 2]);
        
        return mesh;
    }
    
    /**
     * Creates a new Mesh containing data for a quad.
     * @returns {Vapor.Mesh} The new Mesh representing a quad.
     */
    static Mesh CreateQuad()
    {
        // 1--0
        // |\ | 
        // | \|
        // 3--2

        var mesh = new Mesh();
        mesh.name = "Quad";
        
        mesh.vertices = new Float32List.fromList([0.5,  0.5,  0.0,
                                                 -0.5,  0.5,  0.0,
                                                  0.5, -0.5,  0.0,
                                                 -0.5, -0.5,  0.0]);
        
        mesh.uv = new Float32List.fromList([1.0,  1.0,
                                            0.0,  1.0,
                                            1.0,  0.0,
                                            0.0,  0.0]);
        
        mesh.normals = new Float32List.fromList([0.0, 0.0, 1.0,
                                                 0.0, 0.0, 1.0,
                                                 0.0, 0.0, 1.0,
                                                 0.0, 0.0, 1.0]);
        
        mesh.triangles = new Uint16List.fromList([0, 1, 2, 1, 3, 2]);
        
        return mesh;
    }
    
    /**
     * Creates a new Mesh containing data for a line.
     * @returns {Vapor.Mesh} The new Mesh representing a line.
     */
    static Mesh CreateLine(List<Vector3> points, [double width = 0.1])
    {
        // 1-3-5
        // |/|/|
        // 0-2-4
        
        // 0-2-4
        // |/|/|
        // 1-3-5

        var mesh = new Mesh();
        mesh.name = "Line";
        
        double halfWidth = width / 2.0;
        
        List<double> vertices = new List();
        List<int> triangles = new List();
        
        for (Vector3 point in points)
        {
            // TODO: calculate the vector perpendicular to the direction of the line for width
            vertices.add(point.x);
            vertices.add(point.y + halfWidth);
            vertices.add(point.z);
            
            vertices.add(point.x);
            vertices.add(point.y - halfWidth);
            vertices.add(point.z);
        }
        
        mesh.vertices = new Float32List.fromList(vertices);
        
        //mesh.uv
        //mesh.normals = new Float32List.fromList([0.0, 0.0, 1.0]);
        
        for (int i = 0; i < points.length; i += 2)
        {
            triangles.add(i);
            triangles.add(i+1);
            triangles.add(i+2);
            
            triangles.add(i+1);
            triangles.add(i+3);
            triangles.add(i+2);
        }
        
        //mesh.triangles = new Uint16List.fromList([0, 1, 2, 1, 3, 2]);
        mesh.triangles = new Uint16List.fromList(triangles);
                                                 //[0, 1, 2, 
                                                 // 1, 3, 2]);
                                                  //2, 3, 4,
                                                  //3, 5, 4]);
        
        return mesh;
    }

    /**
     * Creates a Mesh with vertices forming a 2D circle.
     * radius - Radius of the circle. Value should be greater than or equal to 0.0. Defaults to 1.0.
     * segments - The number of segments making up the circle. Value should be greater than or equal to 3. Defaults to 15.
     * startAngle - The starting angle of the circle.  Defaults to 0.
     * angularSize - The angular size of the circle.  2 pi is a full circle. Pi is a half circle. Defaults to 2 pi.
     */
    static Mesh CreateCircle([double radius = 1.0, int segments = 15, double startAngle = 0.0, double angularSize = Math.PI * 2.0])
    {
        var mesh = new Mesh();
        mesh.name = "Circle";
        
        List<Vector2> uvs = new List<Vector2>();
        List<Vector3> vertices = new List<Vector3>();
        List<int> triangles = new List<int>();
        
        vertices.add(new Vector3.zero());
        uvs.add(new Vector2(0.5, 0.5));
        
        double stepAngle = angularSize / segments;
        
        for (int i = 0; i <= segments; i++) 
        {
            var vertex = new Vector3.zero();
            double angle = startAngle + stepAngle * i;
            
            //window.console.log(string.Format("{0}: {1}", i, angle));
            vertex.x = radius * Math.cos(angle);
            vertex.y = radius * Math.sin(angle);
            
            vertices.add(vertex);
            uvs.add(new Vector2((vertex.x / radius + 1) / 2, (vertex.y / radius + 1) / 2 ));
        }
        
        for (int i = 1; i <= segments; i++) 
        {
            triangles.add(i + 1);
            triangles.add(i);
            triangles.add(0);
        }
        
        mesh.vertices = _CreateFloat32List3(vertices);
        //mesh.normals = normals;
        mesh.uv =  _CreateFloat32List2(uvs);
        mesh.triangles = new Uint16List.fromList(triangles);
        
        //mesh.RecalculateNormals();
        //mesh.RecalculateBounds();
        
        return mesh;
    }
    
    /**
     * Convert a list of Vector3 objects into a Float32List object
     */
    static Float32List _CreateFloat32List3(List<Vector3> vectorList)
    {
        Float32List list = new Float32List(vectorList.length * 3);
        
        int index = 0;
        for (Vector3 vector in vectorList)
        {
            list[index++] = vector.x;
            list[index++] = vector.y;
            list[index++] = vector.z;
        }
                
        return list;
    }
    
    /**
     * Convert a list of Vector2 objects into a Float32List object
     */
    static Float32List _CreateFloat32List2(List<Vector2> vectorList)
    {
        Float32List list = new Float32List(vectorList.length * 2);
        
        int index = 0;
        for (Vector2 vector in vectorList)
        {
            list[index++] = vector.x;
            list[index++] = vector.y;
        }
                
        return list;
    }
}