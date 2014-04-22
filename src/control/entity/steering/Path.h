#ifndef PATH_H
#define PATH_H
//------------------------------------------------------------------------
//
//  Name:   Path.h
//
//  Desc:   class to define, manage, and traverse a path (defined by a series of 2D vectors)
//          
//
//  Author: Mat Buckland 2003 (fup@ai-junkie.com)
//
//------------------------------------------------------------------------
//#include <list>
//#include <cassert>

//#include "2d/Vector2D.h"
#include "btAlignedObjectArray.h"
#include "btActionInterface.h"
#include "SteeringBehaviorFactoryIncludes.h"

class BaseEntity;

enum LoopType_e
{
    LoopType_Cylindrical,
    LoopType_Linear
};

enum PathIncrement_e
{
    PathIncrement_Negative = -1,
    PathIncrement_None = 0,
    PathIncrement_Positive = 1
};

class Path :
public btActionInterface
{
private:
    btAlignedObjectArray<btVector3> m_WayPoints;
    //btAlignedObjectArray<btVector3> *m_ControlPoints;
    int m_CurrentWayPointIndex;
    bool m_bLooped;
    std::string m_CurveName;
    btTransform *m_worldTransform;
    btVector3 *m_scale;
    LoopType_e m_LoopType;
    PathIncrement_e m_Increment;
    BaseEntity *m_pAttachedTo;
    unsigned int m_WayPointAttachedIndex;
    btVector3 m_AttachmentOffset;
    bool m_isAutoIncrement;
public:
    
    //clickitinc.com
    
    const btTransform &getWorldTransform() const;
    void setWorldTransform(const btTransform& worldTrans);
    
    const btVector3 &getOrigin()const;
    void setOrigin(const btVector3 &pos);
    
    void attachToEntity(BaseEntity *entity, unsigned int waypoint, const btVector3 &offset = btVector3(0.0f, 0.0f, 0.0f));
    void unAttachFromEntity();
    
    btQuaternion getRotation()const;
    void setRotation(const btQuaternion &rot);
    
    const btVector3 &getScale()const;
    void setScale(const btVector3 &scale);    
    
    virtual void updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep);
    virtual void debugDraw(btIDebugDraw* debugDrawer);

    Path(const PathInfo &constructionInfo);
    virtual ~Path();

    btVector3 getWayPoint(const unsigned int index)const;
    unsigned int getNumberOfWayPoints()const;
    
    btVector3 getCurrentWaypoint()const;
    bool isFinished()const;

    bool setNextWaypoint();
    
    bool isLooped()const;
    void enableLoop(bool enable = true);
    void setLoopType(const LoopType_e type);
    LoopType_e getLoopType()const;
    void reverse();
    void setPathIncrement(const PathIncrement_e increment);
    PathIncrement_e getPathIncrement()const;

    void setPath(const std::string &curveName);

    const btAlignedObjectArray<btVector3> &getPath()const;
    
    btScalar getAverageDistanceBetweenPoints()const;
    
    void enableAutomaticIncrement(bool enable = true);
    bool isAutomaticIncrement()const;
};




#endif