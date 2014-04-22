//
//  AbstractSingleton.h
//  GameAsteroids
//
//  Created by James Folk on 3/21/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__AbstractSingleton__
#define __GameAsteroids__AbstractSingleton__

#include <atomic>
//#include <assert.h>
#include "btScalar.h"

template <class SINGLETONS_TYPE>
class AbstractSingleton
{
public:
    static void createInstance()
    {
        s_Instance = new SINGLETONS_TYPE();
//        s_Instance2 = new std::atomic<SINGLETONS_TYPE*>();
        
//        *s_Instance2 = s_Instance;
    }
    
    static void destroyInstance()
    {
//        delete s_Instance2;
//        s_Instance2 = NULL;
        
        delete s_Instance;
        s_Instance = NULL;
    }
    
    static SINGLETONS_TYPE *const getInstance()
    {
        return s_Instance;
//        return s_Instance2->load();
    }
    
    static bool hasInstance()
    {
        return (NULL != s_Instance);
    }
    
public:
    AbstractSingleton(){}
    virtual ~AbstractSingleton(){}
private:
    static SINGLETONS_TYPE *s_Instance;
//    static std::atomic<SINGLETONS_TYPE*> *s_Instance2;
};

template <class SINGLETONS_TYPE>
SINGLETONS_TYPE *AbstractSingleton<SINGLETONS_TYPE>::s_Instance = NULL;

//template <class SINGLETONS_TYPE>
//std::atomic<SINGLETONS_TYPE*> *AbstractSingleton<SINGLETONS_TYPE>::s_Instance2 = NULL;

#endif /* defined(__GameAsteroids__AbstractSingleton__) */
