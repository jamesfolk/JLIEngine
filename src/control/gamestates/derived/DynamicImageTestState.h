//
//  DynamicImageTestState.h
//  BaseProject
//
//  Created by library on 10/15/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__DynamicImageTestState__
#define __BaseProject__DynamicImageTestState__

//DynamicImageTestState

#include "BaseTestState.h"

class CameraEntity;
class BaseSpriteView;
class ImageFileEditor;

class DynamicImageTestState : public BaseTestState
{
public:
    DynamicImageTestState();
    virtual ~DynamicImageTestState();
    
    virtual void update_specific(btScalar deltaTimeStep);
    virtual void enter_specific();
    virtual void exit_specific();
    virtual void render_specific();
    
//    virtual void touchesBegan();
//    virtual void touchesMoved();
//    virtual void touchesEnded();
//    virtual void touchesCancelled();
    
    
private:
    IDType spriteViewObjectID;
    BaseEntity *m_pSprite;
    void createSprite();
    
    CameraEntity *m_pCamera;
    void createCamera();
    
    IDType cubeViewObjectID;
    BaseEntity *m_pEntity;
    void createEntity();
    
    float m_Rotate;
    
    IDType m_textureBufferObject;
    
    ImageFileEditor *pImage;
    ImageFileEditor *pImageFileEditor[3];
};

#endif /* defined(__BaseProject__DynamicImageTestState__) */
