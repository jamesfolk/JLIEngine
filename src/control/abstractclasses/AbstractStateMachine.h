#ifndef AbstractStateMachine_H
#define AbstractStateMachine_H

//------------------------------------------------------------------------
//
//  Name:   AbstractStateMachine.h
//
//  Desc:   State machine class. Inherit from this class and create some 
//          states to give your agents FSM functionality
//
//  Author: Mat Buckland (fup@ai-junkie.com)
//
//------------------------------------------------------------------------
#include <string>

#include "AbstractState.h"
#include "Telegram.h"

#include <queue>
#include "AbstractBehavior.h"

template <class entity_type>
class AbstractStateMachine :
public AbstractBehavior<entity_type>
{
private:

    AbstractState<entity_type>*   m_pCurrentState;

    //a record of the last state the agent was in
    AbstractState<entity_type>*   m_pPreviousState;

    //this is called every time the FSM is updated
    AbstractState<entity_type>*   m_pGlobalState;
    
    std::queue<AbstractState<entity_type>*> m_StateQueue;
    std::queue<AbstractState<entity_type>*> m_GlobalStateQueue;


    void	setCurrentState(AbstractState<entity_type>* state);
    void	setGlobalState(AbstractState<entity_type>* state);
    void	setPreviousState(AbstractState<entity_type>* state);


    //change to a new state
    void  changeCurrentState(AbstractState<entity_type>* pNewState);
    void  changeGlobalState(AbstractState<entity_type>* pNewState);

//    void update_internal(std::queue<AbstractState<entity_type>*> &stateQueue,
//                         AbstractState<entity_type>* the_state,
//                         btScalar deltaTimeStep);
public:
    AbstractStateMachine(entity_type* owner = NULL);

    virtual ~AbstractStateMachine();

    

    //call this to update the FSM
    void  update(btScalar deltaTimeStep);

    bool  handleMessage(const Telegram& msg);

    
    
    void pushCurrentState(AbstractState<entity_type>* pNewState);
    void pushGlobalState(AbstractState<entity_type>* pNewState);
    
    //change state back to the previous state
    void  revertToPreviousState();

    //returns true if the current state's type is equal to the type of the
    //class passed as a parameter. 
    bool  isInState(const AbstractState<entity_type>& st)const;

    AbstractState<entity_type>*	getCurrentState();
    const AbstractState<entity_type>*	getCurrentState() const;
    
    AbstractState<entity_type>*	getGlobalState();
    const AbstractState<entity_type>*	getGlobalState() const;
    
    AbstractState<entity_type>*	getPreviousState();
    const AbstractState<entity_type>*	getPreviousState() const;

    //only ever used during debugging to grab the name of the current state
    std::string getNameOfCurrentState()const;
};

template <class entity_type>
AbstractStateMachine<entity_type>::AbstractStateMachine(entity_type* owner):
AbstractBehavior<entity_type>(owner),
m_pCurrentState(NULL),
m_pPreviousState(NULL),
m_pGlobalState(NULL)
{
}

template <class entity_type>
AbstractStateMachine<entity_type>::~AbstractStateMachine()
{
}

template <class entity_type>
void	AbstractStateMachine<entity_type>::setCurrentState(AbstractState<entity_type>* state)
{
    m_pCurrentState = state;
}

template <class entity_type>
void	AbstractStateMachine<entity_type>::setGlobalState(AbstractState<entity_type>* state)
{
    m_pGlobalState = state;
}

template <class entity_type>
void	AbstractStateMachine<entity_type>::setPreviousState(AbstractState<entity_type>* state)
{
    m_pPreviousState = state;
}

//call this to update the FSM
template <class entity_type>
void  AbstractStateMachine<entity_type>::update(btScalar deltaTimeStep)
{
    if(m_GlobalStateQueue.size() > 0)
    {
        AbstractState<entity_type>* state = m_GlobalStateQueue.front();
        changeGlobalState(state);
        m_GlobalStateQueue.pop();
    }
    
    //if a global state exists, call its update method, else do nothing
    if(getGlobalState())
    {
        getGlobalState()->update(AbstractBehavior<entity_type>::getOwner(),
                                 deltaTimeStep);
    }
    
    if(m_StateQueue.size() > 0)
    {
        AbstractState<entity_type>* state = m_StateQueue.front();
        changeCurrentState(state);
        m_StateQueue.pop();
    }
    
    //same for the current state
    if (getCurrentState())
    {
        getCurrentState()->update(AbstractBehavior<entity_type>::getOwner(),
                                  deltaTimeStep);
    }
    
    
    
    
}

template <class entity_type>
bool  AbstractStateMachine<entity_type>::handleMessage(const Telegram& msg)
{
    //first see if the current state is valid and that it can handle
    //the message
    if (getCurrentState() && getCurrentState()->onMessage(AbstractBehavior<entity_type>::getOwner(), msg))
    {
        return true;
    }
    
    //if not, and if a global state has been implemented, send
    //the message to the global state
    if (getGlobalState() && getGlobalState()->onMessage(AbstractBehavior<entity_type>::getOwner(), msg))
    {
        return true;
    }
    
    return false;
}

template <class entity_type>
//change to a new state
void  AbstractStateMachine<entity_type>::changeCurrentState(AbstractState<entity_type>* pNewState)
{
    setPreviousState(m_pCurrentState);
    
    if(getCurrentState())
    {
        getCurrentState()->exit(AbstractBehavior<entity_type>::getOwner());
    }
    
    setCurrentState(pNewState);
    
    if(getCurrentState())
    {
        getCurrentState()->enter(AbstractBehavior<entity_type>::getOwner());
    }
}


template <class entity_type>
//change to a new state
void  AbstractStateMachine<entity_type>::changeGlobalState(AbstractState<entity_type>* pNewState)
{
    if(getGlobalState())
    {
        getGlobalState()->exit(AbstractBehavior<entity_type>::getOwner());
    }
    
    setGlobalState(pNewState);
    
    if(getGlobalState())
    {
        getGlobalState()->enter(AbstractBehavior<entity_type>::getOwner());
    }
}

template <class entity_type>
void AbstractStateMachine<entity_type>::pushCurrentState(AbstractState<entity_type>* pNewState)
{
    m_StateQueue.push(pNewState);
}

template <class entity_type>
void AbstractStateMachine<entity_type>::pushGlobalState(AbstractState<entity_type>* pNewState)
{
    m_GlobalStateQueue.push(pNewState);
}

template <class entity_type>
//change state back to the previous state
void  AbstractStateMachine<entity_type>::revertToPreviousState()
{
    changeCurrentState(getPreviousState());
}

template <class entity_type>
//returns true if the current state's type is equal to the type of the
//class passed as a parameter.
bool  AbstractStateMachine<entity_type>::isInState(const AbstractState<entity_type>& st)const
{
    if(getCurrentState()->getID() == st.getID())
        return true;
    return false;
}

template <class entity_type>
AbstractState<entity_type>*	AbstractStateMachine<entity_type>::getCurrentState()
{
    return m_pCurrentState;
}

template <class entity_type>
const AbstractState<entity_type>*	AbstractStateMachine<entity_type>::getCurrentState() const
{
    return m_pCurrentState;
}

template <class entity_type>
AbstractState<entity_type>*	AbstractStateMachine<entity_type>::getGlobalState()
{
    return m_pGlobalState;
}

template <class entity_type>
const AbstractState<entity_type>*	AbstractStateMachine<entity_type>::getGlobalState() const
{
    return m_pGlobalState;
}

template <class entity_type>
AbstractState<entity_type>*	AbstractStateMachine<entity_type>::getPreviousState()
{
    return m_pPreviousState;
}

template <class entity_type>
const AbstractState<entity_type>*	AbstractStateMachine<entity_type>::getPreviousState() const
{
    return m_pPreviousState;
}

template <class entity_type>
//only ever used during debugging to grab the name of the current state
std::string         AbstractStateMachine<entity_type>::getNameOfCurrentState()const
{
    return getCurrentState()->getName();
}




#endif


