//
//  SpriteTestState.h
//  GameAsteroids
//
//  Created by James Folk on 5/6/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__SpriteTestState__
#define __GameAsteroids__SpriteTestState__

#include "BaseTestState.h"

class CameraEntity;
class BaseSpriteView;

class SpriteTestState : public BaseTestState
{
public:
    SpriteTestState();
    virtual ~SpriteTestState();
    
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
};

#endif /* defined(__GameAsteroids__SpriteTestState__) */
