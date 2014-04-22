//
//  MeshMazeCreator.h
//  GameAsteroids
//
//  Created by James Folk on 4/15/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__MeshMazeCreator__
#define __GameAsteroids__MeshMazeCreator__

#include "ShaderFactoryIncludes.h"
#include "ViewObjectFactoryIncludes.h"
#include "SteeringBehaviorFactoryIncludes.h"
#include "EntityStateMachineFactoryIncludes.h"
#include "AnimationControllerFactoryIncludes.h"
#include "EntityFactoryIncludes.h"

#include "MazeCreator.h"
#include "BaseViewObject.h"
#include "AbstractFactoryIncludes.h"

#include "ZipFileResourceLoader.h"

class btVector3;
class RigidEntity;
class BaseEntity;

class MeshMazeCreator : public MazeGeneric
{
public:
    MeshMazeCreator();
    ~MeshMazeCreator();
    
    void DrawMaze(const std::string &wallname,
                  IDType textureFactoryID,
                  const btVector3 &origin = btVector3(0, 0, 0));
    
    btVector3 getOriginOfTile(const unsigned int row, const unsigned int column)const;
    
    RigidEntity *getMaze()const;
    
    IDType getViewObjectID()const;

    const btVector3 &getTileHalfExtends()const;
    const btVector3 &getBoardHalfExtends()const;
private:
    
    std::string m_MazeWallObjectName;
    btVector3 *m_Origin;
    btVector3 *m_TileHalfDimensions;
    btVector3 *m_BoardHalfDimensions;
    
    MeshObject<VertexAttributes_Vertex_Normal_Color_UVLayer1> *m_MeshObject;
    
    RigidEntity *m_pMaze;
    
    IDType m_textureFactoryID;
    
    IDType m_viewObjectID;
    IDType m_planeCollisionShapeID;
    
    btAlignedObjectArray<GLushort> m_indiceData;
    
    btAlignedObjectArray<VertexAttributes_Vertex_Normal_Color_UVLayer1> m_vertexData;
    btAlignedObjectArray<VertexAttributes_Vertex_Normal_Color_UVLayer1> m_MazeVertexData;
    
private:
    void Draw();
    
    void drawNode(const unsigned int row, const unsigned int column, MazeNodeType type, bool isPartOfSolvedPath, unsigned int _id);
    void createNorthWall(const unsigned int row, const unsigned int column, unsigned int _id, bool isPartOfSolvedPath);
    void createEastWall(const unsigned int row, const unsigned int column, unsigned int _id, bool isPartOfSolvedPath);
    void createSouthWall(const unsigned int row, const unsigned int column, unsigned int _id, bool isPartOfSolvedPath);
    void createWestWall(const unsigned int row, const unsigned int column, unsigned int _id, bool isPartOfSolvedPath);
    void createFloorWall(const unsigned int row, const unsigned int column, bool isPartOfSolvedPath);
    void createCeilingWall(const unsigned int row, const unsigned int column, unsigned int _id, bool isPartOfSolvedPath);
    
    void concatenateWall(const btTransform &transform, bool isPartOfSolvedPath);
    
    void initializeMazePickup();
};

#endif /* defined(__GameAsteroids__MeshMazeCreator__) */
