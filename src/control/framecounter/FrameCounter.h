//
//  FrameCounter.h
//  GameAsteroids
//
//  Created by James Folk on 3/20/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__FrameCounter__
#define __GameAsteroids__FrameCounter__

#include "control/abstractclasses/AbstractFactory.h"

#include <time.h>
#include <string>
#include "btAlignedObjectArray.h"

enum TimerType
{
    TimerType_NONE,
    TimerType_Timer,
    TimerType_Clock,
    TimerType_StopWatch,
    TimerType_MAX
};

struct TimerInfo
{
    TimerInfo(TimerType type = TimerType_NONE):
    m_timerType(type){}
    
    TimerType m_timerType;
};

class BaseTimer:
public AbstractFactoryObject
{
    friend class FrameCounter;
public:
    SIMD_FORCE_INLINE IDType getID()const
    {
        return AbstractFactoryObject::getID();
    }
    
    SIMD_FORCE_INLINE const std::string &getName()const
    {
        return AbstractFactoryObject::getName();
    }
    
    SIMD_FORCE_INLINE void setName(const std::string &name)
    {
        AbstractFactoryObject::setName(name);
    }
    
    
    virtual std::string toString()const
    {
        //http://www.cplusplus.com/reference/ctime/strftime/
        static char buffer[64] = "";
        const char *format = "%T";
        
        time_t time = (time_t)getMilliseconds();
        struct tm * timeinfo = localtime (&time);
        strftime (buffer, 64, format, timeinfo);
        
        return std::string(buffer);
    }
    
    virtual long getMilliseconds()const
    {
        return (long)m_rawtime;
    }
    
    virtual void setMilliseconds(long ms)
    {
        m_rawtime = (time_t)ms;
    }
protected:
    BaseTimer():m_rawtime(0){}
    virtual ~BaseTimer(){}
    
    virtual void update(const btScalar deltaTime) = 0;
    
    
    
    
    
    
    std::string formatMilliseconds(const long currentMilliseconds)const
    {
        char buffer[64] = "";
        
        int milliseconds = currentMilliseconds % 1000;
        int seconds = ((currentMilliseconds / 1000)) % 60;
        int minutes = ((currentMilliseconds / 1000) / (60)) % 60;
        int hours   = ((currentMilliseconds / 1000) / (60 * 24)) % 24;
        
        sprintf(buffer, "%.2d:%.2d:%.2d.%.4d", hours, minutes, seconds, milliseconds);
        
        return std::string(buffer);
    }
    
    virtual void clearTime()
    {
        m_rawtime = (time_t)0;
    }
    
    virtual void addMilliseconds(const long milliseconds)
    {
        m_rawtime += (time_t)milliseconds;
    }
    
    time_t m_rawtime;
};

class Timer : public BaseTimer
{
    friend class FrameCounter;
protected:
    Timer() :
    m_IsPaused(true)
    {
        
    }
    
    virtual ~Timer()
    {
        
    }
public:
    
    virtual void update(const btScalar deltaTime)
    {
        if(!m_IsPaused)
        {
            long milliseconds = (deltaTime * 1000);
            
            m_rawtime -= milliseconds;
            
            if(m_rawtime < 0)
                m_rawtime = 0;
        }
    }
public:
    void start(const long startMilliseconds)
    {
        clearTime();
        addMilliseconds(startMilliseconds);
        m_IsPaused = false;
    }
    
    void enablePause(const bool pause = true)
    {
        m_IsPaused = pause;
    }
    
    bool isPaused()const
    {
        return m_IsPaused;
    }
    
    bool isFinished()const
    {
        return (getMilliseconds() == 0);
    }
    
    
    
    virtual std::string toString()const
    {
        return formatMilliseconds(getMilliseconds());
    }
    
private:
    bool m_IsPaused;
};

class Clock : public BaseTimer
{
    friend class FrameCounter;
protected:
    Clock(){time(&m_rawtime);}
    virtual ~Clock(){}
public:
    virtual void update(const btScalar deltaTime)
    {
        time(&m_rawtime);
    }
};

class StopWatch : public BaseTimer
{
    friend class FrameCounter;
protected:
    StopWatch(const size_t num_laps = 10) :
    m_CurrentLapIndex(0),
    m_IsStopped(true)
    {
        m_Laps.resize(num_laps);
        m_Laps[m_CurrentLapIndex] = 0;
    }
    virtual ~StopWatch()
    {
    }
public:
    virtual void update(const btScalar deltaTime)
    {
        if(!m_IsStopped)
        {
            long milliseconds = deltaTime * 1000;
            
            addMilliseconds(milliseconds);
            
            m_Laps[m_CurrentLapIndex] += milliseconds;
        }
    }
    
public:
    
    bool start()
    {
        if(m_IsStopped)
        {
            m_IsStopped = false;
            
            return true;
        }
        return false;
    }
    
    bool stop()
    {
        if(!m_IsStopped)
        {
            m_IsStopped = true;
            
            return true;
        }
        return false;
    }
    
    bool isStopped()const
    {
        return m_IsStopped;
    }
    
    bool reset()
    {
        if(m_IsStopped)
        {
            m_CurrentLapIndex = 0;
            m_Laps[m_CurrentLapIndex] = 0;
            
            clearTime();
            
            return true;
        }
        return false;
    }
    
    bool lap(long &current_time)
    {
        if(!m_IsStopped)
        {
            long current_time = 0;
            
            if(m_CurrentLapIndex + 1 < m_Laps.size())
            {
                current_time = m_Laps[m_CurrentLapIndex];
                
                m_Laps[++m_CurrentLapIndex] = 0;
                
                return true;
            }
        }
        
        return false;
    }
    
    
    
    virtual std::string toString()const
    {
        return formatMilliseconds(getMilliseconds());
    }
    
    virtual std::string toString(const size_t lap)const
    {
        if(lap <=  m_CurrentLapIndex)
        {
            return formatMilliseconds(m_Laps[m_CurrentLapIndex]);
        }
        
        return std::string(""); 
    }
    
private:
    size_t m_CurrentLapIndex;
    bool m_IsStopped;
    btAlignedObjectArray<long> m_Laps;
    
};

class FrameCounter  :
public AbstractFactory<FrameCounter, TimerInfo, BaseTimer>
{
    friend class AbstractSingleton;
    friend class AbstractFactoryObject;
    
private:
    
    double m_Count;
    double m_Diff;
    
    NSInteger  m_FramesElapsed;
    NSInteger m_framesPerSecond;
    
    
    
    //copy ctor and assignment should be private
    FrameCounter(const FrameCounter&);
    FrameCounter& operator=(const FrameCounter&);
    
    FrameCounter():m_Count(0), m_Diff(0), m_FramesElapsed(0){}
    
    btAlignedObjectArray<BaseTimer*> m_Timers;
    
protected:
    
    virtual BaseTimer *ctor(TimerInfo*);
    virtual BaseTimer *ctor(int type = 0);
    virtual void dtor(BaseTimer*);
public:
    void update(double milliseconds);
    
    double getCurrentTime()const;
    double getCurrentDiffTime()const;

    
    void reset();
    
    void start();
    NSInteger  framesElapsedSinceStartCalled()const;
    
    void setPreferredFramesPerSecond(NSInteger frames);
    int getPreferredFramesPerSecond()const;
    
};

#endif /* defined(__GameAsteroids__FrameCounter__) */
