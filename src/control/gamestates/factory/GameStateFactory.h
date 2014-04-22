//
//  GameStateFactory.h
//  BaseProject
//
//  Created by library on 9/20/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__GameStateFactory__
#define __BaseProject__GameStateFactory__

#include "BaseGameState.h"
#include "AbstractFactory.h"

enum GameStateType_e
{
    GameStateType_NONE,
    GameStateType_LoadGameState,
    GameStateType_DebugGameState,
    
    GameStateType_FontTestState,
    GameStateType_PathTestState,
    GameStateType_PhysicsEntityTest,
    GameStateType_SteeringEntityTest,
    GameStateType_SpriteTest,
    GameStateType_DynamicImage,
    GameStateType_Skybox,
    GameStateType_Rotation,
    GameStateType_LuaTestState,
    
    GameStateType_MazeGameState,
    GameStateType_MazeGameState_ReadySetGo,
    GameStateType_MazeGameState_Play,
    GameStateType_MazeGameState_Lose,
    GameStateType_MazeGameState_PreviousLevel,
    GameStateType_MazeGameState_Win,
    GameStateType_MazeGameState_NextLevel,
    
    GameStateType_GlobalGameJam,
    GameStateType_MAX
};

struct BaseGameStateInfo
{
    GameStateType_e gametype;
};

class GameStateFactory :
public AbstractFactory<GameStateFactory, BaseGameStateInfo, BaseGameState>
{
    friend class AbstractSingleton;
    friend class BaseGameState;
    
    GameStateFactory(){}
    virtual ~GameStateFactory(){}
    
protected:
    virtual BaseGameState *ctor(BaseGameStateInfo *constructionInfo);
    virtual BaseGameState *ctor(int type = 0);
    virtual void dtor(BaseGameState *object);
};

#endif /* defined(__BaseProject__GameStateFactory__) */
