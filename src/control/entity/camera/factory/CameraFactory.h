//
//  CameraFactory.h
//  GameAsteroids
//
//  Created by James Folk on 3/28/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__CameraFactory__
#define __GameAsteroids__CameraFactory__

#include "AbstractFactory.h"
#include "CameraFactoryIncludes.h"
#include "BaseCamera.h"
class CameraEntity;

class CameraFactory;
//class BaseCamera;

class OcclusionBuffer;
class SceneRenderer;

class CameraFactory :
public AbstractFactory<CameraFactory, BaseCameraInfo, BaseCamera>
{
    friend class AbstractSingleton;
    friend class BaseCamera;
    
    BaseCamera *createCamera(BaseCameraInfo *constructionInfo);
    
    
    
    
    CameraFactory();
    virtual ~CameraFactory();
    
    static btScalar s_ScreenWidth;
    static btScalar s_ScreenHeight;
    
    static OcclusionBuffer *s_OcclusionBuffer;
    static SceneRenderer *s_SceneRenderer;
    //static int s_CurrentID;
public:
    
    static void render(const btDbvtNode* root1,
                     const btDbvtNode* root2,
//                     const btVector3* normals,
//                     const btScalar* offsets,
                     const btVector3& sortaxis,
                     const btVector3 *eye = NULL);
    
    static  void updateScreenDimensions(btScalar screen_width, btScalar screen_height);
    static  btScalar getScreenWidth();
    static  btScalar getScreenHeight();
    void	setCurrentCamera(BaseCamera* camera);
    const BaseCamera*	getCurrentCamera() const;
    BaseCamera*	getCurrentCamera();
    void	setOrthoCamera(BaseCamera* camera);
    const BaseCamera*	getOrthoCamera() const;
    BaseCamera*	getOrthoCamera();
    static  btScalar getAspectRatio();

    //static CameraEntity *createCameraEntity(CameraEntityInfo *constructionInfo, IDType *ID = NULL);
    template <class T, class TInfo>
    static T *createCameraEntity(TInfo *constructionInfo, IDType *ID = NULL)
    {
        IDType _ID = CameraFactory::getInstance()->create(constructionInfo);
        
        if(ID)
            *ID = _ID;
        
        return dynamic_cast<T*>(CameraFactory::getInstance()->get(_ID));
    }
    
    template <class T>
    static T *getCameraEntity(IDType ID)
    {
        return dynamic_cast<T*>(CameraFactory::getInstance()->get(ID));
    }
protected:
    virtual BaseCamera *ctor(BaseCameraInfo*);
    virtual BaseCamera *ctor(int type = 0);
    virtual void dtor(BaseCamera*);
    
    BaseCamera *m_CurrentCamera;
    BaseCamera *m_OrthoCamera;
};

#endif /* defined(__GameAsteroids__CameraFactory__) */
