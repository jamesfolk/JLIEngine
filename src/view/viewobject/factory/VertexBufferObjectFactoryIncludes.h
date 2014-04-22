//
//  VertexBufferObjectFactoryIncludes.h
//  MazeADay
//
//  Created by James Folk on 3/30/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef MazeADay_VertexBufferObjectFactoryIncludes_h
#define MazeADay_VertexBufferObjectFactoryIncludes_h

struct VertexBufferObjectInfo
{
    std::string m_viewObjectName;
    unsigned int m_MinNumberOfVertexBufferObjects;
    
public:
    VertexBufferObjectInfo(const std::string &viewObjectName,
                           const unsigned int minimumNumberOfVBOs = 100):
    m_viewObjectName(viewObjectName),
    m_MinNumberOfVertexBufferObjects(minimumNumberOfVBOs)
    {
        
    }
    virtual ~VertexBufferObjectInfo(){}
};

#endif
