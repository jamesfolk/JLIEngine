//
//  MazeGameState.h
//  MazeADay
//
//  Created by James Folk on 11/15/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __MazeADay__MazeGameState__
#define __MazeADay__MazeGameState__

#include "BaseGameState.h"
#include "AbstractFactoryIncludes.h"


#include "GameStateFactory.h"
#include "UserSettingsSingleton.h"

class CameraEntity;
class Path;
class CameraSteeringEntity;
class RigidEntity;
class GhostEntity;
class btVector3;
class MazeMiniMapFBO;
class MeshMazeCreator;
class BaseEntity;
class RigidEntity;
class StopWatch;
class Timer;
class BaseViewObject;
class BaseTextureBufferObject;

struct MazeLevelData
{
    MazeLevelData():
    s_mazeTextureID(0),
    s_pMazeMesh(NULL),
    s_MazeMiniMapTextureBehaviorFactoryID(0),
    s_MazeMiniMapSpriteViewObjectID(0),
    s_MazeMiniMapSpriteFactoryID(0),
    s_MazeMiniMapTextureBufferObject(0),
    s_MazeStartOrigin(NULL),
    s_MazeEndOrigin(NULL)
    {}
    
    ~MazeLevelData()
    {
        
    }
    
    IDType s_mazeTextureID;
    MeshMazeCreator *s_pMazeMesh;
    
    IDType s_MazeMiniMapTextureBehaviorFactoryID;
    IDType s_MazeMiniMapSpriteViewObjectID;
    IDType s_MazeMiniMapSpriteFactoryID;
    IDType s_MazeMiniMapTextureBufferObject;
    
    btVector3 *s_MazeStartOrigin;
    btVector3 *s_MazeEndOrigin;
};

class MazeGameState: public BaseGameState
{
public:
    MazeGameState();
    virtual ~MazeGameState();
    
    virtual void enter(void*);
    virtual void update(void*, btScalar deltaTimeStep);
    virtual void render();
    virtual void exit(void*);
    virtual bool onMessage(void*, const Telegram&);
    
    virtual void touchRespond(const DeviceTouch &input);
    virtual void tapGestureRespond(const DeviceTapGesture &input);
    virtual void pinchGestureRespond(const DevicePinchGesture &input);
    virtual void panGestureRespond(const DevicePanGesture &input);
    virtual void swipeGestureRespond(const DeviceSwipeGesture &input);
    virtual void rotationGestureRespond(const DeviceRotationGesture &input);
    virtual void longPressGestureRespond(const DeviceLongPressGesture &input);
    virtual void accelerometerRespond(const DeviceAccelerometer &input);
    virtual void motionRespond(const DeviceMotion &input);
    virtual void gyroRespond(const DeviceGyro &input);
    virtual void magnetometerRespond(const DeviceMagnetometer &input);
    
    virtual void saveDefaultData();
    virtual void loadDefaultData();
    
    virtual void enablePause(bool pause = true);
    
    static int getCurrentLevel();
    static int getMinimumLevel();
    static int getMaximumLevel();
    static void setCompletedLevel(int level);
    static bool completedLevel(int level);
    static long getTotalTime();
    
    void setup();
    
//    static long getBestTime(unsigned int level)
//    {
//        char buffer[256];
//        sprintf(buffer, "best_time - %d", MazeGameState::getCurrentLevel());
//        
//        
//        std::string _current_time = UserSettingsSingleton::getInstance()->getString(buffer);
//        
//        long current_best_time = atol(_current_time.c_str());
//        return current_best_time;
//    }
//    
//    static void setBestTime(unsigned int level, long milliseconds)
//    {
//        long current_best_time = getBestTime(level);
//        
//        if(milliseconds < current_best_time)
//        {
//            char buffer[256];
//            sprintf(buffer, "best_time - %d", MazeGameState::getCurrentLevel());
//            
//            char buffer2[64];
//            sprintf(buffer2, "%ld", milliseconds);
//            
//            UserSettingsSingleton::getInstance()->setString(buffer, buffer2);
//        }
//    }
private:
    void pause_reaction(bool paused);
    
    
    
    //IDType m_mazeTextureID;
    IDType m_bricksTextureID;
    IDType m_tarsierTextureID;
    IDType m_sphereViewObjectID;
    IDType m_cubeViewObjectID;
    IDType m_sphereCollisionShapeID;
    
    IDType m_cubeCollisionShapeID;
    IDType m_playercollisionResponseID;
    IDType m_finishLevelCollisionResponseFactoryID;
    IDType m_playercollisionFilterID;
    IDType m_finishLevelcollisionFilterID;
    IDType m_playerUpdateBehaviorInfoID;
    IDType m_cameraSteeringBehaviorID;
    
    IDType m_currentStopWatchID;
    btAlignedObjectArray<IDType> m_StopWatchDrawingText;
    
    IDType m_savedTimeStopWatchID;
    btAlignedObjectArray<IDType> m_GameTimerDrawingText;
    
    btAlignedObjectArray<IDType> m_LevelDrawingText;
    
    void createAssets();
    
    void createOrthoCamera();
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
    void createPlayerEntity();
    void createGoalEntity();
    void createFrameTimers();
    
    
    
    void destroyAssets();
    
    void destroyOrthoCamera();
    void destroyTextureObjects();
    void destroyViewObjects();
    void destroyTextViewObjects();
    void destroyCollisionShapes();
    void destroyCollisionResponseObjects();
    void destroyCollisionFilterObjects();
    void destroyUpdateBehaviorObjects();
    void destroySteeringBehaviors();
    void destroyPath();
    void destroyCamera();
    void destroyPlayerEntity();
    void destroyGoalEntity();
    void destroyFrameTimers();
    
    
    
public:
    static void lookAtPlayerCenter();
    static void lookAtMazeCenter();
    
    static void setBoardSize(const int size);
    static int getBoardSize();
    static void resetBoard();
    static bool decreaseBoardSize();
    static bool increaseBoardSize();
    static int getMazeCurrentLevel();
    static long getMazeTotalTime();
    static unsigned int getSeed();
    
    static void setGameCamera(CameraSteeringEntity *pCamera)
    {
        s_pCamera = pCamera;
    }
    static CameraSteeringEntity *getGameCamera()
    {
        return s_pCamera;
    }
    
    static void setGamePlayer(RigidEntity *pPlayer)
    {
        s_pPlayerAvatar = pPlayer;
    }
    static RigidEntity *getGamePlayer()
    {
        return s_pPlayerAvatar;
    }
    
    static void setGameGoal(GhostEntity *pGoal)
    {
        s_pGoalTrigger = pGoal;
    }
    static GhostEntity *getGameGoal()
    {
        return s_pGoalTrigger;
    }
    
    static void setCurrentStopWatch(StopWatch *stop_watch)
    {
        s_pCurrentStopWatch = stop_watch;
    }
    static StopWatch *getCurrentStopWatch()
    {
        return s_pCurrentStopWatch;
    }
    
    static void setSavedStopWatch(StopWatch *game_timer)
    {
        s_pGamePlayTimer = game_timer;
    }
    static StopWatch *getSavedStopWatch()
    {
        return s_pGamePlayTimer;
    }
    
    static void setGameCameraPath(Path *path)
    {
        s_pPath = path;
    }
    
    static Path *getGameCameraPath()
    {
        return s_pPath;
    }
    
    static void createMaze(unsigned int size, unsigned int seed, bool solve);
    static void createMiniMap(unsigned int size,
                              unsigned int maze_seed,
                              const btVector3 &boardHalfExtends,
                              const btVector3 &tileHalfExtends,
                              bool solve);
    
    static MazeLevelData *createMazeLevelData(unsigned int size, unsigned int seed, bool solve);
    static void createMiniMapLevelData(unsigned int size,
                              unsigned int maze_seed,
                              const btVector3 &boardHalfExtends,
                              const btVector3 &tileHalfExtends,
                              bool solve,
                              MazeLevelData &mazeLevelData);
    
    
    static void destroyMaze();
    static void destroyMiniMap();
    
    static MeshMazeCreator *getMazeMeshCreator();
    static BaseEntity *getMazeMiniMapSprite();
    static MazeMiniMapFBO *getMazeMiniMapTBO();
    static btVector3 getMazeStartOrigin();
    static btVector3 getMazeEndOrigin();
    
    static BaseGameState *getGameState(GameStateType_e state);
    static void createGameStates();
    static void destroyGameStates();
private:
    
    static int s_BoardSize;
    //static bool s_LeveledUp;
    
    static CameraSteeringEntity *s_pCamera;
    static RigidEntity *s_pPlayerAvatar;
    static GhostEntity *s_pGoalTrigger;
    static StopWatch *s_pCurrentStopWatch;
    static StopWatch *s_pGamePlayTimer;
    //static Timer *s_pUtilityTimer;
    static Path *s_pPath;
    
    static IDType s_mazeTextureID;
    static MeshMazeCreator *s_pMazeMesh;
    
    static IDType s_MazeMiniMapTextureBehaviorFactoryID;
    static IDType s_MazeMiniMapSpriteViewObjectID;
    static IDType s_MazeMiniMapSpriteFactoryID;
    static IDType s_MazeMiniMapTextureBufferObject;
    
    static btVector3 *s_MazeStartOrigin;
    static btVector3 *s_MazeEndOrigin;
    
    static IDType s_readySetGoGameStateID;
    static IDType s_playGameStateID;
    static IDType s_loseGameStateID;
    static IDType s_winGameStateID;
    static IDType s_previousLevelGameStateID;
    static IDType s_nextLevelGameStateID;
public:
    static dispatch_queue_t backgroundQueue;
    static std::vector<MazeLevelData*> *MazeLevelDataVector;
    static void createLevels(unsigned int seed);
    static void destoryLevels();
    
    static void createLevel(unsigned int index, unsigned int size, unsigned int seed);
};



#endif /* defined(__MazeADay__MazeGameState__) */
