//
//  IcoSphereCreator.h
//  BaseProject
//
//  Created by library on 9/29/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

//http://blog.andreaskahler.com/2009/06/creating-icosphere-mesh-in-code.html

#ifndef __BaseProject__IcoSphereCreator__
#define __BaseProject__IcoSphereCreator__

#include "btAlignedObjectArray.h"
#include "VertexAttributesInclude.h"
#include "btHashMap.h"
#include "AbstractSingleton.h"

template<class VERTEX_ATTRIBUTE>
class IcoSphereCreator : public AbstractSingleton<IcoSphereCreator<VERTEX_ATTRIBUTE> >
{
    friend class AbstractSingleton<VERTEX_ATTRIBUTE>;
    
public:
    IcoSphereCreator(){}
    virtual ~IcoSphereCreator(){}
protected:
    struct TriangleIndices
    {
        int v1;
        int v2;
        int v3;

        TriangleIndices(int _v1 = -1, int _v2 = -1, int _v3 = -1)
        {
            v1 = _v1;
            v2 = _v2;
            v3 = _v3;
        }
    };
public:
    void create(int recursion_level,
                btAlignedObjectArray<GLushort> &indiceData,
                btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertexData);
private:
    //btAlignedObjectArray<VERTEX_ATTRIBUTE> m_VertexAttributes;
    btHashMap<btHashInt, int> m_MiddlePointIndexCache;
    
    int addVertex(const btVector3 &p, btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertexData);
    int getMiddlePoint(int p1, int p2, btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertexData);
};

template<class VERTEX_ATTRIBUTE>
int IcoSphereCreator<VERTEX_ATTRIBUTE>::addVertex(const btVector3 &p, btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertexData)
{
    VERTEX_ATTRIBUTE attribute;
    
    btVector3 normal(p.normalized());
    btVector4 color(1,1,1,1);
    btVector2 uv(0, 0);
    
    attribute.setVertex(p.normalized());
    if(VERTEX_ATTRIBUTE::getNormalOffset())
        attribute.setNormal(normal);
    if(VERTEX_ATTRIBUTE::getColorOffset())
        attribute.setColor(color);
    for(int index = 0; index < 32; index++)
        if(VERTEX_ATTRIBUTE::getTextureOffset(index))
            attribute.setUV(index, uv);
    

    attribute.setVertex(p.normalized());
    btVector4 _color(color.x(), color.y(), color.z(), 1.0f);
    attribute.setColor(_color);
    
    vertexData.push_back(attribute);
    
    return vertexData.size();
}

template<class VERTEX_ATTRIBUTE>
void IcoSphereCreator<VERTEX_ATTRIBUTE>::create(int recursion_level,
                                                btAlignedObjectArray<GLushort> &indiceData,
                                                btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertexData)
{
    m_MiddlePointIndexCache.clear();
    vertexData.clear();
    
    btScalar t = (1.0f + btSqrt(5.0f)) / 2.0f;
    
    addVertex(btVector3(-1,  t,  0), vertexData);
    addVertex(btVector3( 1,  t,  0), vertexData);
    addVertex(btVector3(-1, -t,  0), vertexData);
    addVertex(btVector3( 1, -t,  0), vertexData);
    
    addVertex(btVector3( 0, -1,  t), vertexData);
    addVertex(btVector3( 0,  1,  t), vertexData);
    addVertex(btVector3( 0, -1, -t), vertexData);
    addVertex(btVector3( 0,  1, -t), vertexData);
    
    addVertex(btVector3( t,  0, -1), vertexData);
    addVertex(btVector3( t,  0,  1), vertexData);
    addVertex(btVector3(-t,  0, -1), vertexData);
    addVertex(btVector3(-t,  0,  1), vertexData);
    
    btAlignedObjectArray<TriangleIndices> faces;
    faces.clear();
    
    // 5 faces around point 0
    faces.push_back(TriangleIndices(0, 11, 5));
    faces.push_back(TriangleIndices(0, 5, 1));
    faces.push_back(TriangleIndices(0, 1, 7));
    faces.push_back(TriangleIndices(0, 7, 10));
    faces.push_back(TriangleIndices(0, 10, 11));
    
    // 5 adjacent faces
    faces.push_back(TriangleIndices(1, 5, 9));
    faces.push_back(TriangleIndices(5, 11, 4));
    faces.push_back(TriangleIndices(11, 10, 2));
    faces.push_back(TriangleIndices(10, 7, 6));
    faces.push_back(TriangleIndices(7, 1, 8));
    
    // 5 faces around point 3
    faces.push_back(TriangleIndices(3, 9, 4));
    faces.push_back(TriangleIndices(3, 4, 2));
    faces.push_back(TriangleIndices(3, 2, 6));
    faces.push_back(TriangleIndices(3, 6, 8));
    faces.push_back(TriangleIndices(3, 8, 9));
    
    // 5 adjacent faces
    faces.push_back(TriangleIndices(4, 9, 5));
    faces.push_back(TriangleIndices(2, 4, 11));
    faces.push_back(TriangleIndices(6, 2, 10));
    faces.push_back(TriangleIndices(8, 6, 7));
    faces.push_back(TriangleIndices(9, 8, 1));
    
    // refine triangles
    for (int i = 0; i < recursion_level; i++)
    {
        btAlignedObjectArray<TriangleIndices> faces2;
        faces2.clear();
        
        for(int j = 0; j < faces.size(); j++)
        {
            TriangleIndices tri = faces.at(j);
            
            // replace triangle by 4 triangles
            int a = getMiddlePoint(tri.v1, tri.v2, vertexData);
            int b = getMiddlePoint(tri.v2, tri.v3, vertexData);
            int c = getMiddlePoint(tri.v3, tri.v1, vertexData);
            
            faces2.push_back(TriangleIndices(tri.v1, a, c));
            faces2.push_back(TriangleIndices(tri.v2, b, a));
            faces2.push_back(TriangleIndices(tri.v3, c, b));
            faces2.push_back(TriangleIndices(a, b, c));
        }
        faces = faces2;
    }
    
    indiceData.clear();
    
    for(int j = 0; j < faces.size(); j++)
    {
        TriangleIndices tri = faces.at(j);
        
        indiceData.push_back(tri.v1);
        indiceData.push_back(tri.v1);
        indiceData.push_back(tri.v1);
    }
}

template<class VERTEX_ATTRIBUTE>
int IcoSphereCreator<VERTEX_ATTRIBUTE>::getMiddlePoint(int p1, int p2, btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertexData)
{
    // first check if we have it already
    bool firstIsSmaller = p1 < p2;
    short smallerIndex = firstIsSmaller ? p1 : p2;
    short greaterIndex = firstIsSmaller ? p2 : p1;
    int key = (smallerIndex << (sizeof(short) * 8)) + greaterIndex;
    int *ret = m_MiddlePointIndexCache.find(btHashInt(key));
    if(ret)
        return *ret;
    
    btVector3 point1;
    vertexData.at(p1).getVertex(point1);
    
    btVector3 point2;
    vertexData.at(p2).getVertex(point1);
    
    btVector3 middle(point1.x() + point2.x() / 2.0f,
                     point1.y() + point2.y() / 2.0f,
                     point1.z() + point2.z() / 2.0f);
    
    // add vertex makes sure point is on unit sphere
    int i = addVertex(middle, vertexData);
    // store it, return index
    m_MiddlePointIndexCache.insert(btHashInt(key), i);
    
    return i;
}

#endif /* defined(__BaseProject__IcoSphereCreator__) */
