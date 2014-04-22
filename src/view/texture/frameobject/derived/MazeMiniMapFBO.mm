//
//  MazeMiniMapFBO.cpp
//  BaseProject
//
//  Created by library on 10/21/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "MazeMiniMapFBO.h"

#include "MazeCreator.h"
#include "UtilityFunctions.h"
#include "btVector3.h"
#include "BaseEntity.h"
#include "ShaderFactory.h"
#include "ViewObjectFactory.h"
#include "ImageFileEditor.h"
#include "EntityFactory.h"
#include "MeshMazeCreator.h"
#include "VertexAttributeLoader.h"
#include "CameraFactory.h"

//#define check_gl_error() _check_gl_error(__FILE__,__LINE__,__FUNCTION__);
#include "VertexBufferObject.h"



MazeMiniMapFBO::MazeMiniMapFBO(const MazeMiniMapFBOInfo &info):
BaseTextureBufferObject(info),
m_mapTextureBehaviorFactoryID(0),
m_mapBallTextureBehaviorFactoryID(0),
m_mapViewObjectID(0),
m_mapBallViewObjectID(0),
m_pMapSprite(NULL),
m_pMapBallSprite(NULL),
m_BallSpriteInitialPosition(new btVector3()),
m_Offset(new btVector3()),
m_pMazeTexture(NULL)
{
    
    size_t row_count = info.row_count;
    size_t column_count = info.column_count;
    size_t mazeseed = info.maze_seed;
    
    m_pMazeTexture = dynamic_cast<TextureMazeCreator*>(MazeCreator::getInstance()->CreateNew(row_count, column_count, MazeRenderType_Texture, mazeseed));
    
    if(info.solve)
        solve();
    else
        unsolve();
    
    m_pMazeTexture->setMeshMazeBoardHalfExtends(info.boardHalfExtends);
    m_pMazeTexture->setMeshMazeTileHalfExtends(info.tileHalfExtends);
    
    
    
    struct vertexclass_s
    {
        GLuint width;
        GLuint height;
        
        void operator() (int i, btVector3 &to, const btVector3 &from)
        {
            to = btVector3(from.x() * width,
                           from.y() * height,
                           from.z());
        }
    };
    
    TextureBehaviorInfo *tbInfo = NULL;
    BaseViewObject *vo = NULL;
    btAlignedObjectArray<GLushort> indiceData;
    btAlignedObjectArray<VertexAttributes_Vertex_Normal_Color_UVLayer1> vertexData;
    BaseEntityInfo *constructionInfo = NULL;
    size_t offset_position;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    tbInfo = new TextureBehaviorInfo();
    m_mapTextureBehaviorFactoryID = TextureBehaviorFactory::getInstance()->create(tbInfo);
    delete tbInfo;
    
    
    
    m_mapViewObjectID = ViewObjectFactory::createViewObject("sprite",
                                                            0, 0,
                                                            &m_mapTextureBehaviorFactoryID, 1);
    vo = ViewObjectFactory::getInstance()->get(m_mapViewObjectID);
    VertexAttributeLoader::getInstance()->createSpriteVertices(indiceData, vertexData);
    VertexAttributeLoader::getInstance()->load(vo, indiceData, vertexData);
    
    constructionInfo = new BaseEntityInfo(m_mapViewObjectID, 0, 0, true);
    m_pMapSprite = EntityFactory::createEntity<BaseEntity, BaseEntityInfo>(constructionInfo);
    delete constructionInfo;
    
    
    vo = ViewObjectFactory::getInstance()->get(m_mapViewObjectID);
    
    vertexclass_s vertexclass0;
    vertexclass0.width = 2048;
    vertexclass0.height = 2048;
    
    vo->getTextureBehavior(0)->setXOffset(0);
    vo->getTextureBehavior(0)->setYOffset(0);
    vo->getTextureBehavior(0)->setWidthOfSubTexture(2048);
    vo->getTextureBehavior(0)->setHeightOfSubTexture(2048);
    vo->getTextureBehavior(0)->setWidthOfTexture(2048);
    vo->getTextureBehavior(0)->setHeightOfTexture(2048);
    
    offset_position = reinterpret_cast<size_t>(vo->getPositionOffset());
    vo->set_each_attribute<vertexclass_s, btVector3>(vertexclass0, offset_position);
    
    m_pMapSprite->setOrigin(btVector3((CameraFactory::getScreenWidth() + 1024) - m_pMazeTexture->getBoardDimensions().x(), 1024 ,0));
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    tbInfo = new TextureBehaviorInfo();
    m_mapBallTextureBehaviorFactoryID = TextureBehaviorFactory::getInstance()->create(tbInfo);
    delete tbInfo;
    
    m_mapBallViewObjectID = ViewObjectFactory::createViewObject("sprite",
                                                                0, 0,
                                                                &m_mapBallTextureBehaviorFactoryID, 1);
    vo = ViewObjectFactory::getInstance()->get(m_mapBallViewObjectID);
    VertexAttributeLoader::getInstance()->createSpriteVertices(indiceData, vertexData);
    VertexAttributeLoader::getInstance()->load(vo, indiceData, vertexData);
    
    constructionInfo = new BaseEntityInfo(m_mapBallViewObjectID, 0, 0, true);
    m_pMapBallSprite = EntityFactory::createEntity<BaseEntity, BaseEntityInfo>(constructionInfo);
    delete constructionInfo;
    
    vo = ViewObjectFactory::getInstance()->get(m_mapBallViewObjectID);
    
    vertexclass_s vertexclass1;
    vertexclass1.width = 2048;
    vertexclass1.height = 2048;
    
    vo->getTextureBehavior(0)->setXOffset(0);
    vo->getTextureBehavior(0)->setYOffset(0);
    vo->getTextureBehavior(0)->setWidthOfSubTexture(2048);
    vo->getTextureBehavior(0)->setHeightOfSubTexture(2048);
    vo->getTextureBehavior(0)->setWidthOfTexture(2048);
    vo->getTextureBehavior(0)->setHeightOfTexture(2048);
    
    offset_position = reinterpret_cast<size_t>(vo->getPositionOffset());
    vo->set_each_attribute<vertexclass_s, btVector3>(vertexclass1, offset_position);
    
    
    
    
    
    m_pPlayerAvatar = info.playerAvatar;
    
    
    m_pMapSprite->hide();
    m_pMapBallSprite->hide();
}

MazeMiniMapFBO::~MazeMiniMapFBO()
{
    IDType _id;
    m_pPlayerAvatar = NULL;
    
    _id = m_pMapBallSprite->getID();
    EntityFactory::getInstance()->destroy(_id);
    
    ViewObjectFactory::getInstance()->destroy(m_mapBallViewObjectID);
    TextureBehaviorFactory::getInstance()->destroy(m_mapBallTextureBehaviorFactoryID);
    
    _id = m_pMapSprite->getID();
    EntityFactory::getInstance()->destroy(_id);
    
    ViewObjectFactory::getInstance()->destroy(m_mapViewObjectID);
    TextureBehaviorFactory::getInstance()->destroy(m_mapTextureBehaviorFactoryID);
    
    delete m_pMazeTexture;
    delete m_Offset;
    delete m_BallSpriteInitialPosition;
}

void MazeMiniMapFBO::update()
{
    float scale = m_pMazeTexture->getMiniMapScale();
    //DebugString::log(DebugString::btVectorStr(m_pPlayerAvatar->getOrigin()));
    
    
    btVector3 origin(*m_BallSpriteInitialPosition);
    m_pMapBallSprite->setOrigin(origin + *m_Offset);
    
    origin.setX(origin.x() + ((m_pPlayerAvatar->getOrigin().x() * scale)));
    origin.setY(origin.y() - ((m_pPlayerAvatar->getOrigin().z() * scale)));
    origin.setZ(0);
    m_pMapSprite->setOrigin(origin + *m_Offset);
}

void MazeMiniMapFBO::solve()
{
    m_pMazeTexture->SolveMaze();
    m_pMazeTexture->Draw();
    m_solved = true;
}
void MazeMiniMapFBO::unsolve()
{
    m_pMazeTexture->UnSolveMaze();
    m_pMazeTexture->Draw();
    m_solved = false;
}
bool MazeMiniMapFBO::issolved()const
{
    return m_solved;
}

void MazeMiniMapFBO::renderFBO()
{
    glEnable(GL_DEPTH_TEST);check_gl_error()
    
    glEnable (GL_BLEND);check_gl_error()
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);check_gl_error()
    

    
    glUseProgram(ShaderFactory::getInstance()->getCurrentShaderID());check_gl_error()
    
    m_BallSpriteInitialPosition->setValue((CameraFactory::getScreenWidth() + 1024) - m_pMazeTexture->getBoardDimensions().x(), 1024 ,100);
    
    m_Offset->setValue(CameraFactory::getScreenWidth() * -.5f, CameraFactory::getScreenHeight() * .5f, 0);
    
    
    BaseViewObject *vo = NULL;
    
    vo = ViewObjectFactory::getInstance()->get(m_mapBallViewObjectID);
    vo->loadTextureName(0, m_pMazeTexture->getBallImageFileEditor()->name());
    
    vo = ViewObjectFactory::getInstance()->get(m_mapViewObjectID);
    vo->loadTextureName(0, m_pMazeTexture->getMazeImageFileEditor()->name());
    
    m_pMapSprite->show();
    m_pMapBallSprite->show();
    
    EntityFactory::getInstance()->render();
    
    m_pMapSprite->hide();
    m_pMapBallSprite->hide();
    
    glUseProgram(0);check_gl_error()
}