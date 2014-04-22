//
//  GameStateFactory.cpp
//  BaseProject
//
//  Created by library on 9/20/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "GameStateFactory.h"

#include "DebugGameState.h"
#include "LoadGameState.h"
#include "FontTestState.h"
#include "PathTestState.h"
#include "PhysicsEntityTestState.h"
#include "SteeringBehaviorTestState.h"
#include "SpriteTestState.h"
#include "DynamicImageTestState.h"

#include "MazeGameState.h"
#include "MazeGameState_ReadySetGo.h"
#include "MazeGameState_Play.h"
#include "MazeGameState_Lose.h"
#include "MazeGameState_PreviousLevel.h"
#include "MazeGameState_Win.h"
#include "MazeGameState_NextLevel.h"
#include "SkyboxTestState.h"

#include "GlobalGameJamGame.h"
#include "RotationGameState.h"
#include "LuaTestGameState.h"

BaseGameState *GameStateFactory::ctor(BaseGameStateInfo *constructionInfo)
{
    BaseGameState *pBaseGameState = NULL;
    
    switch(constructionInfo->gametype)
    {
        case GameStateType_LoadGameState:
        {
            LoadGameState *p = new LoadGameState();
            pBaseGameState = p;
        }
            break;
        case GameStateType_DebugGameState:
        {
            DebugGameState *p = new DebugGameState();
            pBaseGameState = p;
        }
            break;
        
        case GameStateType_FontTestState:
        {
            FontTestState *p = new FontTestState();
            pBaseGameState = p;
        }
            break;
        case GameStateType_PathTestState:
        {
            PathTestState *p = new PathTestState();
            pBaseGameState = p;
        }
            break;
        case GameStateType_PhysicsEntityTest:
        {
            PhysicsEntityTestState *p = new PhysicsEntityTestState();
            pBaseGameState = p;
        }
            break;
        case GameStateType_SteeringEntityTest:
        {
            SteeringBehaviorTestState *p = new SteeringBehaviorTestState();
            pBaseGameState = p;
        }
            break;
        case GameStateType_SpriteTest:
        {
            SpriteTestState *p = new SpriteTestState();
            pBaseGameState = p;
        }
            break;
        case GameStateType_DynamicImage:
        {
            DynamicImageTestState *p = new DynamicImageTestState();
            pBaseGameState = p;
        }
            break;
        case GameStateType_Skybox:
        {
            SkyboxTestState *p = new SkyboxTestState();
            pBaseGameState = p;
        }
            break;
        case GameStateType_Rotation:
        {
            RotationGameState *p = new RotationGameState();
            pBaseGameState = p;
        }
            break;
        case GameStateType_LuaTestState:
        {
            LuaTestGameState *p = new LuaTestGameState();
            pBaseGameState = p;
        }
            break;
        case GameStateType_MazeGameState:
        {
            MazeGameState *p = new MazeGameState();
            pBaseGameState = p;
        }
            break;
        case GameStateType_MazeGameState_ReadySetGo:
        {
            MazeGameState_ReadySetGo *p = new MazeGameState_ReadySetGo();
            pBaseGameState = p;
        }
            break;
        case GameStateType_MazeGameState_Play:
        {
            MazeGameState_Play *p = new MazeGameState_Play();
            pBaseGameState = p;
        }
            break;
        case GameStateType_MazeGameState_Lose:
        {
            MazeGameState_Lose *p = new MazeGameState_Lose();
            pBaseGameState = p;
        }
            break;
        case GameStateType_MazeGameState_PreviousLevel:
        {
            MazeGameState_PreviousLevel *p = new MazeGameState_PreviousLevel();
            pBaseGameState = p;
        }
            break;
        case GameStateType_MazeGameState_Win:
        {
            MazeGameState_Win *p = new MazeGameState_Win();
            pBaseGameState = p;
        }
            break;
        case GameStateType_MazeGameState_NextLevel:
        {
            MazeGameState_NextLevel *p = new MazeGameState_NextLevel();
            pBaseGameState = p;
        }
            break;
        case GameStateType_GlobalGameJam:
        {
            GlobalGameJamGame *p = new GlobalGameJamGame();
            pBaseGameState = p;
        }
            break;
            
    }
    
    return pBaseGameState;
}

BaseGameState *GameStateFactory::ctor(int type)
{
    return NULL;
}


void GameStateFactory::dtor(BaseGameState *object)
{
    delete object;
}