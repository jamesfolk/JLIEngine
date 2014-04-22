//
//  BaseCamera.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/29/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "BaseCamera.h"

#include "UtilityFunctions.h"
#include "CameraFactory.h"
#include "BaseEntity.h"

#include "WorldPhysics.h"


//BaseCamera *BaseCamera::create(int type)
//{
//    return dynamic_cast<BaseCamera*>(CameraFactory::getInstance()->createObject(type));
//}
//
//bool BaseCamera::destroy(IDType &_id)
//{
//    return CameraFactory::getInstance()->destroy(_id);
//}
//
//bool BaseCamera::destroy(BaseCamera *entity)
//{
//    bool ret = false;
//    if(entity)
//    {
//        IDType _id = entity->getID();
//        ret = BaseCamera::destroy(_id);
//    }
//    entity = NULL;
//    return ret;
//}
//
//BaseCamera *BaseCamera::get(IDType _id)
//{
//    return dynamic_cast<BaseCamera*>(CameraFactory::getInstance()->get(_id));
//}

//btVector3 *BaseCamera::s_c00 = NULL;
//btVector3 *BaseCamera::s_c10 = NULL;
//btVector3 *BaseCamera::s_c01 = NULL;
//btVector3 *BaseCamera::s_c11 = NULL;

static void updatePlanes(const btVector3 &rotationAxis,
                         const btScalar &rotationAngle,
                         const btVector3 &origin,
                         const btVector3 &heading,
                         const btScalar far,
                         btVector3 *planeNormals,
                         btScalar *planeOffsets);



void BaseCamera::updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep)
{
    //updateProjection();
//    updateALOrientation();
}
void BaseCamera::debugDraw(btIDebugDraw* debugDrawer)
{
    btVector3 color(1.0f, 0.0f, 0.0f);
    
    debugDrawer->drawLine(getOrigin(), getOrigin() + (getHeadingVector() * getFar()), color);
//    debugDrawer->drawLine(getOrigin(), getOrigin() + (getUpVector() * getFar()), color);
    
    btVector3 topRight(getOrigin() + (getTopRightVector() * getFar()));
    btVector3 topLeft(getOrigin() + (getTopLeftVector() * getFar()));
    btVector3 bottomRight(getOrigin() + (getBottomRightVector() * getFar()));
    btVector3 bottomLeft(getOrigin() + (getBottomLeftVector() * getFar()));
    
    debugDrawer->drawLine(getOrigin(), topRight, color);
    debugDrawer->drawLine(getOrigin(), topLeft, color);
    debugDrawer->drawLine(getOrigin(), bottomRight, color);
    debugDrawer->drawLine(getOrigin(), bottomLeft, color);
    
    debugDrawer->drawLine(topRight, topLeft, color);
    debugDrawer->drawLine(topLeft, bottomLeft, color);
    debugDrawer->drawLine(bottomLeft, bottomRight, color);
    debugDrawer->drawLine(bottomRight, topRight, color);
}
BaseCamera::BaseCamera(const BaseCameraInfo& constructionInfo) :

//m_fieldOfViewDegrees(constructionInfo.m_fieldOfViewDegrees),
//m_nearZ(constructionInfo.m_nearZ),
//m_farZ(constructionInfo.m_farZ),
//m_top(constructionInfo.m_top),
//m_bottom(constructionInfo.m_bottom),
//m_left(constructionInfo.m_left),
//m_right(constructionInfo.m_right),
//m_projectionMatrix(GLKMatrix4Identity),
m_projectionMatrix2(btTransform::getIdentity()),
m_BaseCameraInfo(new BaseCameraInfo(constructionInfo)),
//m_IsOrthographicCamera(constructionInfo.m_IsOrthographicCamera)
m_Orientation(new GLfloat[6])
{
    updateProjection();
    
//    if(!s_c00)
//    {
//        s_c00 = new btVector3();
//        s_c10 = new btVector3();
//        s_c01 = new btVector3();
//        s_c11 = new btVector3();
//    }
}

BaseCamera::BaseCamera() :

//m_projectionMatrix(GLKMatrix4Identity),
m_projectionMatrix2(btTransform::getIdentity()),
m_BaseCameraInfo(new BaseCameraInfo()),
m_Orientation(new GLfloat[6])
{
    
    
    updateProjection();
    
//    if(!s_c00)
//    {
//        s_c00 = new btVector3();
//        s_c10 = new btVector3();
//        s_c01 = new btVector3();
//        s_c11 = new btVector3();
//    }
}

BaseCamera::~BaseCamera()
{
    delete [] m_Orientation;
    m_Orientation = NULL;
    
    delete m_BaseCameraInfo;
    m_BaseCameraInfo = NULL;
}








static void __gluMultMatrixVecd(const GLfloat matrix[16], const GLfloat in[4],
                                GLfloat out[4])
{
    int i;
    
    for (i=0; i<4; i++) {
        out[i] =
	    in[0] * matrix[0*4+i] +
	    in[1] * matrix[1*4+i] +
	    in[2] * matrix[2*4+i] +
	    in[3] * matrix[3*4+i];
    }
}

/*
 ** Invert 4x4 matrix.
 ** Contributed by David Moore (See Mesa bug #6748)
 */
static int __gluInvertMatrixd(const GLfloat m[16], GLfloat invOut[16])
{
    float inv[16], det;
    int i;
    
    inv[0] =   m[5]*m[10]*m[15] - m[5]*m[11]*m[14] - m[9]*m[6]*m[15]
    + m[9]*m[7]*m[14] + m[13]*m[6]*m[11] - m[13]*m[7]*m[10];
    inv[4] =  -m[4]*m[10]*m[15] + m[4]*m[11]*m[14] + m[8]*m[6]*m[15]
    - m[8]*m[7]*m[14] - m[12]*m[6]*m[11] + m[12]*m[7]*m[10];
    inv[8] =   m[4]*m[9]*m[15] - m[4]*m[11]*m[13] - m[8]*m[5]*m[15]
    + m[8]*m[7]*m[13] + m[12]*m[5]*m[11] - m[12]*m[7]*m[9];
    inv[12] = -m[4]*m[9]*m[14] + m[4]*m[10]*m[13] + m[8]*m[5]*m[14]
    - m[8]*m[6]*m[13] - m[12]*m[5]*m[10] + m[12]*m[6]*m[9];
    inv[1] =  -m[1]*m[10]*m[15] + m[1]*m[11]*m[14] + m[9]*m[2]*m[15]
    - m[9]*m[3]*m[14] - m[13]*m[2]*m[11] + m[13]*m[3]*m[10];
    inv[5] =   m[0]*m[10]*m[15] - m[0]*m[11]*m[14] - m[8]*m[2]*m[15]
    + m[8]*m[3]*m[14] + m[12]*m[2]*m[11] - m[12]*m[3]*m[10];
    inv[9] =  -m[0]*m[9]*m[15] + m[0]*m[11]*m[13] + m[8]*m[1]*m[15]
    - m[8]*m[3]*m[13] - m[12]*m[1]*m[11] + m[12]*m[3]*m[9];
    inv[13] =  m[0]*m[9]*m[14] - m[0]*m[10]*m[13] - m[8]*m[1]*m[14]
    + m[8]*m[2]*m[13] + m[12]*m[1]*m[10] - m[12]*m[2]*m[9];
    inv[2] =   m[1]*m[6]*m[15] - m[1]*m[7]*m[14] - m[5]*m[2]*m[15]
    + m[5]*m[3]*m[14] + m[13]*m[2]*m[7] - m[13]*m[3]*m[6];
    inv[6] =  -m[0]*m[6]*m[15] + m[0]*m[7]*m[14] + m[4]*m[2]*m[15]
    - m[4]*m[3]*m[14] - m[12]*m[2]*m[7] + m[12]*m[3]*m[6];
    inv[10] =  m[0]*m[5]*m[15] - m[0]*m[7]*m[13] - m[4]*m[1]*m[15]
    + m[4]*m[3]*m[13] + m[12]*m[1]*m[7] - m[12]*m[3]*m[5];
    inv[14] = -m[0]*m[5]*m[14] + m[0]*m[6]*m[13] + m[4]*m[1]*m[14]
    - m[4]*m[2]*m[13] - m[12]*m[1]*m[6] + m[12]*m[2]*m[5];
    inv[3] =  -m[1]*m[6]*m[11] + m[1]*m[7]*m[10] + m[5]*m[2]*m[11]
    - m[5]*m[3]*m[10] - m[9]*m[2]*m[7] + m[9]*m[3]*m[6];
    inv[7] =   m[0]*m[6]*m[11] - m[0]*m[7]*m[10] - m[4]*m[2]*m[11]
    + m[4]*m[3]*m[10] + m[8]*m[2]*m[7] - m[8]*m[3]*m[6];
    inv[11] = -m[0]*m[5]*m[11] + m[0]*m[7]*m[9] + m[4]*m[1]*m[11]
    - m[4]*m[3]*m[9] - m[8]*m[1]*m[7] + m[8]*m[3]*m[5];
    inv[15] =  m[0]*m[5]*m[10] - m[0]*m[6]*m[9] - m[4]*m[1]*m[10]
    + m[4]*m[2]*m[9] + m[8]*m[1]*m[6] - m[8]*m[2]*m[5];
    
    det = m[0]*inv[0] + m[1]*inv[4] + m[2]*inv[8] + m[3]*inv[12];
    if (det == 0)
        return GL_FALSE;
    
    det = 1.0 / det;
    
    for (i = 0; i < 16; i++)
        invOut[i] = inv[i] * det;
    
    return GL_TRUE;
}

static void __gluMultMatricesd(const GLfloat a[16], const GLfloat b[16],
                               GLfloat r[16])
{
    int i, j;
    
    for (i = 0; i < 4; i++) {
        for (j = 0; j < 4; j++) {
            r[i*4+j] =
            a[i*4+0]*b[0*4+j] +
            a[i*4+1]*b[1*4+j] +
            a[i*4+2]*b[2*4+j] +
            a[i*4+3]*b[3*4+j];
        }
    }
}

GLint gluProject(GLfloat objx, GLfloat objy, GLfloat objz,
                 const GLfloat modelMatrix[16],
                 const GLfloat projMatrix[16],
                 const GLint viewport[4],
                 GLfloat *winx, GLfloat *winy, GLfloat *winz)
{
    float in[4];
    float out[4];
    
    in[0]=objx;
    in[1]=objy;
    in[2]=objz;
    in[3]=1.0;
    __gluMultMatrixVecd(modelMatrix, in, out);
    __gluMultMatrixVecd(projMatrix, out, in);
    if (in[3] == 0.0) return(GL_FALSE);
    in[0] /= in[3];
    in[1] /= in[3];
    in[2] /= in[3];
    /* Map x, y and z to range 0-1 */
    in[0] = in[0] * 0.5 + 0.5;
    in[1] = in[1] * 0.5 + 0.5;
    in[2] = in[2] * 0.5 + 0.5;
    
    /* Map x,y to viewport */
    in[0] = in[0] * viewport[2] + viewport[0];
    in[1] = in[1] * viewport[3] + viewport[1];
    
    *winx=in[0];
    *winy=in[1];
    *winz=in[2];
    return(GL_TRUE);
}

static GLint
gluUnProject(GLfloat winx, GLfloat winy, GLfloat winz,
             const GLfloat modelMatrix[16],
             const GLfloat projMatrix[16],
             const GLint viewport[4],
             GLfloat *objx, GLfloat *objy, GLfloat *objz)
{
    float finalMatrix[16];
    float in[4];
    float out[4];
    
    __gluMultMatricesd(modelMatrix, projMatrix, finalMatrix);
    if (!__gluInvertMatrixd(finalMatrix, finalMatrix)) return(GL_FALSE);
    
    in[0]=winx;
    in[1]=winy;
    in[2]=winz;
    in[3]=1.0;
    
    /* Map x and y from window coordinates */
    in[0] = (in[0] - viewport[0]) / viewport[2];
    in[1] = (in[1] - viewport[1]) / viewport[3];
    
    /* Map to range -1 to 1 */
    in[0] = in[0] * 2 - 1;
    in[1] = in[1] * 2 - 1;
    in[2] = in[2] * 2 - 1;
    
    __gluMultMatrixVecd(finalMatrix, in, out);
    if (out[3] == 0.0) return(GL_FALSE);
    out[0] /= out[3];
    out[1] /= out[3];
    out[2] /= out[3];
    *objx = out[0];
    *objy = out[1];
    *objz = out[2];
    return(GL_TRUE);
}
//static btVector3 ComputeWorldRay(int xs, int ys, const GLKMatrix4 &projMatrix)
//{
//	GLint viewPort[4] =
//    {
//        0,
//        0,
//        static_cast<GLint>(CameraFactory::getScreenWidth()),
//        static_cast<GLint>(CameraFactory::getScreenHeight())
//    };
//	GLKMatrix4 modelMatrix = GLKMatrix4Identity;
////	GLKMatrix4 projMatrix = CameraFactory::getInstance()->getCurrentCamera()->getProjection();
////	glGetIntegerv(GL_VIEWPORT, viewPort);
//	//glGetDoublev(GL_MODELVIEW_MATRIX, modelMatrix);
//	//glGetDoublev(GL_PROJECTION_MATRIX, projMatrix);
//	ys = viewPort[3] - ys - 1;
//	GLfloat wx0, wy0, wz0;
//    
//    gluUnProject((GLfloat)xs,
//                 (GLfloat)ys,
//                 0.0,
//                 modelMatrix.m,
//                 projMatrix.m,
//                 viewPort,
//                 &wx0,
//                 &wy0,
//                 &wz0);
//	
//    /*gluUnProject(GLfloat winx, GLfloat winy, GLfloat winz,
//     const GLfloat modelMatrix[16],
//     const GLfloat projMatrix[16],
//     const GLint viewport[4],
//     GLfloat *objx, GLfloat *objy, GLfloat *objz)*/
//	GLfloat wx1, wy1, wz1;
//	gluUnProject((GLfloat)xs,
//                 (GLfloat)ys,
//                 1.0,
//                 modelMatrix.m,
//                 projMatrix.m,
//                 viewPort,
//                 &wx1,
//                 &wy1,
//                 &wz1);
//	btVector3 tmp(float(wx1-wx0), float(wy1-wy0), float(wz1-wz0));
//	tmp.normalize();
//	return tmp;
//}






static btVector3 ComputeWorldRay(int xs, int ys, const btTransform &projMatrix)
{
	GLint viewPort[4] =
    {
        0,
        0,
        static_cast<GLint>(CameraFactory::getScreenWidth()),
        static_cast<GLint>(CameraFactory::getScreenHeight())
    };
    
    btTransform modMatrix(btTransform::getIdentity());
    btScalar modelMatrix[16];
    modMatrix.getOpenGLMatrix(modelMatrix);
    
	ys = viewPort[3] - ys - 1;
	GLfloat wx0, wy0, wz0;
    
    btScalar *projectionMatrix = new btScalar[16];
    projMatrix.getOpenGLMatrix(projectionMatrix);
    
    gluUnProject((GLfloat)xs,
                 (GLfloat)ys,
                 0.0,
                 modelMatrix,
                 projectionMatrix,
                 viewPort,
                 &wx0,
                 &wy0,
                 &wz0);
	
    /*gluUnProject(GLfloat winx, GLfloat winy, GLfloat winz,
     const GLfloat modelMatrix[16],
     const GLfloat projMatrix[16],
     const GLint viewport[4],
     GLfloat *objx, GLfloat *objy, GLfloat *objz)*/
	GLfloat wx1, wy1, wz1;
	gluUnProject((GLfloat)xs,
                 (GLfloat)ys,
                 1.0,
                 modelMatrix,
                 projectionMatrix,
                 viewPort,
                 &wx1,
                 &wy1,
                 &wz1);
	btVector3 tmp(float(wx1-wx0), float(wy1-wy0), float(wz1-wz0));
	tmp.normalize();
    delete [] projectionMatrix;
	return tmp;
}

//static void updatePlanes(const btVector3 &rotationAxis,
//                         const btScalar &rotationAngle,
//                         const btVector3 &origin,
//                         const btVector3 &heading,
//                         const btScalar far,
//                         const GLKMatrix4 &projection,
//                         btVector3 *planeNormals,
//                         btScalar *planeOffsets)
//{
//    const int			margin=0;
//	const int			lc=margin;
//	const int			rc=CameraFactory::getScreenWidth();
//	const int			tc=margin;
//	const int			bc=CameraFactory::getScreenHeight();
//	
//    const btVector3		&c00(ComputeWorldRay(lc,tc, projection).rotate(rotationAxis, rotationAngle));
//    const btVector3		&c10(ComputeWorldRay(rc,tc, projection).rotate(rotationAxis, rotationAngle));
//    const btVector3		&c01(ComputeWorldRay(lc,bc, projection).rotate(rotationAxis, rotationAngle));
//    const btVector3		&c11(ComputeWorldRay(rc,bc, projection).rotate(rotationAxis, rotationAngle));
//    
//    *BaseCamera::s_c00 = c00;
//    *BaseCamera::s_c01 = c01;
//    *BaseCamera::s_c10 = c10;
//    *BaseCamera::s_c11 = c11;
//    
//	planeNormals[0]	=	c01.cross(c00).normalized();
//	planeNormals[1]	=	c10.cross(c11).normalized();
//	planeNormals[2]	=	c00.cross(c10).normalized();
//	planeNormals[3]	=	c11.cross(c01).normalized();
//	planeNormals[4]	=	-heading;
//	planeOffsets[4]	=	-(origin+heading*(far)).dot(planeNormals[4]);
//	for(int i=0;i<4;++i)
//        planeOffsets[i]=-(origin.dot(planeNormals[i]));
//}


void BaseCamera::setOrigin(const btVector3 &pos)
{
//    m_UpdatePlanes = true;
}

void BaseCamera::setRotation(const btQuaternion &rot)
{
//    m_UpdatePlanes = true;
}

void BaseCamera::cull(btDbvtBroadphase*	pbp)
{
//    if(m_UpdatePlanes)
//    {
//        updatePlanes(getRotation().getAxis(),
//                     getRotation().getAngle(),
//                     getOrigin(),
//                     getHeadingVector(),
//                     getFar(),
//                     getProjection(),
//                     m_planeNormals,
//                     m_planeOffsets);
//        m_UpdatePlanes = false;
//    }
    
    CameraFactory::render(pbp->m_sets[1].m_root,
                          pbp->m_sets[0].m_root,
//                          m_planeNormals,
//                          m_planeOffsets,
                          getHeadingVector());
}
//GLKMatrix4 BaseCamera::getProjection()const
//{
//    btScalar m[16];
//    getFrom4x4Matrix(m_projectionMatrix2, m);
//    GLKMatrix4 m1 =
//    {
//        m[0], m[1], m[2], m[3],
//        m[4], m[5], m[6], m[7],
//        m[8], m[9], m[10], m[11],
//        m[12], m[13], m[14], m[15]
//    };
//    
//    return m1;
////    return m_projectionMatrix;
//}

btTransform BaseCamera::getProjection2()const
{
    return m_projectionMatrix2;
}
//void BaseCamera::adjustTransform(GLfloat delta, GLfloat pz)
//{
//    GLfloat numerator = -2.0f * getFar() * getNear() * delta;
//    GLfloat denominator = ((getFar() + getNear()) * pz * (pz + delta));
//    GLfloat epsilon = numerator / denominator;
//    //GLfloat epsilon = -2.0F * m_farZ * m_nearZ * delta / ((m_farZ + m_nearZ) * pz * (pz + delta));
//    
//    // Modify entry (3,3) of the projection matrix
//    m_projectionMatrix.m[10] *= 1.0F + epsilon;
//}

void BaseCamera::setPerspective(btScalar near, btScalar far, btScalar fieldOfView)
{
    btAssert(near < far);
    
    m_BaseCameraInfo->m_fieldOfViewDegrees = fmod(fieldOfView, 360.0f);
    m_BaseCameraInfo->m_nearZ = near;
    m_BaseCameraInfo->m_farZ = far;
    
    btScalar deg = getFieldOfViewDegrees() * 0.5f;
    
    m_BaseCameraInfo->m_top = getNear() * btTan(btRadians(deg));
    m_BaseCameraInfo->m_bottom = -getTop();
    m_BaseCameraInfo->m_left = getBottom() * CameraFactory::getAspectRatio();
    m_BaseCameraInfo->m_right = getTop() * CameraFactory::getAspectRatio();
    
//    m_projectionMatrix = GLKMatrix4MakeFrustum(getLeft(), getRight(),
//                                               getBottom(), getTop(),
//                                               getNear(), getFar());
    m_projectionMatrix2 = makeFrustum(getLeft(), getRight(),
                                      getBottom(), getTop(),
                                      getNear(), getFar());
    
    //adjustTransform(1.0f, .5f);
    
    
    m_BaseCameraInfo->m_IsOrthographicCamera = false;
}

void BaseCamera::setOrthographic(btScalar near, btScalar far,
                                 btScalar left, btScalar right,
                                 btScalar top, btScalar bottom)
{
    btAssert(near <= far);
    btAssert(left <= right);
    btAssert(bottom <= top);
    
    m_BaseCameraInfo->m_fieldOfViewDegrees = -1.0f;
    m_BaseCameraInfo->m_nearZ = near;
    m_BaseCameraInfo->m_farZ = far;
    
    
    m_BaseCameraInfo->m_left = left;
    m_BaseCameraInfo->m_right = right;
    m_BaseCameraInfo->m_top = top;
    m_BaseCameraInfo->m_bottom = bottom;
    
//    m_projectionMatrix = GLKMatrix4MakeOrtho(getLeft(), getRight(),
//                                             getBottom(), getTop(),
//                                             getNear(), getFar());
    m_projectionMatrix2 = makeOrtho(getLeft(), getRight(),
                                    getBottom(), getTop(),
                                    getNear(), getFar());
    //adjustTransform(1.0f, .5f);
    
    m_BaseCameraInfo->m_IsOrthographicCamera = true;
}

btVector3 BaseCamera::getTopLeftVector()const
{
    const int			lc=0;
    const int			rc=CameraFactory::getScreenWidth();
    const int			tc=0;
    const int			bc=CameraFactory::getScreenHeight();
    
    return ComputeWorldRay(lc,tc, getProjection2()).rotate(getRotation().getAxis(), getRotation().getAngle());
}
btVector3 BaseCamera::getTopRightVector()const
{
    const int			lc=0;
    const int			rc=CameraFactory::getScreenWidth();
    const int			tc=0;
    const int			bc=CameraFactory::getScreenHeight();
    
    return ComputeWorldRay(rc,tc, getProjection2()).rotate(getRotation().getAxis(), getRotation().getAngle());
}
btVector3 BaseCamera::getBottomLeftVector()const
{
    const int			lc=0;
    const int			rc=CameraFactory::getScreenWidth();
    const int			tc=0;
    const int			bc=CameraFactory::getScreenHeight();
    
    return ComputeWorldRay(lc,bc, getProjection2()).rotate(getRotation().getAxis(), getRotation().getAngle());
}
btVector3 BaseCamera::getBottomRightVector()const
{
    const int			lc=0;
    const int			rc=CameraFactory::getScreenWidth();
    const int			tc=0;
    const int			bc=CameraFactory::getScreenHeight();
    
    return ComputeWorldRay(rc,bc, getProjection2()).rotate(getRotation().getAxis(), getRotation().getAngle());
}

void BaseCamera::updateProjection()
{
    if(!m_BaseCameraInfo->m_IsOrthographicCamera)
    {
        setPerspective(getNear(), getFar(), getFieldOfViewDegrees());
        
        
    }
    else
    {
        setOrthographic(getNear(), getFar(),
                        0.0f, CameraFactory::getScreenWidth(),
                        CameraFactory::getScreenHeight(), 0.0f);
    }
}


btVector3 BaseCamera::unProject(const btVector3 &windowPosition)const
{
//    GLint viewPort[4];
//    GLfloat x, y, z;
//    GLKMatrix4 modelMatrix = GLKMatrix4Identity;
//    GLKMatrix4 projMatrix = getProjection();
//    glGetIntegerv(GL_VIEWPORT, viewPort);
//    
//    gluUnProject(windowPosition.x(), windowPosition.y(), windowPosition.z(), modelMatrix.m, projMatrix.m, viewPort, &x, &y, &z);
//    
//    return btVector3(x, y, z);
}
btVector3 BaseCamera::project(const btVector3 &objectPosition)const
{
//    GLint viewPort[4];
//    GLfloat x, y, z;
//    GLKMatrix4 modelMatrix = GLKMatrix4Identity;
//    GLKMatrix4 projMatrix = getProjection();
//    glGetIntegerv(GL_VIEWPORT, viewPort);
//    
//    gluProject(objectPosition.x(), objectPosition.y(), objectPosition.z(), modelMatrix.m, projMatrix.m, viewPort, &x, &y, &z);
//    
//    return btVector3(x, y, z);
}

void BaseCamera::setZOrder(const BaseEntity *entityBottom, BaseEntity *entityTop, const float amt)const
{
    btVector3 origin(entityTop->getOrigin());
    origin.setZ(entityBottom->getOrigin().z() + fabsf(amt));
    entityTop->setOrigin(origin);
}

void BaseCamera::updateALOrientation()
{
    btVector3 pos = getWorldTransform().getOrigin();
    
    m_Orientation[0] = getHeadingVector().getX();
    m_Orientation[1] = getHeadingVector().getY();
    m_Orientation[2] = getHeadingVector().getZ();
    m_Orientation[3] = getUpVector().getX();
    m_Orientation[4] = getUpVector().getY();
    m_Orientation[5] = getUpVector().getZ();
    
//    if(!isnan(pos.getX()) && !isnan(pos.getY()) && !isnan(pos.getZ()))
//    {
//        alListener3f( AL_POSITION,
//                     pos.getX(),
//                     pos.getY(),
//                     pos.getZ() );
//    }
//    
//    if (!isnan(m_Orientation[0]) &&
//        !isnan(m_Orientation[1]) &&
//        !isnan(m_Orientation[2]) &&
//        !isnan(m_Orientation[3]) &&
//        !isnan(m_Orientation[4]) &&
//        !isnan(m_Orientation[5]))
//    {
//        alListenerfv( AL_ORIENTATION, m_Orientation );
//    }
    
    
//#if defined(DEBUG) || defined (_DEBUG)
//    [sharedSoundManager errorAL:__FILE__ funct:__FUNCTION__ line:__LINE__];
//#endif
    
}

btConvexHullShape *BaseCamera::createCollisionShape(const BaseCamera &camera)
{
    btConvexHullShape *ConvexShape = new btConvexHullShape();
    
    const btScalar planesFraction = camera.getFar() / camera.getNear();
    
    btScalar farLeft = camera.getLeft() * planesFraction;
    btScalar farRight = camera.getRight() * planesFraction;
    btScalar farBottom = camera.getBottom() * planesFraction;
    btScalar farTop = camera.getTop() * planesFraction;
    
    ConvexShape->addPoint(btVector3(camera.getLeft(), camera.getTop(), -camera.getNear()));
    ConvexShape->addPoint(btVector3(camera.getRight(), camera.getTop(), -camera.getNear()));
    ConvexShape->addPoint(btVector3(camera.getLeft(), camera.getBottom(), -camera.getNear()));
    ConvexShape->addPoint(btVector3(camera.getRight(), camera.getBottom(), -camera.getNear()));
    
    ConvexShape->addPoint(btVector3(farLeft, farTop, -camera.getFar()));
    ConvexShape->addPoint(btVector3(farRight, farTop, -camera.getFar()));
    ConvexShape->addPoint(btVector3(farLeft, farBottom, -camera.getFar()));
    ConvexShape->addPoint(btVector3(farRight, farBottom, -camera.getFar()));
    
    return ConvexShape;
}
