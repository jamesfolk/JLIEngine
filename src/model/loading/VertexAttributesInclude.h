//
//  VertexAttributesInclude.h
//  BaseProject
//
//  Created by library on 8/28/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef BaseProject_VertexAttributesInclude_h
#define BaseProject_VertexAttributesInclude_h

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
//#include <OpenGLES/ES3/gl.h>
//#include <OpenGLES/ES3/glext.h>

#include "btVector3.h"
#include "btVector2.h"
//#include "jliTransform.h"

#include <string>

struct VertexAttributes_Vertex;
struct VertexAttributes_Vertex_UVLayer1;
struct VertexAttributes_Vertex_Normal_UVLayer1;
struct VertexAttributes_Vertex_Normal_Color_UVLayer1;
struct VertexAttributes_Vertex_Color;

ATTRIBUTE_ALIGNED16(struct) VertexAttributes_Vertex
{
	btVector3 vertex;
//    jliTransform worldTransform;

public:
    operator std::string()
    {
        char buffer[1024];
        float x = vertex.x();
        float y = vertex.y();
        float z = vertex.z();
        float w = vertex.w();
        sprintf(buffer,"{ %+.1f, %+.1f, %+.1f, %+.1f }", x, y, z, w);
        return std::string(buffer);
    }

    virtual void setVertex(const btVector3 &v){vertex = v;}
    virtual void setNormal(const btVector3 &v){}
    virtual void setColor(const btVector4 &v){}
    virtual void setUV(const unsigned int index, const btVector2 &v){}
//    virtual void setWorldTransform(const btTransform &t){worldTransform = t;}

    virtual bool getVertex(btVector3 &v)const{v = vertex;return true;}
    virtual bool getNormal(btVector3 &v)const{return false;}
    virtual bool getColor(btVector4 &v)const{return false;}
    virtual bool getUV(unsigned int index, const btVector2 &v)const{return false;}
//    virtual bool getWorldTransform(btTransform &t){t = worldTransform;return true;}

    VertexAttributes_Vertex(const btVector3 &_vertex):
    vertex(_vertex){}
    
    VertexAttributes_Vertex(const VertexAttributes_Vertex &copy):
    vertex(copy.vertex){}
    
    VertexAttributes_Vertex &operator=(const VertexAttributes_Vertex &rhs)
    {
        if(this != &rhs)
        {
            vertex = rhs.vertex;
        }
        return *this;
    }
    
    static GLsizei getStride()
    {
        return (sizeof(VertexAttributes_Vertex));
    }
    
    static size_t getPositionOffset()
    {
        return offsetof(VertexAttributes_Vertex, vertex);
    }

//    static size_t getWorldTransformOffset()
//    {
//        return offsetof(VertexAttributes_Vertex, worldTransform);
//    }

    static size_t getNormalOffset()
    {
        return 0;
    }
    
    static size_t getColorOffset()
    {
        return 0;
    }
    
    static size_t getTextureOffset(const unsigned int index)
    {
        return 0;
    }



};














ATTRIBUTE_ALIGNED16(struct) VertexAttributes_Vertex_UVLayer1 : public VertexAttributes_Vertex
{
    btVector2 texture0;
public:
    operator std::string()
    {
        std::string s(this->VertexAttributes_Vertex::operator std::string());
        
        return s;
//        char buffer[1024];
//        float x = vertex.x();
//        float y = vertex.y();
//        float z = vertex.z();
//        float w = vertex.w();
//        sprintf(buffer,"{ $f, %f, %f, %f }", x, y, z, w);
//        return std::string(buffer);
    }
    
    //virtual void setUV0(const btVector2 &v){texture0 = v;}
    virtual void setUV(const unsigned int index, const btVector2 &v)
    {
        if(index == 0)
            texture0 = v;
    }
    
    VertexAttributes_Vertex_UVLayer1(const btVector3 &_vertex = btVector3(),
                                     const btVector2 &_texture0 = btVector2()):
    VertexAttributes_Vertex(_vertex),
    texture0(_texture0)
    {
        //DebugString::log(DebugString::btVectorStr(_vertex));
    }
    
    VertexAttributes_Vertex_UVLayer1(const VertexAttributes_Vertex_UVLayer1 &copy):
    VertexAttributes_Vertex(copy.vertex),
    texture0(copy.texture0){}
    
    VertexAttributes_Vertex_UVLayer1 &operator=(const VertexAttributes_Vertex_UVLayer1 &rhs)
    {
        if(this != &rhs)
        {
            VertexAttributes_Vertex::operator=(rhs);
            texture0 = rhs.texture0;
        }
        return *this;
    }
    
    
    static GLsizei getStride()
    {
        return (sizeof(VertexAttributes_Vertex_UVLayer1));
    }
    
    static size_t getPositionOffset()
    {
        return offsetof(VertexAttributes_Vertex_UVLayer1, vertex);
    }
    
    static size_t getNormalOffset()
    {
        return 0;//offsetof(VertexAttributes_Vertex_Normal_Color_UVLayer1, normal);
    }
    
    static size_t getColorOffset()
    {
        return 0;//offsetof(VertexAttributes_Vertex_Normal_Color_UVLayer1, color);
    }
    
    static size_t getTextureOffset(const unsigned int index)
    {
        if(index == 0)
            return offsetof(VertexAttributes_Vertex_UVLayer1, texture0);
        return 0;
    }
    
//    static size_t getWorldTransformOffset()
//    {
//        return offsetof(VertexAttributes_Vertex_UVLayer1, worldTransform);
//    }
    };
    
    
    
    
    //ATTRIBUTE_ALIGNED16(struct) VertexAttributes_Vertex_UVLayer1 : public VertexAttributes_Vertex
    //{
    //    btVector2 texture0;
    //public:
    //    virtual void setUV1(const btVector2 &v){texture0 = v;}
    //
    //    VertexAttributes_Vertex_UVLayer1(const btVector3 &_vertex = btVector3(),
    //                                            const btVector2 &_texture0 = btVector2()):
    //    VertexAttributes_Vertex(_vertex),
    //    texture0(_texture0){}
    //
    //    VertexAttributes_Vertex_UVLayer1(const VertexAttributes_Vertex_UVLayer1 &copy):
    //    VertexAttributes_Vertex(copy),
    //    texture0(copy.texture0){}
    //
    //    VertexAttributes_Vertex_UVLayer1 &operator=(const VertexAttributes_Vertex_UVLayer1 &rhs)
    //    {
    //        if(this != &rhs)
    //        {
    //            VertexAttributes_Vertex::operator=(rhs);
    //            texture0 = rhs.texture0;
    //        }
    //        return *this;
    //    }
    //
    //    static GLsizei getStride()
    //    {
    //        return (sizeof(VertexAttributes_Vertex_UVLayer1));
    //    }
    //
    //    static size_t getPositionOffset()
    //    {
    //        return offsetof(VertexAttributes_Vertex_UVLayer1, vertex);
    //    }
    //
    //    static size_t getNormalOffset()
    //    {
    //        return 0;
    //    }
    //
    //    static size_t getColorOffset()
    //    {
    //        return 0;
    //    }
    //
    //    static size_t getTexture0Offset()
    //    {
    //        return offsetof(VertexAttributes_Vertex_UVLayer1, texture0);
    //    }
    //};
    
    ATTRIBUTE_ALIGNED16(struct) VertexAttributes_Vertex_Normal_UVLayer1 : public VertexAttributes_Vertex
    {
        btVector3 normal;
        btVector2 texture0;
    public:
        virtual void setNormal(const btVector3 &v){normal = v;}
        //virtual void setUV0(const btVector2 &v){texture0 = v;}
        virtual void setUV(const unsigned int index, const btVector2 &v)
        {
            if(index == 0)
                texture0 = v;
        }
        
        VertexAttributes_Vertex_Normal_UVLayer1(const btVector3 &_vertex = btVector3(),
                                                const btVector3 &_normal = btVector3(),
                                                const btVector2 &_texture0 = btVector2()):
        VertexAttributes_Vertex(_vertex),
        normal(_normal),
        texture0(_texture0){}
        
        VertexAttributes_Vertex_Normal_UVLayer1(const VertexAttributes_Vertex_Normal_UVLayer1 &copy):
        VertexAttributes_Vertex(copy.vertex),
        normal(copy.normal),
        texture0(copy.texture0){}
        
        VertexAttributes_Vertex_Normal_UVLayer1 &operator=(const VertexAttributes_Vertex_Normal_UVLayer1 &rhs)
        {
            if(this != &rhs)
            {
                VertexAttributes_Vertex::operator=(rhs);
                normal = rhs.normal;
                texture0 = rhs.texture0;
            }
            return *this;
        }
        
        static GLsizei getStride()
        {
            return (sizeof(VertexAttributes_Vertex_Normal_UVLayer1));
        }
        
        static size_t getPositionOffset()
        {
            return offsetof(VertexAttributes_Vertex_Normal_UVLayer1, vertex);
        }
        
        static size_t getNormalOffset()
        {
            return offsetof(VertexAttributes_Vertex_Normal_UVLayer1, normal);
        }
        
        static size_t getColorOffset()
        {
            return 0;
        }
        
        static size_t getTextureOffset(const unsigned int index)
        {
            if(index == 0)
                return offsetof(VertexAttributes_Vertex_UVLayer1, texture0);
            return 0;
        }
        
//        static size_t getWorldTransformOffset()
//        {
//            return offsetof(VertexAttributes_Vertex_UVLayer1, worldTransform);
//        }
        };
        
        
        ATTRIBUTE_ALIGNED16(struct) VertexAttributes_Vertex_Normal_Color_UVLayer1// : public VertexAttributes_Vertex
        {
            union
            {
                struct
                {
                    btVector3 vertex;
                    btVector3 normal;
                    btVector4 color;
                    btVector2 texture0;
                };
                btScalar verts[14];
            };
        public:
            SIMD_FORCE_INLINE	operator       btScalar *()       { return &verts[0]; }
            SIMD_FORCE_INLINE	operator const btScalar *() const { return &verts[0]; }

            operator std::string()
            {
//                std::string s(this->VertexAttributes_Vertex::operator std::string());
//                
//                char buffer[1024];
//                float x, y, z, w;
//                
//                std::string snormal, scolor, stexture0;
//                
//                x = normal.x();
//                y = normal.y();
//                z = normal.z();
//                w = normal.w();
//                sprintf(buffer,"{ %+.1f, %+.1f, %+.1f, %+.1f }", x, y, z, w);
//                snormal = buffer;
//                
//                x = color.x();
//                y = color.y();
//                z = color.z();
//                w = color.w();
//                sprintf(buffer,"{ %+.1f, %+.1f, %+.1f, %+.1f }", x, y, z, w);
//                scolor = buffer;
//                
//                x = texture0.x();
//                y = texture0.y();
//                sprintf(buffer,"{ %+.1f, %+.1f }", x, y);
//                stexture0 = buffer;
//                
//                
//                return "{ " + s + ", " + snormal + ", " + scolor + ", " + stexture0 + " }";
                
                //        char buffer[1024];
                //        float x = vertex.x();
                //        float y = vertex.y();
                //        float z = vertex.z();
                //        float w = vertex.w();
                //        sprintf(buffer,"{ $f, %f, %f, %f }", x, y, z, w);
                //        return std::string(buffer);
            }




            void setVertex(const btVector3 &v){vertex = v;}
            void setNormal(const btVector3 &v){normal = v;}
            void setColor(const btVector4 &v){color = v;}
            //void setUV0(const btVector2 &v){texture0 = v;}
            void setUV(const unsigned int index, const btVector2 &v)
            {
                if(index == 0)
                    texture0 = v;
            }

            bool getVertex(btVector3 &v)const{v = vertex;return true;}
            bool getNormal(btVector3 &v)const{return false;}
            bool getColor(btVector4 &v)const{return false;}
            bool getUV(unsigned int index, const btVector2 &v)const{return false;}
            
            VertexAttributes_Vertex_Normal_Color_UVLayer1(const btVector3 &_vertex = btVector3(),
                                                          const btVector3 &_normal = btVector3(),
                                                          const btVector4 &_color = btVector4(),
                                                          const btVector2 &_texture0 = btVector2()):
            vertex(_vertex),
            normal(_normal),
            color(_color),
            texture0(_texture0)
            {
                //DebugString::log(DebugString::btVectorStr(_vertex));
            }
            
            VertexAttributes_Vertex_Normal_Color_UVLayer1(const VertexAttributes_Vertex_Normal_Color_UVLayer1 &copy):
//            VertexAttributes_Vertex(copy.vertex),
            vertex(copy.vertex),
            normal(copy.normal),
            color(copy.color),
            texture0(copy.texture0){}
            
            VertexAttributes_Vertex_Normal_Color_UVLayer1 &operator=(const VertexAttributes_Vertex_Normal_Color_UVLayer1 &rhs)
            {
                if(this != &rhs)
                {
//                    VertexAttributes_Vertex::operator=(rhs);
                    vertex = rhs.vertex;
                    normal = rhs.normal;
                    color = rhs.color;
                    texture0 = rhs.texture0;
                }
                return *this;
            }
            
            
            static GLsizei getStride()
            {
                return (sizeof(VertexAttributes_Vertex_Normal_Color_UVLayer1));
            }
            
            static size_t getPositionOffset()
            {
                return offsetof(VertexAttributes_Vertex_Normal_Color_UVLayer1, vertex);
            }
            
            static size_t getNormalOffset()
            {
                return offsetof(VertexAttributes_Vertex_Normal_Color_UVLayer1, normal);
            }
            
            static size_t getColorOffset()
            {
                return offsetof(VertexAttributes_Vertex_Normal_Color_UVLayer1, color);
            }
            
            static size_t getTextureOffset(const unsigned int index)
            {
                if(index == 0)
                    return offsetof(VertexAttributes_Vertex_Normal_Color_UVLayer1, texture0);
                return 0;
            }
            
//            static size_t getWorldTransformOffset()
//            {
//                return offsetof(VertexAttributes_Vertex_Normal_Color_UVLayer1, worldTransform);
//            }
            };
            
            
            
            ATTRIBUTE_ALIGNED16(struct) VertexAttributes_Vertex_Color : public VertexAttributes_Vertex
            {
                btVector4 color;
            public:
                virtual void setColor(const btVector4 &v){color = v;}
                
                VertexAttributes_Vertex_Color(const btVector3 &_vertex = btVector3(),
                                              const btVector4 &_color = btVector4()):
                VertexAttributes_Vertex(_vertex),
                color(_color){}
                
                VertexAttributes_Vertex_Color(const VertexAttributes_Vertex_Color &copy):
                VertexAttributes_Vertex(copy),
                color(copy.color){}
                
                VertexAttributes_Vertex_Color &operator=(const VertexAttributes_Vertex_Color &rhs)
                {
                    if(this != &rhs)
                    {
                        VertexAttributes_Vertex::operator=(rhs);
                        color = rhs.color;
                    }
                    return *this;
                }
                
                static GLsizei getStride()
                {
                    return (sizeof(VertexAttributes_Vertex_Color));
                }
                
                static size_t getPositionOffset()
                {
                    return offsetof(VertexAttributes_Vertex_Color, vertex);
                }
                
                static size_t getNormalOffset()
                {
                    return 0;
                }
                
                static size_t getColorOffset()
                {
                    return offsetof(VertexAttributes_Vertex_Color, color);
                }
                };

#endif
