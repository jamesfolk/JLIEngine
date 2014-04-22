#include "Path.h"
#include "ZipFileResourceLoader.h"
#include "BaseEntity.h"

const btTransform &Path::getWorldTransform() const
{
    if(m_pAttachedTo)
    {
        btVector3 offset(m_pAttachedTo->getOrigin() + m_AttachmentOffset);
        btVector3 attachedWaypoint(m_WayPoints[m_WayPointAttachedIndex]);
        
        m_worldTransform->setOrigin(offset - attachedWaypoint);
    }
    
    return *m_worldTransform;
}
void Path::setWorldTransform(const btTransform& worldTrans)
{
    *m_worldTransform = worldTrans;
}

const btVector3 &Path::getOrigin()const
{
    return m_worldTransform->getOrigin();
}
void Path::setOrigin(const btVector3 &pos)
{
    btAssert(!m_pAttachedTo && "unattach first");
    
    m_worldTransform->setOrigin(pos);
}

void Path::attachToEntity(BaseEntity *entity, unsigned int waypoint, const btVector3 &offset)
{
    btAssert(entity);
    btAssert(waypoint < m_WayPoints.size());
    
    m_pAttachedTo = entity;
    m_WayPointAttachedIndex = waypoint;
    m_AttachmentOffset = offset;
}

void Path::unAttachFromEntity()
{
    m_pAttachedTo = NULL;
}

btQuaternion Path::getRotation()const
{
    return m_worldTransform->getRotation();
}
void Path::setRotation(const btQuaternion &rot)
{
    m_worldTransform->setRotation(rot);
}

const btVector3 &Path::getScale()const
{
    return *m_scale;
}
void Path::setScale(const btVector3 &scale)
{
    *m_scale = scale;
}

void Path::updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep)
{
    
}

void Path::debugDraw(btIDebugDraw* debugDrawer)
{
    static btVector3 lineDrawColor(1.0f, 0.0f, 1.0f);
    static btVector3 controlDrawColor(0.0f, 1.0f, 0.0f);
    int i = 0;
    
    for(i = 0; i < m_WayPoints.size() - 1; ++i)
        debugDrawer->drawLine(getWayPoint(i), getWayPoint(i + 1), lineDrawColor);
    
    if(isLooped() && (getLoopType() == LoopType_Cylindrical))
        debugDrawer->drawLine(getWayPoint(i), getWayPoint(0), lineDrawColor);
    
//    for(i = 0; i < getNumberOfControlPointPairs(); ++i)
//    {
//        btAlignedObjectArray<btVector3> controlPair = getControlPointPair(i);
//        debugDrawer->drawLine(controlPair[0], controlPair[1], controlDrawColor);
//    }
}

Path::Path(const PathInfo &constructionInfo):
m_CurrentWayPointIndex(0), 
m_bLooped(constructionInfo.m_Looped),
m_CurveName(constructionInfo.m_curveName),
m_worldTransform(new btTransform(btTransform::getIdentity())),
m_scale(new btVector3(1.0f, 1.0f, 1.0f)),
m_LoopType(LoopType_Cylindrical),
m_Increment(PathIncrement_Positive),
m_pAttachedTo(NULL),
m_WayPointAttachedIndex(0),
m_AttachmentOffset(btVector3(0,0,0)),
m_isAutoIncrement(false)
{
    setPath(constructionInfo.m_curveName);
    
    WorldPhysics::getInstance()->addActionObject(this);
}

Path::~Path()
{
    WorldPhysics::getInstance()->removeActionObject(this);

    delete m_scale;
    m_scale = NULL;
    
    delete m_worldTransform;
    m_worldTransform = NULL;
}


btVector3 Path::getWayPoint(const unsigned int index)const
{
    btAssert(index < m_WayPoints.size());
    
    return  ((getWorldTransform() * (m_WayPoints)[index]) * (*m_scale));
}

unsigned int Path::getNumberOfWayPoints()const
{
    return m_WayPoints.size();
}

//returns the current waypoint
btVector3 Path::getCurrentWaypoint()const
{
    return getWayPoint(m_CurrentWayPointIndex);
}

//returns true if the end of the list has been reached
bool Path::isFinished()const
{
    return (!isLooped() && (m_CurrentWayPointIndex >= (m_WayPoints.size() - 1)));
}

//moves the iterator on to the next waypoint in the list
bool Path::setNextWaypoint()
{
    if(m_Increment == PathIncrement_None)
        return false;
    
    m_CurrentWayPointIndex += m_Increment;
    
    if(!isAutomaticIncrement())
        m_Increment = PathIncrement_None;
    bool loop_around = false;
    
    if(m_CurrentWayPointIndex < 0)
    {
        m_CurrentWayPointIndex = 0;
        loop_around = isLooped();
    }
    else if(m_CurrentWayPointIndex >= m_WayPoints.size())
    {
        m_CurrentWayPointIndex = m_WayPoints.size() - 1;
        loop_around = isLooped();
    }
    
    if(loop_around)
    {
        if(getLoopType() == LoopType_Cylindrical)
        {
            if((m_WayPoints.size() - 1) == m_CurrentWayPointIndex)
            {
                m_CurrentWayPointIndex = 0;
            }
            else if(0 == m_CurrentWayPointIndex)
            {
                m_CurrentWayPointIndex = m_WayPoints.size() - 1;
            }
        }
        else if(getLoopType() == LoopType_Linear)
        {
            reverse();
        }
    }
    return true;
}

bool Path::isLooped()const
{
    if(m_bLooped)
        return true;
    return false;
}

void Path::enableLoop(bool enable)
{
    m_bLooped = enable;
}

void Path::setLoopType(const LoopType_e type)
{
    m_LoopType = type;
}
LoopType_e Path::getLoopType()const
{
    return m_LoopType;
}
void Path::reverse()
{
    if(PathIncrement_Positive == m_Increment)
        m_Increment = PathIncrement_Negative;
    else
        m_Increment = PathIncrement_Positive;
}
void Path::setPathIncrement(const PathIncrement_e increment)
{
    m_Increment = increment;
}
PathIncrement_e Path::getPathIncrement()const
{
    return m_Increment;
}
void Path::setPath(const std::string &curveName)
{
    m_CurveName = curveName;
    ZipFileResourceLoader::getInstance()->getCurveVertices(m_CurveName)->getAttributes(m_WayPoints);
    
    m_CurrentWayPointIndex = 0;
}

const btAlignedObjectArray<btVector3> &Path::getPath()const
{
    return m_WayPoints;
}

btScalar Path::getAverageDistanceBetweenPoints()const
{
    btScalar dist = 0;
    
    if(m_WayPoints.size() > 0)
    {
        for (int i = 0; i < m_WayPoints.size() - 1; i++)
        {
            dist += getWayPoint(i).distance2(getWayPoint(i + 1));
            
        }
        
        dist = (btSqrt(dist) / getNumberOfWayPoints());
    }
    
    return dist;
}

void Path::enableAutomaticIncrement(bool enable)
{
    m_isAutoIncrement = enable;
}
bool Path::isAutomaticIncrement()const
{
    return m_isAutoIncrement;
}
