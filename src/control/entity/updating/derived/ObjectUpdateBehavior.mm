//
//  ObjectUpdateBehavior.cpp
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "ObjectUpdateBehavior.h"


#include "BaseEntity.h"
#include "BaseCollisionResponseBehavior.h"
#include "RigidEntity.h"
#include "btRigidBody.h"

#include "FrameCounter.h"
#include "EntityFactory.h"
#include "RigidEntity.h"

ObjectUpdateBehavior::ObjectUpdateBehavior(const ObjectUpdateBehaviorInfo& constructionInfo):
BaseUpdateBehavior(constructionInfo)
{
    TimerInfo timerInfo;
    
    timerInfo.m_timerType = TimerType_Timer;
    m_timerID = FrameCounter::getInstance()->create(&timerInfo);
    
    
    
}

ObjectUpdateBehavior::~ObjectUpdateBehavior()
{
    
}

#include "SteeringEntity.h"
#include "EntityStateMachineFactory.h"
#include "SteeringBehaviorFactory.h"

void ObjectUpdateBehavior::update(btCollisionWorld* collisionWorld, btScalar deltaTimeStep)
{
    Timer *timer = dynamic_cast<Timer*>(FrameCounter::getInstance()->get(m_timerID));
    IDType _id = 0;
    
    if(timer->isFinished())
    {
        getOwner()->hide();
        
//        SteeringEntity *p = dynamic_cast<SteeringEntity*>(getOwner());
//        
//        if(p->getStateMachine())
//        {
//            _id = p->getStateMachine()->getID();
//            EntityStateMachineFactory::getInstance()->destroy(_id);
//        }
//        
//        if(p->getSteeringBehavior())
//        {
//            _id = p->getSteeringBehavior()->getID();
//            SteeringBehaviorFactory::getInstance()->destroy(_id);
//        }
        
        //WorldPhysics::getInstance()->removeRigidBody(p->getRigidBody());
        
//        SteeringEntity *p = dynamic_cast<SteeringEntity*>(getOwner());
//        _id = p->getID();
//        EntityFactory::getInstance()->destroy(_id);
        
        
        //getOwner()->hide();
        
//        RigidEntity *e = dynamic_cast<RigidEntity*>(getOwner());
//        WorldPhysics::getInstance()->removeRigidBody(e->getRigidBody());
//        
//        
//        IDType _id = getOwner()->getID();
//        EntityFactory::getInstance()->destroy(_id);
        
        //
    }
//    ObjectCollisionResponseBehavior *colResponse = dynamic_cast<ObjectCollisionResponseBehavior*>(getOwner()->getCollisionResponseBehavior());
//    
//    RigidEntity *pObject = dynamic_cast<RigidEntity*>(getOwner());
//    pObject->getRigidBody()->applyCentralImpulse(btVector3(0,-1000,0));
}

void ObjectUpdateBehavior::startTimer()
{
    Timer *timer = dynamic_cast<Timer*>(FrameCounter::getInstance()->get(m_timerID));
    timer->start(1 * 1000);
}
