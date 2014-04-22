//
//  VertexAttributeLoader.h
//  GameAsteroids
//
//  Created by James Folk on 5/20/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__VertexAttributeLoader__
#define __GameAsteroids__VertexAttributeLoader__

#include "AbstractSingleton.h"
#include "LinearMath/btAlignedObjectArray.h"
#include "BaseEntity.h"
#include "BaseViewObject.h"
#include "ZipFileResourceLoader.h"
//#include "MazeViewObjectTypes.h"
#include "IcoSphereCreator.h"

class BaseEntity;

class VertexAttributeLoader : public AbstractSingleton<VertexAttributeLoader>
{
    friend class AbstractSingleton;
    
    VertexAttributeLoader();
    virtual ~VertexAttributeLoader();

public:
    template<class VERTEX_ATTRIBUTE>
    static void load(BaseViewObject *vo,
                     const btAlignedObjectArray<VERTEX_ATTRIBUTE> &,
                     GLenum array_usage = GL_DYNAMIC_DRAW);
    
    template<class VERTEX_ATTRIBUTE>
    static void load(BaseViewObject *vo,
                     const btAlignedObjectArray<GLushort> &,
                     const btAlignedObjectArray<VERTEX_ATTRIBUTE> &,
                     GLenum indice_usage = GL_DYNAMIC_DRAW,
                     GLenum array_usage = GL_DYNAMIC_DRAW);

    template<class VERTEX_ATTRIBUTE>
    static void reLoad(BaseViewObject *vo,
                       const btAlignedObjectArray<VERTEX_ATTRIBUTE> &);
    
    template<class VERTEX_ATTRIBUTE>
    void createbtAlignedObjectArray(const std::string &objectName,
                                    btAlignedObjectArray<GLushort> &indiceData,
                                    btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertexData,
                                    const btTransform &transform = btTransform::getIdentity());
    
    template<class VERTEX_ATTRIBUTE>
    void createbtAlignedObjectArray(const unsigned int size,
                                    btAlignedObjectArray<GLushort> &indiceData,
                                    btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertexData,
                                    const btTransform &transform = btTransform::getIdentity(),
                                    const btVector3 &emptyVertex = btVector3(0,0,0),
                                    const btVector3 &emptyNormal = btVector3(0,0,0),
                                    const btVector4 &emptyColor = btVector4(1,0,0,1),
                                    const btVector2 &emptyUV = btVector2(0,0));
    
    template<class VERTEX_ATTRIBUTE>
    void createSpriteVertices(btAlignedObjectArray<GLushort> &indiceData,
                              btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertexData);
    
    template<class VERTEX_ATTRIBUTE>
    void createIcoSphereVertices(btAlignedObjectArray<GLushort> &indiceData,
                                 btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertexData);
protected:
    btVector2 createVector2(NSArray *fromArray)const;
    btVector3 createVector3(NSArray *fromArray)const;
    btVector4 createVector4(NSArray *fromArray)const;
    btTransform createTransform(NSArray *fromArray)const;
    void createVector2Array(NSArray *fromArray, btAlignedObjectArray<btVector2> &toArray)const;
    void createVector3Array(NSArray *fromArray, btAlignedObjectArray<btVector3> &toArray)const;
    void createVector4Array(NSArray *fromArray, btAlignedObjectArray<btVector4> &toArray)const;
    void createIntArray(NSArray *fromArray, btAlignedObjectArray<GLushort> &toArray)const;

};

template<class VERTEX_ATTRIBUTE>
void VertexAttributeLoader::load(BaseViewObject *vo,
                                 const btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertexData,
                                 GLenum array_usage)
{
    
    vo->setVertexAttributeProperties(VERTEX_ATTRIBUTE::getStride(),
                                     VERTEX_ATTRIBUTE::getPositionOffset(),
//                                     VERTEX_ATTRIBUTE::getWorldTransformOffset(),
                                     VERTEX_ATTRIBUTE::getNormalOffset(),
                                     VERTEX_ATTRIBUTE::getColorOffset(),
                                     VERTEX_ATTRIBUTE::getTextureOffset(0),
                                     vertexData.size());
    
    vo->load(vertexData.size() * VERTEX_ATTRIBUTE::getStride(),
                       &vertexData[0],
                       array_usage);
    
    for(int i = 0; i < 32; i++)
    {
        if(VERTEX_ATTRIBUTE::getTextureOffset(i) != 0)
            vo->enableGLSLTexture(i, true);
    }
    
    if(VERTEX_ATTRIBUTE::getColorOffset() != 0)
        vo->enableGLSLVertexColor(true);
    
    if(VERTEX_ATTRIBUTE::getNormalOffset() != 0)
        vo->enableGLSLNormal(true);
}


template<class VERTEX_ATTRIBUTE>
void VertexAttributeLoader::load(BaseViewObject *vo,
                                 const btAlignedObjectArray<GLushort> &indiceData,
                                 const btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertexData,
                                 GLenum indice_usage,
                                 GLenum array_usage)
{

    vo->setVertexAttributeProperties(VERTEX_ATTRIBUTE::getStride(),
                                     VERTEX_ATTRIBUTE::getPositionOffset(),
//                                     VERTEX_ATTRIBUTE::getWorldTransformOffset(),
                                     VERTEX_ATTRIBUTE::getNormalOffset(),
                                     VERTEX_ATTRIBUTE::getColorOffset(),
                                     VERTEX_ATTRIBUTE::getTextureOffset(0),
                                     vertexData.size(),
                                     indiceData.size());
    
    vo->load(indiceData.size() * sizeof(indiceData[0]),
             &indiceData[0],
             vertexData.size() * VERTEX_ATTRIBUTE::getStride(),
             &vertexData[0],
             indice_usage,
             array_usage);
    
    for(int i = 0; i < 32; i++)
    {
        if(VERTEX_ATTRIBUTE::getTextureOffset(i) != 0)
            vo->enableGLSLTexture(i, true);
    }

    if(VERTEX_ATTRIBUTE::getColorOffset() != 0)
        vo->enableGLSLVertexColor(true);
    
    if(VERTEX_ATTRIBUTE::getNormalOffset() != 0)
        vo->enableGLSLNormal(true);
}

template<class VERTEX_ATTRIBUTE>
void VertexAttributeLoader::reLoad(BaseViewObject *vo,
                                   const btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertexData)
{
    
    vo->setVertexAttributeProperties(VERTEX_ATTRIBUTE::getStride(),
                                     VERTEX_ATTRIBUTE::getPositionOffset(),
//                                     VERTEX_ATTRIBUTE::getWorldTransformOffset(),
                                     VERTEX_ATTRIBUTE::getNormalOffset(),
                                     VERTEX_ATTRIBUTE::getColorOffset(),
                                     VERTEX_ATTRIBUTE::getTextureOffset(0),
                                     vertexData.size());
    
    vo->reLoad(vertexData.size() * VERTEX_ATTRIBUTE::getStride(),
                         &vertexData[0]);
}

template<class VERTEX_ATTRIBUTE>
void VertexAttributeLoader::createbtAlignedObjectArray(const std::string &objectName,
                                                       btAlignedObjectArray<GLushort> &indiceData,
                                                       btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertexData,
                                                       const btTransform &transform)
{
    indiceData.clear();
    vertexData.clear();
    
    const BaseMeshObject *pBaseMeshObject = ZipFileResourceLoader::getInstance()->getMeshObject(objectName);
    const MeshObject<VERTEX_ATTRIBUTE> *pMeshObject = dynamic_cast<const MeshObject<VERTEX_ATTRIBUTE> *>(pBaseMeshObject);
    
    pMeshObject->getIndices(indiceData);
    pMeshObject->getAttributes(vertexData, transform);
    
    
    
    
//    ViewObjectData *voData = getViewObject(objectName);
//    bool hasNormal = (voData->m_NormalList.size() > 0)?true:false;
//    bool hasColor = (voData->m_ColorList.size() > 0)?true:false;
//    bool hasUV[32];
//    for(int i = 0; i < 32; i++)
//        hasUV[i] = (voData->m_UVList[i].size() > 0)?true:false;
//    
//    indiceData.copyFromArray(voData->m_IndiceList);
//    
//    VERTEX_ATTRIBUTE temp;
//    for(int i = 0; i < voData->m_VerticeList.size(); i++)
//    {
//        btVector3 vertice = transform * voData->m_VerticeList[i];
//        temp.setVertex(vertice);
//        
//        if(VERTEX_ATTRIBUTE::getNormalOffset())
//        {
//            if(hasNormal)
//                temp.setNormal(voData->m_NormalList[i]);
//        }
//        
//        if(VERTEX_ATTRIBUTE::getColorOffset())
//        {
//            if(hasColor)
//                temp.setColor(voData->m_ColorList[i]);
//        }
//        
//        for(int index = 0; index < 32; index++)
//        {
//            if(VERTEX_ATTRIBUTE::getTextureOffset(index))
//            {
//                if(hasUV[index])
//                {
//                    temp.setUV(index, voData->m_UVList[index][i]);
//                }
//            }
//        }
//        
//        vertexData.push_back(temp);
//    }
}










template<class VERTEX_ATTRIBUTE>
void VertexAttributeLoader::createbtAlignedObjectArray(const unsigned int size,
                                                       btAlignedObjectArray<GLushort> &indiceData,
                                                       btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertexData,
                                                       const btTransform &transform,
                                                       const btVector3 &emptyVertex,
                                                       const btVector3 &emptyNormal,
                                                       const btVector4 &emptyColor,
                                                       const btVector2 &emptyUV)
{
    int index = 0;
    
    indiceData.clear();
    vertexData.clear();
    
    VERTEX_ATTRIBUTE temp;
    for(int i = 0; i < size; i++)
    {
        btVector3 vertice = transform * emptyVertex;
        temp.setVertex(vertice);
        
        if(VERTEX_ATTRIBUTE::getNormalOffset())
            temp.setNormal(emptyNormal);
        
        if(VERTEX_ATTRIBUTE::getColorOffset())
            temp.setColor(emptyColor);
        
        for(int index = 0; index < 32; index++)
            if(VERTEX_ATTRIBUTE::getTextureOffset(index))
                temp.setUV(index, emptyUV);
        
        vertexData.push_back(temp);
        indiceData.push_back(index++);
    }
}

template<class VERTEX_ATTRIBUTE>
void VertexAttributeLoader::createSpriteVertices(btAlignedObjectArray<GLushort> &indiceData,
                                                 btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertexData)
{
    VertexAttributeLoader::getInstance()->createbtAlignedObjectArray(6, indiceData, vertexData);
    
    btVector3 normal(0, 1, 0);
    btVector4 color(1,1,1,1);
    
    indiceData[0] = 0;
    indiceData[1] = 1;
    indiceData[2] = 2;
    indiceData[3] = 3;
    indiceData[4] = 4;
    indiceData[5] = 5;
    
    vertexData[0].setVertex(btVector3(-0.5, 0.5, 0.0));//left - top
    if(VERTEX_ATTRIBUTE::getNormalOffset())
        vertexData[0].setNormal(normal);
    if(VERTEX_ATTRIBUTE::getColorOffset())
        vertexData[0].setColor(color);
    for(int index = 0; index < 32; index++)
        if(VERTEX_ATTRIBUTE::getTextureOffset(index))
            vertexData[0].setUV(index, btVector2(0.0, 1.0));
    
    
    vertexData[1].setVertex(btVector3(0.5, 0.5, 0.0));//right - top
    if(VERTEX_ATTRIBUTE::getNormalOffset())
        vertexData[1].setNormal(normal);
    if(VERTEX_ATTRIBUTE::getColorOffset())
        vertexData[1].setColor(color);
    for(int index = 0; index < 32; index++)
        if(VERTEX_ATTRIBUTE::getTextureOffset(index))
            vertexData[1].setUV(index, btVector2(1.0, 1.0));
    
    vertexData[2].setVertex(btVector3(0.5, -0.5, 0.0));//right - bottom
    if(VERTEX_ATTRIBUTE::getNormalOffset())
        vertexData[2].setNormal(normal);
    if(VERTEX_ATTRIBUTE::getColorOffset())
        vertexData[2].setColor(color);
    for(int index = 0; index < 32; index++)
        if(VERTEX_ATTRIBUTE::getTextureOffset(index))
            vertexData[2].setUV(index, btVector2(1.0, 0.0));
    
    vertexData[3].setVertex(btVector3(-0.5, -0.5, 0.0));//left - bottom
    if(VERTEX_ATTRIBUTE::getNormalOffset())
        vertexData[3].setNormal(normal);
    if(VERTEX_ATTRIBUTE::getColorOffset())
        vertexData[3].setColor(color);
    for(int index = 0; index < 32; index++)
        if(VERTEX_ATTRIBUTE::getTextureOffset(index))
            vertexData[3].setUV(index, btVector2(0.0, 0.0));
    
    vertexData[4].setVertex(btVector3(-0.5, 0.5, 0.0));//left - top
    if(VERTEX_ATTRIBUTE::getNormalOffset())
        vertexData[4].setNormal(normal);
    if(VERTEX_ATTRIBUTE::getColorOffset())
        vertexData[4].setColor(color);
    for(int index = 0; index < 32; index++)
        if(VERTEX_ATTRIBUTE::getTextureOffset(index))
            vertexData[4].setUV(index, btVector2(0.0, 1.0));
    
    vertexData[5].setVertex(btVector3(0.5, -0.5, 0.0));//right - bottom
    if(VERTEX_ATTRIBUTE::getNormalOffset())
        vertexData[5].setNormal(normal);
    if(VERTEX_ATTRIBUTE::getColorOffset())
        vertexData[5].setColor(color);
    for(int index = 0; index < 32; index++)
        if(VERTEX_ATTRIBUTE::getTextureOffset(index))
            vertexData[5].setUV(index, btVector2(1.0, 0.0));
}

template<class VERTEX_ATTRIBUTE>
void VertexAttributeLoader::createIcoSphereVertices(btAlignedObjectArray<GLushort> &indiceData,
                                                    btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertexData)
{
    IcoSphereCreator<VERTEX_ATTRIBUTE>::createInstance();
    IcoSphereCreator<VERTEX_ATTRIBUTE>::getInstance()->create(5, indiceData, vertexData);
    IcoSphereCreator<VERTEX_ATTRIBUTE>::destroyInstance();
}

#endif /* defined(__GameAsteroids__VertexAttributeLoader__) */
