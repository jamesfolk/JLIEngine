//
//  ZipFileResourceLoader.h
//  BaseProject
//
//  Created by library on 8/26/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__ZipFileResourceLoader__
#define __BaseProject__ZipFileResourceLoader__

#include "AbstractSingleton.h"
#include <string>
#include "unzip.h"
#include "btHashMap.h"

#include "btVector2.h"
#include "btVector3.h"
#include "btTransform.h"

#include "BaseViewObject.h"
#include "VertexBufferObject.h"

/*
 "meshs/",
 "curves/",
 "cameras/",
 "lamps/",
 "materials/",
 "images/"
 */

enum JLIResourceTypes
{
    JLIResourceTypes_NONE,
    JLIResourceTypes_MESHS = 0,
    JLIResourceTypes_CURVES,
    JLIResourceTypes_CAMERAS,
    JLIResourceTypes_LAMPS,
    JLIResourceTypes_MATERIALS,
    JLIResourceTypes_IMAGES,
    JLIResourceTypes_MAX
};

typedef void( JLIimagebind( void *, unsigned char ) );

typedef void( JLIimageunbind( void *, unsigned char ) );


struct JLIimage
{
    JLIimage() :
    name(""),
    width(0),
    height(0),
    bits(0),
    flags(0),
    tex(NULL),
    tid(0),
    filter(0.0f),
    _JLIimagebind(NULL),
    _JLIimageunbind(NULL),
    userdata(NULL)
    {
        
    }
    
    ~JLIimage()
    {
        if(tex)
        {
            delete [] tex;
            tex = NULL;
        }
        _JLIimagebind = NULL;
        _JLIimageunbind = NULL;
        userdata = NULL;
    }
    
    std::string     name;
    
	unsigned int	width;
	unsigned int	height;
	unsigned char	bits;
    
	unsigned int	flags;
	
	unsigned char	*tex;
	
	unsigned int	tid;
	
	float			filter;
	
	JLIimagebind	*_JLIimagebind;
	JLIimageunbind	*_JLIimageunbind;
	
	void			*userdata;
	
};

struct JLIstream
{
    JLIstream(const JLIstream &rhs) :
    fname(""),
    pos(0),
    size(0),
    buf(NULL),
    cur(NULL),
    userdata(NULL)
    {
        fname = rhs.fname;
        pos = rhs.pos;
        
        size = rhs.size;
        
        buf = new unsigned char[size + 1];
        memcpy(buf, rhs.buf, size);
        cur = buf;
        
        userdata = rhs.userdata;
    }
    
    JLIstream(uLong _size = 0, const std::string _fname = "") :
    fname(_fname),
    pos(0),
    size(0),
    buf(NULL),
    cur(NULL),
    userdata(NULL)
    {
        size = _size;
        
        if(size > 0)
        {
            buf = new unsigned char[size + 1];
            buf[ size + 1 ] = 0;
            cur = buf;
        }
        
    }
    
    ~JLIstream()
    {
        if( buf )
        {
            delete [] buf;
            buf = NULL;
            
            cur = buf;
        }
    }
    
    JLIstream &operator=(const JLIstream &rhs)
    {
        if(this != &rhs
           && rhs.buf)
        {
            delete [] buf;
            
            size = rhs.size;
            
            buf = new unsigned char[size + 1];
            
            memcpy(buf, rhs.buf, size);
            cur = buf;
            
        }
        return *this;
    }
    
    void open(const char *_fname)
    {
        FILE *f = fopen(_fname, "rb");
        
        if(f)
        {
            fname = _fname;
            
            fseek( f, 0, SEEK_END );
            size = ftell( f );
            fseek( f, 0, SEEK_SET );
            
            buf = new unsigned char[size + 1];
            
            fread( &buf[ 0 ], 1, size, f );
            
            cur = buf;
            
            fclose( f );
        }
    }
    
    std::string			fname;
    
	unsigned int	pos;
	unsigned int	size;
	
	unsigned char	*buf;
	unsigned char	*cur;
	
	void			*userdata;
    
};


//class CurveObject
//{
//public:
//    CurveObject(char	*buffer)
//
//    {
//        setVertexData(buffer);
//    }
//    virtual ~CurveObject()
//    {
//        
//    }
//    
//private:
//    void setVertexData(char *buffer);
//    
//    unsigned int m_num_vertices;
//    btVector3 m_halfExtends;
//    btTransform m_world_transform;
//    btAlignedObjectArray<btVector3> m_Vertices;
//};
//
//void CurveObject::setVertexData(char *buffer)
//{
//    
//}


class CurveObject
{
public:
    CurveObject(char	*buffer) :
    m_halfExtends(new btVector3(0,0,0)),
    m_world_transform(new btTransform(btTransform::getIdentity()))
    {
        setVertexData(buffer);
    }
    virtual ~CurveObject()
    {
        delete m_world_transform;
        delete m_halfExtends;
    }
    
    virtual unsigned int numVertices()const
    {
        return m_VertexAttributes.size();
    }
    
    const btVector3 &getHalfExtends()const
    {
        return *m_halfExtends;
    }
    
    const btTransform &getWorldTransform()const
    {
        return *m_world_transform;
    }
    
    void getAttributes(btAlignedObjectArray<btVector3> &vertexAttributes)const
    {
        vertexAttributes.copyFromArray(m_VertexAttributes);
    }
    
    void getAttributes(btAlignedObjectArray<btVector3> &vertexAttributes, const btTransform &transform)const
    {
        btVector3 vertex;
        
        vertexAttributes.clear();
        btVector3 temp;
        
        for(int i = 0; i < m_VertexAttributes.size(); i++)
        {
            vertexAttributes.push_back(transform * m_VertexAttributes[i]);
        }
    }
private:
    void setVertexData(char *buffer)
    {
        char *byte = std::strtok(buffer, ",");
        int num_vertices = atoi(byte);
        
        byte = std::strtok(NULL, ",");
        m_halfExtends->setX(atof(byte));
        byte = std::strtok(NULL, ",");
        m_halfExtends->setY(atof(byte));
        byte = std::strtok(NULL, ",");
        m_halfExtends->setZ(atof(byte));
        
        btScalar m[16];
        
        for (int i = 0; i < 16; i++)
        {
            byte = std::strtok(NULL, ",");
            m[i] = atof(byte);
        }
        *m_world_transform = btTransform::getIdentity();
        m_world_transform->setBasis(btMatrix3x3(m[0], m[1], m[2], //m[3],
                                               m[4], m[5], m[6], //m[7],
                                               m[8], m[9], m[10]));
        m_world_transform->setOrigin(btVector3(m[12], m[13], m[14]));
        
        
        btVector3 vector3(0, 0, 0);
        for(size_t i = 0; i < num_vertices; i++)
        {
            byte = std::strtok(NULL, ",");
            vector3.setX(atof(byte));
            
            byte = std::strtok(NULL, ",");
            vector3.setY(atof(byte));
            
            byte = std::strtok(NULL, ",");
            vector3.setZ(atof(byte));
            
            m_VertexAttributes.push_back(vector3);
        }
        
    }
    
    btVector3 *m_halfExtends;
    btTransform *m_world_transform;
    btAlignedObjectArray<btVector3> m_VertexAttributes;
};

class BaseMeshObject
{
public:
    BaseMeshObject(const _Bool use_normals,
                           const _Bool use_colors,
                           const _Bool use_uv[32]):
    m_num_indices(0),
    m_num_vertices(0),
    m_use_vertex_normals(use_normals),
    m_use_vertex_colors(use_colors),
    m_halfExtends(btVector3(0,0,0)),
    m_world_transform(btTransform::getIdentity())
    {
        memcpy(m_use_vertex_uv, use_uv, sizeof(_Bool) * 32);
        for(int i = 0; i < 32; i++)
            m_uv_image[i] = "";
        //memcpy(m_uv_image, "", sizeof(std::string) * 32);
    }
    
    BaseMeshObject(const BaseMeshObject &rhs):
    m_num_indices(rhs.m_num_indices),
    m_num_vertices(rhs.m_num_vertices),
    m_use_vertex_normals(rhs.m_use_vertex_normals),
    m_use_vertex_colors(rhs.m_use_vertex_colors),
    m_halfExtends(rhs.m_halfExtends),
    m_world_transform(rhs.m_world_transform)
    {
        memcpy(m_use_vertex_uv, rhs.m_use_vertex_uv, sizeof(_Bool) * 32);
        for(int i = 0; i < 32; i++)
            m_uv_image[i] = rhs.m_uv_image[i];
        m_Indices.copyFromArray(rhs.m_Indices);
    }
    
    virtual ~BaseMeshObject(){}
    
    //virtual void setVertexAttributeData(char	*buffer) = 0;
    
    
    virtual void load(BaseViewObject *vo,
                      GLenum indice_usage = GL_DYNAMIC_DRAW,
                      GLenum array_usage = GL_DYNAMIC_DRAW)const = 0;
    
    virtual void loadGLBuffer(const unsigned int num_instances, VertexBufferObject *vbo, IDType shader_factory_id)const = 0;
    
    BaseMeshObject &operator=(const BaseMeshObject &rhs)
    {
        if(this != &rhs)
        {
            m_num_indices = rhs.m_num_indices;
            m_num_vertices = rhs.m_num_vertices;
            m_use_vertex_normals = rhs.m_use_vertex_normals;
            m_use_vertex_colors = rhs.m_use_vertex_colors;
            memcpy(m_use_vertex_uv, rhs.m_use_vertex_uv, sizeof(_Bool) * 32);
            memcpy(m_uv_image, rhs.m_uv_image, sizeof(std::string) * 32);
            m_halfExtends = rhs.m_halfExtends;
            m_world_transform = rhs.m_world_transform;
            m_Indices.copyFromArray(rhs.m_Indices);
        }
        return *this;
    }
    
    virtual unsigned int numIndices()const
    {
        return m_Indices.size();
    }
    
    virtual unsigned int numVertices()const = 0;
    
    const btVector3 &getHalfExtends()const
    {
        return m_halfExtends;
    }
    
    const btTransform &getWorldTransform()const
    {
        return m_world_transform;
    }
    
    const std::string &getUVImage(const unsigned int index)const
    {
        btAssert(index < 32);
        
        return m_uv_image[index];
    }
    
    bool hasNormal()const
    {
        return (bool)m_use_vertex_normals;
    }
    
    bool hasColors()const
    {
        return (bool)m_use_vertex_colors;
    }
    
    bool hasUV(const unsigned int index)const
    {
        btAssert(index < 32);
        
        return (bool)m_use_vertex_uv[index];
    }
    
    void getIndices(btAlignedObjectArray<unsigned short> &indices)const
    {
        indices.copyFromArray(m_Indices);
    }
    
protected:
    unsigned int m_num_indices;
    unsigned int m_num_vertices;
    _Bool m_use_vertex_normals;
    _Bool m_use_vertex_colors;
    _Bool m_use_vertex_uv[32];
    std::string m_uv_image[32];
    
    btVector3 m_halfExtends;
    btTransform m_world_transform;
    
    btAlignedObjectArray<GLushort> m_Indices;
    
};

template <class VERTEX_ATTRIBUTE>
class MeshObject : public BaseMeshObject
{
public:
    MeshObject(const _Bool use_normals,
                           const _Bool use_colors,
                           const _Bool use_uv[32],
                           char	*buffer):
    BaseMeshObject(use_normals, use_colors, use_uv)
    {
        setVertexAttributeData(buffer);
    }
    
    MeshObject(const MeshObject &rhs):
    BaseMeshObject(rhs)
    {
        m_VertexAttributes.copyFromArray(rhs.m_VertexAttributes);
    }
    
    virtual ~MeshObject(){};
    
    virtual void load(BaseViewObject *vo,
                      GLenum indice_usage = GL_DYNAMIC_DRAW,
                      GLenum array_usage = GL_DYNAMIC_DRAW)const;
    
    virtual void loadGLBuffer(const unsigned int num_instances, VertexBufferObject *vbo, IDType shader_factory_id)const;
    
    MeshObject &operator=(const MeshObject &rhs)
    {
        if(this != &rhs)
        {
            BaseMeshObject::operator=(rhs);
            
            m_VertexAttributes.copyFromArray(rhs.m_VertexAttributes);
        }
        return *this;
    }
    
    void getAttributes(btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertexAttributes)const
    {
        vertexAttributes.copyFromArray(m_VertexAttributes);
    }
    
    void getAttributes(btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertexAttributes, const btTransform &transform)const
    {
        btVector3 vertex;
        
        vertexAttributes.clear();
        VERTEX_ATTRIBUTE temp;
        
        for(int i = 0; i < m_VertexAttributes.size(); i++)
        {
            temp = m_VertexAttributes[i];
            
            temp.getVertex(vertex);
            temp.setVertex(transform * vertex);
            
            vertexAttributes.push_back(temp);
        }
    }
    
    virtual void concat(const MeshObject &rhs)
    {
        for(int i = 0; i < rhs.m_VertexAttributes.size(); i++)
        {
            m_VertexAttributes.push_back(rhs.m_VertexAttributes[i]);
        }
    }
    
    virtual unsigned int numVertices()const
    {
        return m_VertexAttributes.size();
    }
private:
    void setVertexAttributeData(char	*buffer);
protected:
    btAlignedObjectArray<VERTEX_ATTRIBUTE> m_VertexAttributes;
};


template <class VERTEX_ATTRIBUTE>
void MeshObject<VERTEX_ATTRIBUTE>::setVertexAttributeData(char	*buffer)
{   
    char *byte = std::strtok(NULL, ",");
    m_num_indices = atoi(byte);
    
    byte = std::strtok(NULL, ",");
    m_num_vertices = atoi(byte);
    
    for(int i = 0; i < 32; i++)
    {
        if(m_use_vertex_uv[i])
        {
            byte = std::strtok(NULL, ",");
            m_uv_image[i] = byte;
        }
        else
        {
            m_uv_image[i] = "";
        }
    }
    
    byte = std::strtok(NULL, ",");
    m_halfExtends.setX(atof(byte));
    byte = std::strtok(NULL, ",");
    m_halfExtends.setY(atof(byte));
    byte = std::strtok(NULL, ",");
    m_halfExtends.setZ(atof(byte));
    
    
    btScalar m[16];
    
    for (int i = 0; i < 16; i++)
    {
        byte = std::strtok(NULL, ",");
        m[i] = atof(byte);
    }
    m_world_transform = btTransform::getIdentity();
    
    m_world_transform.setBasis(btMatrix3x3(m[0], m[1], m[2], //m[3],
                                           m[4], m[5], m[6], //m[7],
                                           m[8], m[9], m[10]));
    m_world_transform.setOrigin(btVector3(m[12], m[13], m[14]));
    
    unsigned short indice = 0;
    for(size_t i = 0; i < m_num_indices; ++i)
    {
        byte = std::strtok(NULL, ",");
        indice = atoi(byte);
        m_Indices.push_back(indice);
    }
    
    
    
    int stride = 3;
    
    if(VERTEX_ATTRIBUTE::getNormalOffset() != 0)
    {
        stride += 3;
    }
    
    if(VERTEX_ATTRIBUTE::getColorOffset() != 0)
    {
        stride += 4;
    }
    
    for(int i = 0; i < 32; i++)
    {
        if(VERTEX_ATTRIBUTE::getTextureOffset(i) != 0)
        {
            stride += 2;
        }
    }
    
    VERTEX_ATTRIBUTE temp;
    btVector4 vector4(0.0f, 0.0f, 0.0f, 0.0f);
    btVector3 vector3(0.0f, 0.0f, 0.0f);
    btVector2 vector2(0.0f, 0.0f);
    for(size_t i = 0; i < m_num_vertices * stride; i += stride)
    {
        byte = std::strtok(NULL, ",");
        vector3.setX(atof(byte));
        
        byte = std::strtok(NULL, ",");
        vector3.setY(atof(byte));
        
        byte = std::strtok(NULL, ",");
        vector3.setZ(atof(byte));
        
        temp.setVertex(vector3);
        
        if(VERTEX_ATTRIBUTE::getNormalOffset())
        {
            if(m_use_vertex_normals)
            {
                byte = std::strtok(NULL, ",");
                vector3.setX(atof(byte));
                
                byte = std::strtok(NULL, ",");
                vector3.setY(atof(byte));
                
                byte = std::strtok(NULL, ",");
                vector3.setZ(atof(byte));
                
                temp.setNormal(vector3);
            }
        }
        
        if(VERTEX_ATTRIBUTE::getColorOffset())
        {
            if(m_use_vertex_colors)
            {
                byte = std::strtok(NULL, ",");
                vector4.setX(atof(byte));
                
                byte = std::strtok(NULL, ",");
                vector4.setY(atof(byte));
                
                byte = std::strtok(NULL, ",");
                vector4.setZ(atof(byte));
                
                byte = std::strtok(NULL, ",");
                vector4.setW(atof(byte));
                
                temp.setColor(vector4);
            }
        }
        
        for(int index = 0; index < 32; index++)
        {
            if(VERTEX_ATTRIBUTE::getTextureOffset(index))
            {
                if(m_use_vertex_uv[index])
                {
                    byte = std::strtok(NULL, ",");
                    vector2.setX(atof(byte));
                    
                    byte = std::strtok(NULL, ",");
                    vector2.setY(atof(byte));
                    
                    temp.setUV(index, vector2);
                }
            }
        }
        
        m_VertexAttributes.push_back(temp);
    }
    
}



template <class VERTEX_ATTRIBUTE>
void MeshObject<VERTEX_ATTRIBUTE>::load(BaseViewObject *vo,
          GLenum indice_usage,
          GLenum array_usage)const
{
    vo->setVertexAttributeProperties(VERTEX_ATTRIBUTE::getStride(),
                                     VERTEX_ATTRIBUTE::getPositionOffset(),
//                                     VERTEX_ATTRIBUTE::getWorldTransformOffset(),
                                     VERTEX_ATTRIBUTE::getNormalOffset(),
                                     VERTEX_ATTRIBUTE::getColorOffset(),
                                     VERTEX_ATTRIBUTE::getTextureOffset(0),
                                     m_VertexAttributes.size(),
                                     m_Indices.size());
    
    vo->load(m_Indices.size() * sizeof(m_Indices[0]),
             &m_Indices[0],
             m_VertexAttributes.size() * VERTEX_ATTRIBUTE::getStride(),
             &m_VertexAttributes[0],
             indice_usage,
             array_usage);
    
    if(VERTEX_ATTRIBUTE::getNormalOffset() != 0)
        vo->enableGLSLNormal(true);
    
    if(VERTEX_ATTRIBUTE::getColorOffset() != 0)
        vo->enableGLSLVertexColor(true);
    
    for(int i = 0; i < 32; i++)
    {
        if(VERTEX_ATTRIBUTE::getTextureOffset(i) != 0)
            vo->enableGLSLTexture(i, true);
    }
}

template <class VERTEX_ATTRIBUTE>
void MeshObject<VERTEX_ATTRIBUTE>::loadGLBuffer(const unsigned int num_instances, VertexBufferObject *vbo, IDType shader_factory_id)const
{
    vbo->loadGLBuffer(num_instances, m_VertexAttributes, m_Indices, shader_factory_id);
}


extern const char *const JLI_RESOURCE_PATH[JLIResourceTypes_MAX];

class ZipFileResourceLoader : public AbstractSingleton<ZipFileResourceLoader>
{
    friend class AbstractSingleton;
    
    ZipFileResourceLoader();
    virtual ~ZipFileResourceLoader();
public:
    bool open(const std::string zipfile);
    bool close();
    
    int extract();
    void destroy();
    
    bool finished();
    int currentObjectIndex()const;
    std::string currentObjectName()const
    {
        return m_extractObjectName;
    }
    int numObjects()const;
    
    size_t getNumImages()const;
    size_t getNumMeshes()const;
    size_t getNumCurves()const;
    
    JLIstream * getImageData(const size_t index)const;
    JLIstream * getImageData(const std::string &filename)const;
    
    const BaseMeshObject * getMeshObject(const size_t index)const;
    const BaseMeshObject * getMeshObject(const std::string &objectname)const;
    
    const CurveObject *getCurveVertices(const size_t index)const;
    const CurveObject *getCurveVertices(const std::string &objectname)const;
    
private:
    bool parseStream(JLIstream *stream);
private:
    unzFile					m_uf;
	unz_global_info			m_gi;
    int m_extractIndex;
    std::string m_extractObjectName;
    
    btAlignedObjectArray<char*> m_HashKeys;
    
    btHashMap<btHashString, BaseMeshObject*> m_Meshes;
    btHashMap<btHashString, CurveObject*> m_Curves;
    btHashMap<btHashString, unsigned const char*> m_Cameras;
    btHashMap<btHashString, unsigned const char*> m_Lamps;
    btHashMap<btHashString, unsigned const char*> m_Materials;
    btHashMap<btHashString, JLIstream*> m_Images;
};

#endif /* defined(__BaseProject__ZipFileResourceLoader__) */
