//
//  MeshMazeCreator.cpp
//  GameAsteroids
//
//  Created by James Folk on 4/15/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "MeshMazeCreator.h"

#include "RigidEntity.h"
//#include "ViewObjectFactory.h"
#include "ShaderFactory.h"
#include "UtilityFunctions.h"

#include "btVector3.h"

#include "EntityFactory.h"

//#include "MazeGhostEntity.h"

#include "BaseTestState.h"

#include "TextureFactory.h"
#include "CollisionShapeFactory.h"

//#include "MazePickupCollisionFilterBehavior.h"
//#include "CollisionFilterBehaviorFactory.h"

//#include "MazePickupCollisionResponseBehavior.h"
#include "CollisionResponseBehaviorFactory.h"

#include "ZipFileResourceLoader.h"


#include "AbstractFactoryIncludes.h"

MeshMazeCreator::MeshMazeCreator() :
m_MazeWallObjectName(""),
m_Origin(new btVector3(0.0f, 0.0f, 0.0f)),
m_TileHalfDimensions(new btVector3(0.0f, 0.0f, 0.0f)),
m_BoardHalfDimensions(new btVector3(0.0f, 0.0f, 0.0f)),
m_MeshObject(NULL),
m_pMaze(NULL),
m_textureFactoryID(0),
m_viewObjectID(0),
m_planeCollisionShapeID(0)
{
    m_RenderType = MazeRenderType_Mesh;
}
MeshMazeCreator::~MeshMazeCreator()
{
    CollisionShapeFactory::getInstance()->destroy(m_planeCollisionShapeID);
    ViewObjectFactory::getInstance()->destroy(m_viewObjectID);
    
    if(m_pMaze)
    {
        IDType _mazeID = m_pMaze->getID();
        EntityFactory::getInstance()->destroy(_mazeID);
    }
    
    delete m_MeshObject;
    delete m_BoardHalfDimensions;
    delete m_TileHalfDimensions;
    delete m_Origin;
}

void MeshMazeCreator::DrawMaze(const std::string &wallname,
                               IDType textureFactoryID,
                               const btVector3 &origin)
{
    *m_Origin = origin;
    m_MazeWallObjectName = wallname;
    
    const BaseMeshObject *ova = ZipFileResourceLoader::getInstance()->getMeshObject(m_MazeWallObjectName.c_str());
    *m_TileHalfDimensions = ova->getHalfExtends();
    
    *m_BoardHalfDimensions = btVector3(GetNumColumns() * getTileHalfExtends().x(),
                                      0.0f,
                                      GetNumRows() * getTileHalfExtends().z());
    m_textureFactoryID = textureFactoryID;
    
    
    const BaseMeshObject *pB = ZipFileResourceLoader::getInstance()->getMeshObject(m_MazeWallObjectName);
    
    m_MeshObject = new MeshObject<VertexAttributes_Vertex_Normal_Color_UVLayer1>(*(dynamic_cast<const MeshObject<VertexAttributes_Vertex_Normal_Color_UVLayer1> *>(pB)));

    Draw();
}

btVector3 MeshMazeCreator::getOriginOfTile(const unsigned int row, const unsigned int column)const
{
    btVector3 vOrigin(column * getTileHalfExtends().x() * 2.0f, 0.0f, row * getTileHalfExtends().z() * 2.0f);
    
    
    
    return ((vOrigin - (getBoardHalfExtends() / 2.0f)) + *m_Origin);
}

RigidEntity *MeshMazeCreator::getMaze()const
{
    return m_pMaze;
}

IDType MeshMazeCreator::getViewObjectID()const
{
    return m_viewObjectID;
}

const btVector3 &MeshMazeCreator::getTileHalfExtends()const
{
    return *m_TileHalfDimensions;
}
const btVector3 &MeshMazeCreator::getBoardHalfExtends()const
{
    return *m_BoardHalfDimensions;
}
void MeshMazeCreator::Draw()
{
    MazeNode *node = NULL;
    
    //initializeMazePickup();
    
	for(unsigned int row = 0; row < m_NumRows; row++)
    {
		for(unsigned int column = 0; column < m_NumColumns; column++)
        {
            node = GetMazeNode(row, column);
            
            drawNode(row, column, node->GetType(), node->GetID(), node->IsPartOfSolvedPath());
		}
	}
    
    
    
    BaseViewObjectInfo *constructionInfo = new BaseViewObjectInfo(ShaderFactory::getInstance()->getCurrentShaderID(),
                                                                  m_MazeWallObjectName,
                                                                  &m_textureFactoryID, 1);
    m_viewObjectID = ViewObjectFactory::getInstance()->create(constructionInfo);
    
    BaseViewObject *vo = ViewObjectFactory::getInstance()->get(m_viewObjectID);
    delete constructionInfo;
    
    VertexAttributeLoader::getInstance()->load(vo, m_MazeVertexData);
    
    
    m_planeCollisionShapeID = CollisionShapeFactory::createShape(m_viewObjectID, CollisionShapeType_TriangleMesh);
    
    RigidEntityInfo *PE_constructionInfo = new RigidEntityInfo(m_viewObjectID,
                                                                   0,
                                                                   0,
                                                                   false,
                                                                   m_planeCollisionShapeID,
                                                                   0.0f);
    
    m_pMaze = EntityFactory::createEntity<RigidEntity, RigidEntityInfo>(PE_constructionInfo);
    
    m_pMaze->getRigidBody()->setFriction(10.0f);
    m_pMaze->setKinematicPhysics();
    
    delete PE_constructionInfo;
    
    m_pMaze->setOrigin(*m_Origin);
    
}

void MeshMazeCreator::drawNode(const unsigned int row, const unsigned int column, MazeNodeType type, bool isPartOfSolvedPath, unsigned int _id)
{
    //clock-wise existance of walls
    //starting from the north wall.
    //0 = no wall
    //1 = wall
    
    if(
       //MazeNodeType_0000 == type
       //|| MazeNodeType_0001 == type
       //|| MazeNodeType_0010 == type
       //|| MazeNodeType_0011 == type
       //|| MazeNodeType_0100 == type
       //|| MazeNodeType_0101 == type
       //|| MazeNodeType_0110 == type
       //|| MazeNodeType_0111 == type
       MazeNodeType_1000 == type
       || MazeNodeType_1001 == type
       || MazeNodeType_1010 == type
       || MazeNodeType_1011 == type
       || MazeNodeType_1100 == type
       || MazeNodeType_1101 == type
       || MazeNodeType_1110 == type
       || MazeNodeType_1111 == type
       )
    {
        createNorthWall(row, column, _id, isPartOfSolvedPath);
    }
    
    if(
       //   MazeNodeType_0000 == type
       //|| MazeNodeType_0001 == type
       //|| MazeNodeType_0010 == type
       //|| MazeNodeType_0011 == type
       MazeNodeType_0100 == type
       || MazeNodeType_0101 == type
       || MazeNodeType_0110 == type
       || MazeNodeType_0111 == type
       //|| MazeNodeType_1000 == type
       //|| MazeNodeType_1001 == type
       //|| MazeNodeType_1010 == type
       //|| MazeNodeType_1011 == type
       || MazeNodeType_1100 == type
       || MazeNodeType_1101 == type
       || MazeNodeType_1110 == type
       || MazeNodeType_1111 == type
       )
    {
        createEastWall(row, column, _id, isPartOfSolvedPath);
    }
    
    if(
       //   MazeNodeType_0000 == type
       //|| MazeNodeType_0001 == type
       MazeNodeType_0010 == type
       || MazeNodeType_0011 == type
       //|| MazeNodeType_0100 == type
       //|| MazeNodeType_0101 == type
       || MazeNodeType_0110 == type
       || MazeNodeType_0111 == type
       //|| MazeNodeType_1000 == type
       //|| MazeNodeType_1001 == type
       || MazeNodeType_1010 == type
       || MazeNodeType_1011 == type
       //|| MazeNodeType_1100 == type
       //|| MazeNodeType_1101 == type
       || MazeNodeType_1110 == type
       || MazeNodeType_1111 == type
       )
    {
        createSouthWall(row, column, _id, isPartOfSolvedPath);
    }
    
    if(
       //   MazeNodeType_0000 == type
       MazeNodeType_0001 == type
       //|| MazeNodeType_0010 == type
       || MazeNodeType_0011 == type
       //|| MazeNodeType_0100 == type
       || MazeNodeType_0101 == type
       //|| MazeNodeType_0110 == type
       || MazeNodeType_0111 == type
       //|| MazeNodeType_1000 == type
       || MazeNodeType_1001 == type
       //|| MazeNodeType_1010 == type
       || MazeNodeType_1011 == type
       //|| MazeNodeType_1100 == type
       || MazeNodeType_1101 == type
       //|| MazeNodeType_1110 == type
       || MazeNodeType_1111 == type
       )
    {
        createWestWall(row, column, _id, isPartOfSolvedPath);
    }
    
    createFloorWall(row, column, isPartOfSolvedPath);
}

void MeshMazeCreator::createNorthWall(const unsigned int row, const unsigned int column, unsigned int _id, bool isPartOfSolvedPath)
{
    btMatrix3x3 rot(btQuaternion(DEGREES_TO_RADIANS(0.0f),
                                 DEGREES_TO_RADIANS(90.0f),
                                 DEGREES_TO_RADIANS(0.0f)));
    btVector3 origin(getOriginOfTile(row, column));
    
    origin.setX(origin.x());
    origin.setY(origin.y() + (getTileHalfExtends().y() + getTileHalfExtends().z()));
    origin.setZ(origin.z() - (((getTileHalfExtends().z()) + (getTileHalfExtends().y())) - (getTileHalfExtends().y() * 2.0f)));
    
    concatenateWall(btTransform(rot, origin), isPartOfSolvedPath);
}
void MeshMazeCreator::createEastWall(const unsigned int row, const unsigned int column, unsigned int _id, bool isPartOfSolvedPath)
{
    btMatrix3x3 rot(btQuaternion(DEGREES_TO_RADIANS(0.0f),
                                 DEGREES_TO_RADIANS(0.0f),
                                 DEGREES_TO_RADIANS(90.0f)));
    btVector3 origin(getOriginOfTile(row, column));
    
    origin.setX(origin.x() + (((getTileHalfExtends().x()) + (getTileHalfExtends().y())) - (getTileHalfExtends().y() * 2.0f)));
    origin.setY(origin.y() + (getTileHalfExtends().y() + getTileHalfExtends().x()));
    origin.setZ(origin.z());
    
    concatenateWall(btTransform(rot, origin), isPartOfSolvedPath);
}
void MeshMazeCreator::createSouthWall(const unsigned int row, const unsigned int column, unsigned int _id, bool isPartOfSolvedPath)
{
    btMatrix3x3 rot(btQuaternion(DEGREES_TO_RADIANS(0.0f),
                                 DEGREES_TO_RADIANS(-90.0f),
                                 DEGREES_TO_RADIANS(0.0f)));
    btVector3 origin(getOriginOfTile(row, column));
    
    origin.setX(origin.x());
    origin.setY(origin.y() + (getTileHalfExtends().y() + getTileHalfExtends().z()));
    origin.setZ(origin.z() + (((getTileHalfExtends().z()) + (getTileHalfExtends().y())) - (getTileHalfExtends().y() * 2.0f)));
    
    concatenateWall(btTransform(rot, origin), isPartOfSolvedPath);
}
void MeshMazeCreator::createWestWall(const unsigned int row, const unsigned int column, unsigned int _id, bool isPartOfSolvedPath)
{
    btMatrix3x3 rot(btQuaternion(DEGREES_TO_RADIANS(0.0f),
                                 DEGREES_TO_RADIANS(0.0f),
                                 DEGREES_TO_RADIANS(-90.0f)));
    btVector3 origin(getOriginOfTile(row, column));
    
    origin.setX(origin.x() - (((getTileHalfExtends().x()) + (getTileHalfExtends().y())) - (getTileHalfExtends().y() * 2.0f)));
    origin.setY(origin.y() + (getTileHalfExtends().y() + getTileHalfExtends().x()));
    origin.setZ(origin.z());
    
    concatenateWall(btTransform(rot, origin), isPartOfSolvedPath);
}
void MeshMazeCreator::createFloorWall(const unsigned int row, const unsigned int column, bool isPartOfSolvedPath)
{
    btMatrix3x3 rot(btQuaternion(DEGREES_TO_RADIANS(0.0f),
                                 DEGREES_TO_RADIANS(0.0f),
                                 DEGREES_TO_RADIANS(0.0f)));
    btVector3 origin(getOriginOfTile(row, column));
    
    concatenateWall(btTransform(rot, origin), isPartOfSolvedPath);
    
}

void MeshMazeCreator::createCeilingWall(const unsigned int row, const unsigned int column, unsigned int _id, bool isPartOfSolvedPath)
{
    btMatrix3x3 rot(btQuaternion(DEGREES_TO_RADIANS(180.0f),
                                 DEGREES_TO_RADIANS(0.0f),
                                 DEGREES_TO_RADIANS(0.0f)));
    btVector3 origin(getOriginOfTile(row, column));
    
    origin.setY(origin.y() + (getTileHalfExtends().z() * 2.0f));
    
    concatenateWall(btTransform(rot, origin), isPartOfSolvedPath);
}

void MeshMazeCreator::concatenateWall(const btTransform &transform, bool isPartOfSolvedPath)
{
    m_MeshObject->getAttributes(m_vertexData, transform);    

    for(int i = 0; i < m_vertexData.size(); i++)
        m_MazeVertexData.push_back(m_vertexData.at(i));
}
