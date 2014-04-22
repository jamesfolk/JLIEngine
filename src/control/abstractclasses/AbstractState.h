#ifndef AbstractState_H
#define AbstractState_H
//------------------------------------------------------------------------
//
//  Name:   AbstractState.h
//
//  Desc:   abstract base class to define an interface for a state
//
//  Author: Mat Buckland (fup@ai-junkie.com)
//
//------------------------------------------------------------------------

#include "btScalar.h"
#include "AbstractFactory.h"

struct Telegram;

template <class entity_type>
class AbstractState :
public AbstractFactoryObject
{
public:
    AbstractState():m_isFinished(true){}
    virtual ~AbstractState(){}
    
    virtual void enter(entity_type*)=0;
    
    virtual void update(entity_type*, btScalar deltaTimeStep)=0;
    
    virtual void exit(entity_type*)=0;
    
    virtual bool onMessage(entity_type*, const Telegram&)=0;
private:
    bool m_isFinished;
};

#endif