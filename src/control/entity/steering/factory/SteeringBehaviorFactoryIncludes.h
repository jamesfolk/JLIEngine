//
//  SteeringBehaviorFactoryIncludes.h
//  GameAsteroids
//
//  Created by James Folk on 3/16/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef GameAsteroids_SteeringBehaviorFactoryIncludes_h
#define GameAsteroids_SteeringBehaviorFactoryIncludes_h

#include <string>

enum SteeringBehaviorTypes
{
    SteeringBehaviorTypes_NONE,
    //SteeringBehaviorTypes_TEMP,
    SteeringBehaviorTypes_Weighted,
    SteeringBehaviorTypes_MAX
};

struct PathInfo
{
    PathInfo(const std::string &curveName = "NONE", bool looped = false):
    m_curveName(curveName),
    m_Looped(looped)
    {
        
    }
    PathInfo(const PathInfo &rhs):
    m_curveName(rhs.m_curveName),
    m_Looped(rhs.m_Looped)
    {
        
    }
    
    std::string m_curveName;
    bool m_Looped;
};

struct SteeringBehaviorInfo
{
    SteeringBehaviorTypes m_Type;
    PathInfo m_PathInfo;
    
    SteeringBehaviorInfo(SteeringBehaviorTypes type = SteeringBehaviorTypes_Weighted,
                         PathInfo path = PathInfo("beziercurve", false)) :
    m_Type(type),
    m_PathInfo(path)
    {}
    
//    int value()const
//    {
//        return m_Type;
//    }
//    
//    bool operator() (const SteeringBehaviorInfo& lhs, const SteeringBehaviorInfo& rhs) const{return lhs.value()<rhs.value();}
};

struct WeightedSteeringBehaviorInfo : public SteeringBehaviorInfo
{   
    WeightedSteeringBehaviorInfo(){}
    
//    int value()const
//    {
//        return SteeringBehaviorInfo::value();
//    }
//    
//    bool operator() (const SteeringBehaviorInfo& lhs, const SteeringBehaviorInfo& rhs) const{return lhs.value()<rhs.value();}
};


#endif
