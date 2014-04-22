//
//  MazeGameState.h
//  GameAsteroids
//
//  Created by James Folk on 6/5/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__MazeGameState__
#define __GameAsteroids__MazeGameState__

#include "BaseGameState.h"
#include "AbstractFactoryIncludes.h"
#include "btAlignedObjectArray.h"

class Path;
class RigidEntity;
class CameraSteeringEntity;
class GhostEntity;
class btVector3;
class btVector2;
class CameraEntity;
class StopWatch;
class Timer;
class BaseEntity;
class ImageFileEditor;
class TextureMazeCreator;
class MazeMiniMapFBO;

class MazeGameState : public BaseGameState
{
public:
    MazeGameState();
    virtual ~MazeGameState();
    
    virtual void enter(void*);
    
    //this is the states normal update function
    virtual void update(void*, btScalar deltaTimeStep);
    
    //call this to update the FSM
    void  render();
    
    //this will execute when the state is exited.
    virtual void exit(void*);
    
    //this executes if the agent receives a message from the
    //message dispatcher
    virtual bool onMessage(void*, const Telegram&);
    
//    virtual void touchesBegan();
//    virtual void touchesMoved();
//    virtual void touchesEnded();
//    virtual void touchesCancelled();
    
    virtual void saveDefaultData();
    virtual void loadDefaultData();
    
    void setImpulseConstant(const float impulse)
    {
        m_ImpulseContant = impulse;
    }
    float getImpulseConstant()const
    {
        return m_ImpulseContant;
    }
    void setMaxTouchDistance(const float dist)
    {
        m_MaxTouchDistance = dist;
    }
    float getMaxTouchDistance()const
    {
        return m_MaxTouchDistance;
    }
    
    
    int getCurrentLevel();
    double getTotalTime();
    
    //void quit();
protected:
    void createTextureObjects();
    void createViewObjects();
    void createTextViewObjects();
    void createCollisionShapes();
    void createCollisionResponseObjects();
    void createCollisionFilterObjects();
    void createUpdateBehaviorObjects();
    void createSteeringBehaviors();
    void createPath();
    void createCamera();
    void createMazeEntity();
    void createPlayerEntity();
    void createGoalEntity();
    void createMap();
    
    unsigned int getSeed()const;
    void updateLookatVector();
    
    
private:
    void createGameData();
    void destroyGameData();
    void createLevelData();
    void destroyLevelData();
    
    IDType m_mazeTextureID;
    
    IDType m_bricksTextureID;
    IDType m_tarsierTextureID;
    
    IDType m_sphereViewObjectID;
    IDType m_cubeViewObjectID;
    IDType m_mazeViewObjectID;
    
    IDType m_sphereCollisionShapeID;
    IDType m_cubeCollisionShapeID;
    
    IDType m_playercollisionResponseID;
    IDType m_finishLevelCollisionResponseFactoryID;
    
    IDType m_playercollisionFilterID;
    IDType m_finishLevelcollisionFilterID;
    
    IDType m_playerUpdateBehaviorInfoID;
    
    IDType m_cameraSteeringBehaviorID;
    
    Path *m_pPath;
    
    CameraSteeringEntity *m_pMazeSteeringCamera;
    
    RigidEntity *m_pMaze;
    btVector3 *m_MazeStartOrigin;
    btVector3 *m_MazeEndOrigin;
    btVector3 *m_MazePositionOffset;
    
    RigidEntity *m_pPlayerAvatar;
    GhostEntity *m_pGoalTrigger;
    
    CameraEntity *m_pOrthoCamera;
    
    double m_TouchStartTime;
    bool m_InitalizeTouch;
    btVector3 *m_TouchStart;
    
    btVector3 getPlayerControlTouchPosition()const;
    btScalar getPlayerControlTouchDistance()const;
    void applyAngularForceOnPlayer();
    
    IDType m_stopWatchID;
    StopWatch *m_stop_watch;
    btAlignedObjectArray<IDType> m_StopWatchDrawingText;
    
    IDType m_gameTimerID;
    Timer *m_gameTimer;
    btAlignedObjectArray<IDType> m_GameTimerDrawingText;
    
    IDType m_timerID;
    Timer *m_timer;
    btAlignedObjectArray<IDType> m_TimerWatchDrawingText;
    
    btAlignedObjectArray<IDType> m_LevelDrawingText;
    
    void applyTorqueToPlayer(const btVector3 &torque);
    bool m_bCanMovePlayer;
    
    float m_ImpulseContant;
    float m_MaxTouchDistance;
    
    
    IDType spriteViewObjectID;
    BaseEntity *m_pSprite;
    IDType m_textureBufferObject;
    MazeMiniMapFBO *m_pMazeMiniMapFBO;
    
public:
    static int getBoardSize();
    static void resetBoard();
    static bool increaseBoardSize();
    static int getMazeCurrentLevel();
    static double getMazeTotalTime();
private:
    static int s_BoardSize;
    static bool s_LeveledUp;
    
};

#endif /* defined(__GameAsteroids__MazeGameState__) */
