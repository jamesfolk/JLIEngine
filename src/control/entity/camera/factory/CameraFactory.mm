//
//  CameraFactory.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/28/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "CameraFactory.h"

#include "CameraEntity.h"
#include "CameraPhysicsEntity.h"
#include "CameraSteeringEntity.h"

#include "SceneRenderer.h"
#include "OcclusionBuffer.h"

//#include "EntityStateMachine.h"
//#include "AnimationController.h"

btScalar CameraFactory::s_ScreenWidth = 1;
btScalar CameraFactory::s_ScreenHeight = 1;
OcclusionBuffer *CameraFactory::s_OcclusionBuffer = NULL;
SceneRenderer *CameraFactory::s_SceneRenderer = NULL;
//int CameraFactory::s_CurrentID = 0;

BaseCamera *CameraFactory::createCamera(BaseCameraInfo *constructionInfo)
{
    BaseCamera *pBaseCamera = NULL;
    BaseEntity *pBaseEntity = NULL;
    
    switch (constructionInfo->m_CameraType)
    {
        case CameraTypes_Entity:
        {
            CameraEntityInfo *info = static_cast<CameraEntityInfo*>(constructionInfo);
            CameraEntity *pCameraEntity = new CameraEntity(*info);
            
            pBaseCamera = pCameraEntity;
            pBaseEntity = pCameraEntity;
        }
            break;
        case CameraTypes_PhysicsEntity:
        {
            CameraPhysicsEntityInfo *info = static_cast<CameraPhysicsEntityInfo*>(constructionInfo);
            CameraPhysicsEntity *pPhysicsCamera = new CameraPhysicsEntity(*info);
            
            pBaseCamera = pPhysicsCamera;
            pBaseEntity = pPhysicsCamera;
        }
            break;
        case CameraTypes_SteeringEntity:
        {
            CameraSteeringEntityInfo *info = static_cast<CameraSteeringEntityInfo*>(constructionInfo);
            CameraSteeringEntity *pSteeringCamera = new CameraSteeringEntity(*info);
            
            pBaseCamera = pSteeringCamera;
            pBaseEntity = pSteeringCamera;
        }
            break;
        default:
            break;
    }
    
    return pBaseCamera;
}

CameraFactory::CameraFactory():
m_CurrentCamera(NULL),
m_OrthoCamera(NULL)
{
    s_SceneRenderer = new SceneRenderer();
    s_OcclusionBuffer = new OcclusionBuffer();
}

CameraFactory::~CameraFactory()
{
    delete s_SceneRenderer;
    s_SceneRenderer = NULL;
    
    delete s_OcclusionBuffer;
    s_OcclusionBuffer = NULL;
    
    //destructAll();
}

//static void __gluMultMatrixVecd(const GLfloat matrix[16], const GLfloat in[4],
//                                GLfloat out[4])
//{
//    int i;
//    
//    for (i=0; i<4; i++) {
//        out[i] =
//	    in[0] * matrix[0*4+i] +
//	    in[1] * matrix[1*4+i] +
//	    in[2] * matrix[2*4+i] +
//	    in[3] * matrix[3*4+i];
//    }
//}
//
///*
// ** Invert 4x4 matrix.
// ** Contributed by David Moore (See Mesa bug #6748)
// */
//static int __gluInvertMatrixd(const GLfloat m[16], GLfloat invOut[16])
//{
//    float inv[16], det;
//    int i;
//    
//    inv[0] =   m[5]*m[10]*m[15] - m[5]*m[11]*m[14] - m[9]*m[6]*m[15]
//    + m[9]*m[7]*m[14] + m[13]*m[6]*m[11] - m[13]*m[7]*m[10];
//    inv[4] =  -m[4]*m[10]*m[15] + m[4]*m[11]*m[14] + m[8]*m[6]*m[15]
//    - m[8]*m[7]*m[14] - m[12]*m[6]*m[11] + m[12]*m[7]*m[10];
//    inv[8] =   m[4]*m[9]*m[15] - m[4]*m[11]*m[13] - m[8]*m[5]*m[15]
//    + m[8]*m[7]*m[13] + m[12]*m[5]*m[11] - m[12]*m[7]*m[9];
//    inv[12] = -m[4]*m[9]*m[14] + m[4]*m[10]*m[13] + m[8]*m[5]*m[14]
//    - m[8]*m[6]*m[13] - m[12]*m[5]*m[10] + m[12]*m[6]*m[9];
//    inv[1] =  -m[1]*m[10]*m[15] + m[1]*m[11]*m[14] + m[9]*m[2]*m[15]
//    - m[9]*m[3]*m[14] - m[13]*m[2]*m[11] + m[13]*m[3]*m[10];
//    inv[5] =   m[0]*m[10]*m[15] - m[0]*m[11]*m[14] - m[8]*m[2]*m[15]
//    + m[8]*m[3]*m[14] + m[12]*m[2]*m[11] - m[12]*m[3]*m[10];
//    inv[9] =  -m[0]*m[9]*m[15] + m[0]*m[11]*m[13] + m[8]*m[1]*m[15]
//    - m[8]*m[3]*m[13] - m[12]*m[1]*m[11] + m[12]*m[3]*m[9];
//    inv[13] =  m[0]*m[9]*m[14] - m[0]*m[10]*m[13] - m[8]*m[1]*m[14]
//    + m[8]*m[2]*m[13] + m[12]*m[1]*m[10] - m[12]*m[2]*m[9];
//    inv[2] =   m[1]*m[6]*m[15] - m[1]*m[7]*m[14] - m[5]*m[2]*m[15]
//    + m[5]*m[3]*m[14] + m[13]*m[2]*m[7] - m[13]*m[3]*m[6];
//    inv[6] =  -m[0]*m[6]*m[15] + m[0]*m[7]*m[14] + m[4]*m[2]*m[15]
//    - m[4]*m[3]*m[14] - m[12]*m[2]*m[7] + m[12]*m[3]*m[6];
//    inv[10] =  m[0]*m[5]*m[15] - m[0]*m[7]*m[13] - m[4]*m[1]*m[15]
//    + m[4]*m[3]*m[13] + m[12]*m[1]*m[7] - m[12]*m[3]*m[5];
//    inv[14] = -m[0]*m[5]*m[14] + m[0]*m[6]*m[13] + m[4]*m[1]*m[14]
//    - m[4]*m[2]*m[13] - m[12]*m[1]*m[6] + m[12]*m[2]*m[5];
//    inv[3] =  -m[1]*m[6]*m[11] + m[1]*m[7]*m[10] + m[5]*m[2]*m[11]
//    - m[5]*m[3]*m[10] - m[9]*m[2]*m[7] + m[9]*m[3]*m[6];
//    inv[7] =   m[0]*m[6]*m[11] - m[0]*m[7]*m[10] - m[4]*m[2]*m[11]
//    + m[4]*m[3]*m[10] + m[8]*m[2]*m[7] - m[8]*m[3]*m[6];
//    inv[11] = -m[0]*m[5]*m[11] + m[0]*m[7]*m[9] + m[4]*m[1]*m[11]
//    - m[4]*m[3]*m[9] - m[8]*m[1]*m[7] + m[8]*m[3]*m[5];
//    inv[15] =  m[0]*m[5]*m[10] - m[0]*m[6]*m[9] - m[4]*m[1]*m[10]
//    + m[4]*m[2]*m[9] + m[8]*m[1]*m[6] - m[8]*m[2]*m[5];
//    
//    det = m[0]*inv[0] + m[1]*inv[4] + m[2]*inv[8] + m[3]*inv[12];
//    if (det == 0)
//        return GL_FALSE;
//    
//    det = 1.0 / det;
//    
//    for (i = 0; i < 16; i++)
//        invOut[i] = inv[i] * det;
//    
//    return GL_TRUE;
//}
//
//static void __gluMultMatricesd(const GLfloat a[16], const GLfloat b[16],
//                               GLfloat r[16])
//{
//    int i, j;
//    
//    for (i = 0; i < 4; i++) {
//        for (j = 0; j < 4; j++) {
//            r[i*4+j] =
//            a[i*4+0]*b[0*4+j] +
//            a[i*4+1]*b[1*4+j] +
//            a[i*4+2]*b[2*4+j] +
//            a[i*4+3]*b[3*4+j];
//        }
//    }
//}
//
//GLint gluProject(GLfloat objx, GLfloat objy, GLfloat objz,
//                 const GLfloat modelMatrix[16],
//                 const GLfloat projMatrix[16],
//                 const GLint viewport[4],
//                 GLfloat *winx, GLfloat *winy, GLfloat *winz)
//{
//    float in[4];
//    float out[4];
//    
//    in[0]=objx;
//    in[1]=objy;
//    in[2]=objz;
//    in[3]=1.0;
//    __gluMultMatrixVecd(modelMatrix, in, out);
//    __gluMultMatrixVecd(projMatrix, out, in);
//    if (in[3] == 0.0) return(GL_FALSE);
//    in[0] /= in[3];
//    in[1] /= in[3];
//    in[2] /= in[3];
//    /* Map x, y and z to range 0-1 */
//    in[0] = in[0] * 0.5 + 0.5;
//    in[1] = in[1] * 0.5 + 0.5;
//    in[2] = in[2] * 0.5 + 0.5;
//    
//    /* Map x,y to viewport */
//    in[0] = in[0] * viewport[2] + viewport[0];
//    in[1] = in[1] * viewport[3] + viewport[1];
//    
//    *winx=in[0];
//    *winy=in[1];
//    *winz=in[2];
//    return(GL_TRUE);
//}
//
//static GLint
//gluUnProject(GLfloat winx, GLfloat winy, GLfloat winz,
//             const GLfloat modelMatrix[16],
//             const GLfloat projMatrix[16],
//             const GLint viewport[4],
//             GLfloat *objx, GLfloat *objy, GLfloat *objz)
//{
//    float finalMatrix[16];
//    float in[4];
//    float out[4];
//    
//    __gluMultMatricesd(modelMatrix, projMatrix, finalMatrix);
//    if (!__gluInvertMatrixd(finalMatrix, finalMatrix)) return(GL_FALSE);
//    
//    in[0]=winx;
//    in[1]=winy;
//    in[2]=winz;
//    in[3]=1.0;
//    
//    /* Map x and y from window coordinates */
//    in[0] = (in[0] - viewport[0]) / viewport[2];
//    in[1] = (in[1] - viewport[1]) / viewport[3];
//    
//    /* Map to range -1 to 1 */
//    in[0] = in[0] * 2 - 1;
//    in[1] = in[1] * 2 - 1;
//    in[2] = in[2] * 2 - 1;
//    
//    __gluMultMatrixVecd(finalMatrix, in, out);
//    if (out[3] == 0.0) return(GL_FALSE);
//    out[0] /= out[3];
//    out[1] /= out[3];
//    out[2] /= out[3];
//    *objx = out[0];
//    *objy = out[1];
//    *objz = out[2];
//    return(GL_TRUE);
//}
//
//static btVector3 ComputeWorldRay(int xs, int ys, GLfloat *projMatrix)
//{
//	GLint viewPort[4] =
//    {
//        0,
//        0,
//        static_cast<GLint>(CameraFactory::getScreenWidth()),
//        static_cast<GLint>(CameraFactory::getScreenHeight())
//    };
//    
//    GLfloat modelMatrix[16] =
//    {
//        1, 0, 0, 0,
//        0, 1, 0, 0,
//        0, 0, 1, 0,
//        0, 0, 0, 1,
//    };
////	GLKMatrix4 modelMatrix = GLKMatrix4Identity;
//    //	GLKMatrix4 projMatrix = CameraFactory::getInstance()->getCurrentCamera()->getProjection();
//    //	glGetIntegerv(GL_VIEWPORT, viewPort);
//	//glGetDoublev(GL_MODELVIEW_MATRIX, modelMatrix);
//	//glGetDoublev(GL_PROJECTION_MATRIX, projMatrix);
//	ys = viewPort[3] - ys - 1;
//	GLfloat wx0, wy0, wz0;
//    
//    gluUnProject((GLfloat)xs,
//                 (GLfloat)ys,
//                 0.0,
//                 modelMatrix,
//                 projMatrix,
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
//                 modelMatrix,
//                 projMatrix,
//                 viewPort,
//                 &wx1,
//                 &wy1,
//                 &wz1);
//	btVector3 tmp(float(wx1-wx0), float(wy1-wy0), float(wz1-wz0));
//	tmp.normalize();
//	return tmp;
//}





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
//    //	GLKMatrix4 projMatrix = CameraFactory::getInstance()->getCurrentCamera()->getProjection();
//    //	glGetIntegerv(GL_VIEWPORT, viewPort);
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





void CameraFactory::render(const btDbvtNode* root1,
                            const btDbvtNode* root2,
//                            const btVector3* normals,
//                            const btScalar* offsets,
                            const btVector3& sortaxis,
                            const btVector3 *eye)
{
    BaseCamera *cam = CameraFactory::getInstance()->getCurrentCamera();
//    const btVector3 &rotationAxis = cam->getRotation().getAxis();
//    const btScalar &rotationAngle = cam->getRotation().getAngle();
    const btVector3 &origin = cam->getOrigin();
    const btVector3 &heading = cam->getHeadingVector();
    const btScalar far = cam->getFar();
//    const GLKMatrix4 &projection = cam->getProjection();
    
    btVector3 planeNormals[5];
    btScalar planeOffsets[5];
    
    
    const int count=5;
    
//    const int			margin=0;
//	const int			lc=margin;
//	const int			rc=CameraFactory::getScreenWidth();
//	const int			tc=margin;
//	const int			bc=CameraFactory::getScreenHeight();
    
//    btScalar projMatrix[16];
//    getFrom4x4Matrix(cam->getProjection2(), projMatrix);
//    printf("\
//           %f, %f, %f, %f,\n\
//           %f, %f, %f, %f,\n\
//           %f, %f, %f, %f,\n\
//           %f, %f, %f, %f\n\
//           \n\n",
//           projMatrix[0], projMatrix[1], projMatrix[2], projMatrix[3],
//           projMatrix[4], projMatrix[5], projMatrix[6], projMatrix[7],
//           projMatrix[8], projMatrix[9], projMatrix[10], projMatrix[11],
//           projMatrix[12], projMatrix[13], projMatrix[14], projMatrix[15]);
//    printf("\
//           %f, %f, %f, %f,\n\
//           %f, %f, %f, %f,\n\
//           %f, %f, %f, %f,\n\
//           %f, %f, %f, %f\n\
//           \n\n",
//           projection.m[0], projection.m[1], projection.m[2], projection.m[3],
//           projection.m[4], projection.m[5], projection.m[6], projection.m[7],
//           projection.m[8], projection.m[9], projection.m[10], projection.m[11],
//           projection.m[12], projection.m[13], projection.m[14], projection.m[15]);
	
    btVector3		c00(cam->getTopLeftVector());
    btVector3		c10(cam->getTopRightVector());//ComputeWorldRay(rc,tc, projMatrix));
    btVector3		c01(cam->getBottomLeftVector());//ComputeWorldRay(lc,bc, projMatrix));
    btVector3		c11(cam->getBottomRightVector());//ComputeWorldRay(rc,bc, projMatrix));
    
//    printf("%f\n", rotationAngle);
//    printf("0 %f, %f, %f\n", c00.x(), c00.y(), c00.z());
    
//    c00 = c00.rotate(rotationAxis, rotationAngle);
    
//    printf("1 %f, %f, %f\n\n", c00.x(), c00.y(), c00.z());
    
//    *BaseCamera::s_c00 = c00;
//    *BaseCamera::s_c01 = c01;
//    *BaseCamera::s_c10 = c10;
//    *BaseCamera::s_c11 = c11;
    
	planeNormals[0]	=	c01.cross(c00).normalized();
	planeNormals[1]	=	c10.cross(c11).normalized();
	planeNormals[2]	=	c00.cross(c10).normalized();
	planeNormals[3]	=	c11.cross(c01).normalized();
	planeNormals[4]	=	-heading;
	planeOffsets[4]	=	-(origin+heading*(far)).dot(planeNormals[4]);
	for(int i=0;i<4;++i)
        planeOffsets[i]=-(origin.dot(planeNormals[i]));
    
    
    
    if(eye != NULL)
    {
        s_OcclusionBuffer->initialize();
        s_OcclusionBuffer->eye=*eye;
        s_SceneRenderer->setOcclusionBuffer(s_OcclusionBuffer);
		btDbvt::collideOCL(root1,planeNormals,planeOffsets,sortaxis,count,*s_SceneRenderer);
		btDbvt::collideOCL(root2,planeNormals,planeOffsets,sortaxis,count,*s_SceneRenderer);
    }
    else
    {
        s_SceneRenderer->setOcclusionBuffer(NULL);
		btDbvt::collideKDOP(root1,planeNormals,planeOffsets,count,*s_SceneRenderer);
		btDbvt::collideKDOP(root2,planeNormals,planeOffsets,count,*s_SceneRenderer);
    }
    s_SceneRenderer->render();
    
//    int visiblecount=s_SceneRenderer->getNumObjectsDrawn();
//    NSLog(@"%d visible\n", visiblecount);
}

 void CameraFactory::updateScreenDimensions(btScalar screen_width, btScalar screen_height)
{
    s_ScreenWidth = screen_width;
    s_ScreenHeight = screen_height;
    
    if(CameraFactory::getInstance()->getCurrentCamera())
        CameraFactory::getInstance()->getCurrentCamera()->updateProjection();
    if(CameraFactory::getInstance()->getOrthoCamera())
        CameraFactory::getInstance()->getOrthoCamera()->updateProjection();
}

 btScalar CameraFactory::getScreenWidth()
{
    return s_ScreenWidth;
}

 btScalar CameraFactory::getScreenHeight()
{
    return s_ScreenHeight;
}

 void	CameraFactory::setCurrentCamera(BaseCamera* camera)
{
    m_CurrentCamera = camera;
}

 const BaseCamera*	CameraFactory::getCurrentCamera() const
{
    return m_CurrentCamera;
}

 BaseCamera*	CameraFactory::getCurrentCamera()
{
    return m_CurrentCamera;
}



 void	CameraFactory::setOrthoCamera(BaseCamera* camera)
{
    m_OrthoCamera = camera;
}

 const BaseCamera*	CameraFactory::getOrthoCamera() const
{
    return m_OrthoCamera;
}


BaseCamera* CameraFactory::getOrthoCamera()
{
    return m_OrthoCamera;
}

 btScalar CameraFactory::getAspectRatio()
{
    return fabsf(s_ScreenWidth / s_ScreenHeight);
}

//CameraEntity *CameraFactory::createCameraEntity(CameraEntityInfo *constructionInfo, IDType *ID)
//{
//    IDType _ID = CameraFactory::getInstance()->create(constructionInfo);
//    
//    btAssert(_ID != 0);
//    
//    if(ID)
//        *ID = _ID;
//    
//    return dynamic_cast<CameraEntity*>(CameraFactory::getInstance()->get(_ID));
//}

BaseCamera *CameraFactory::ctor(BaseCameraInfo *constructionInfo)
{
    return createCamera(constructionInfo);
}
BaseCamera *CameraFactory::ctor(int type)
{
    BaseCamera *pEntity = NULL;
    
    switch (type)
    {
        default:case CameraTypes_Entity:
            pEntity = new CameraEntity();
            break;
        case CameraTypes_PhysicsEntity:
        {
            CameraPhysicsEntity *p = new CameraPhysicsEntity();
            pEntity = dynamic_cast<CameraPhysicsEntity*>(p);
        }
            break;
        case CameraTypes_SteeringEntity:
        {
            CameraSteeringEntity *p = new CameraSteeringEntity();
            pEntity = dynamic_cast<CameraSteeringEntity*>(p);
        }
            break;
    }
    
    return pEntity;
}
void CameraFactory::dtor(BaseCamera *object)
{
    if(object == m_CurrentCamera)
        m_CurrentCamera = NULL;
    if(object == m_OrthoCamera)
        m_OrthoCamera = NULL;
    
    delete object;
}
