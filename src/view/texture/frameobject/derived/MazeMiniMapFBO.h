//
//  MazeMiniMapFBO.h
//  BaseProject
//
//  Created by library on 10/21/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__MazeMiniMapFBO__
#define __BaseProject__MazeMiniMapFBO__

#include "BaseTextureBufferObject.h"
#include "btVector3.h"

class BaseEntity;
class btVector3;
class TextureMazeCreator;
class MeshMazeCreator;

struct MazeMiniMapFBOInfo : public TextureBufferObjectFactoryInfo
{   
    MazeMiniMapFBOInfo(size_t width,
                       size_t height,
                       //MeshMazeCreator *meshmaze,
                       unsigned int row_count,
                       unsigned int column_count,
                       unsigned int maze_seed,
                       const btVector3 &boardHalfExtends,
                       const btVector3 &tileHalfExtends,
                       BaseEntity *player,
                       bool solveMaze) :
    TextureBufferObjectFactoryInfo(width, height),
    row_count(row_count),
    column_count(column_count),
    maze_seed(maze_seed),
    boardHalfExtends(boardHalfExtends),
    tileHalfExtends(tileHalfExtends),
    //meshMazeCreator(meshmaze),
    playerAvatar(player),
    solve(solveMaze)
    {
        
    }
    
    //MeshMazeCreator *meshMazeCreator;
    unsigned int row_count;
    unsigned int column_count;
    unsigned int maze_seed;
    btVector3 boardHalfExtends;
    btVector3 tileHalfExtends;
    
    BaseEntity *playerAvatar;
    
    bool solve;
};

class MazeMiniMapFBO :
public BaseTextureBufferObject
{
public:
    MazeMiniMapFBO(const MazeMiniMapFBOInfo &info);
    virtual ~MazeMiniMapFBO();
    
    virtual void update();
    
    void solve();
    void unsolve();
    bool issolved()const;
protected:
    virtual void renderFBO();
private:
    IDType m_mapTextureBehaviorFactoryID;
    IDType m_mapBallTextureBehaviorFactoryID;
    IDType m_mapViewObjectID;
    IDType m_mapBallViewObjectID;
    
    BaseEntity *m_pMapSprite;
    BaseEntity *m_pMapBallSprite;
    
    btVector3 *m_BallSpriteInitialPosition;
    btVector3 *m_Offset;
    
    TextureMazeCreator *m_pMazeTexture;
    
    BaseEntity *m_pPlayerAvatar;
    
    bool m_solved;
};

#endif /* defined(__BaseProject__MazeMiniMapFBO__) */
