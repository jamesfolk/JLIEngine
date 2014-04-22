//
//  GLDebugDrawer.h
//  GameAsteroids
//
//  Created by James Folk on 3/13/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__GLDebugDrawer__
#define __GameAsteroids__GLDebugDrawer__


#include "BaseViewObject.h"
#include "LinearMath/btIDebugDraw.h"
#include "AbstractSingleton.h"

//#include "DebugLineView.h"

class GLDebugDrawer : public btIDebugDraw, public AbstractSingleton<GLDebugDrawer>
{
    //BaseViewObject *m_pBaseViewObject;
    btAlignedObjectArray<VertexAttributes_Vertex_Color> m_lineVertexData;
    btAlignedObjectArray<VertexAttributes_Vertex_Color> m_sphereVertexData;
    btAlignedObjectArray<GLushort> m_sphereIndices;
    
    //IDType m_shaderFactoryID;
    
    int m_debugMode;
    
    IDType m_LineViewObjectFactoryID;
    IDType m_IcoSphereViewObjectFactoryID;
    
    BaseCamera *pCurrentCamera;
    
    BaseViewObject *getLineVBO();
    BaseViewObject *getIcoSphereVBO();
public:
    void setShaderFactoryID(const IDType ID);
    void setOrthoCamera();
    void setProjectionCamera();
    BaseCamera *getCurrentCamera();
    void setCurrentCamera(BaseCamera *camera);
    
    GLDebugDrawer();
    virtual ~GLDebugDrawer();
    
    virtual void    drawLine(const btVector3& from,const btVector3& to,const btVector3& fromColor, const btVector3& toColor);
    
    virtual void    drawLine(const btVector3& from,const btVector3& to,const btVector3& color);
    
    virtual void    drawSphere (const btVector3& p, btScalar radius, const btVector3& color);
    virtual void    drawBox (const btVector3& boxMin, const btVector3& boxMax, const btVector3& color, btScalar alpha);
    
    virtual void    drawTriangle(const btVector3& a,const btVector3& b,const btVector3& c,const btVector3& color,btScalar alpha);
    
    virtual void    drawContactPoint(const btVector3& PointOnB,const btVector3& normalOnB,btScalar distance,int lifeTime,const btVector3& color);
    
    virtual void    reportErrorWarning(const char* warningString);
    
    virtual void    draw3dText(const btVector3& location,const char* textString);
    
    virtual void    setDebugMode(int debugMode);
    
    virtual int             getDebugMode() const { return m_debugMode;}
private:
    typedef btAlignedObjectArray<IDType> LocalizedTextArray;
    typedef btAlignedObjectArray<LocalizedTextArray*> MultipleLocalizedTextArrays;

    void unInit3DText();
    void init3dText(const unsigned int max_lines = 16);
    void init3dTextArray(LocalizedTextArray &array,
                         const unsigned int max_length = 32);
    void draw3dText(const btVector3 &location,
                    const char *textString,
                    unsigned int array_index);

    

    MultipleLocalizedTextArrays m_MultipleLocalizedTextArrays;
    int m_CurrentIndexOfMultipleLocalizedTextArrays;

};

#endif /* defined(__GameAsteroids__GLDebugDrawer__) */
