//
//  VertexAttributeLoader.mm
//  GameAsteroids
//
//  Created by James Folk on 5/20/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "VertexAttributeLoader.h"



VertexAttributeLoader::VertexAttributeLoader()
{
    
}
VertexAttributeLoader::~VertexAttributeLoader()
{
    
}

btVector2 VertexAttributeLoader::createVector2(NSArray *array)const
{
    NSNumber *x = [array objectAtIndex:0];
    NSNumber *y = [array objectAtIndex:1];
    
    return btVector2([x doubleValue], [y doubleValue]);
}

btVector3 VertexAttributeLoader::createVector3(NSArray *array)const
{
    NSNumber *x = [array objectAtIndex:0];
    NSNumber *y = [array objectAtIndex:1];
    NSNumber *z = [array objectAtIndex:2];
    
    return btVector3([x doubleValue], [y doubleValue], [z doubleValue]);
}

btVector4 VertexAttributeLoader::createVector4(NSArray *array)const
{
    NSNumber *x = [array objectAtIndex:0];
    NSNumber *y = [array objectAtIndex:1];
    NSNumber *z = [array objectAtIndex:2];
    NSNumber *w = [array objectAtIndex:3];
    
    return btVector4([x doubleValue], [y doubleValue], [z doubleValue], [w doubleValue]);
}

btTransform VertexAttributeLoader::createTransform(NSArray *fromArray)const
{
    NSNumber *xx = [fromArray objectAtIndex:0];
    NSNumber *xy = [fromArray objectAtIndex:1];
    NSNumber *xz = [fromArray objectAtIndex:2];
    NSNumber *yx = [fromArray objectAtIndex:4];
    NSNumber *yy = [fromArray objectAtIndex:5];
    NSNumber *yz = [fromArray objectAtIndex:6];
    NSNumber *zx = [fromArray objectAtIndex:8];
    NSNumber *zy = [fromArray objectAtIndex:9];
    NSNumber *zz = [fromArray objectAtIndex:10];
    
    NSNumber *x = [fromArray objectAtIndex:12];
    NSNumber *y = [fromArray objectAtIndex:13];
    NSNumber *z = [fromArray objectAtIndex:14];
    /*
     const btScalar& xx, const btScalar& xy, const btScalar& xz,
     const btScalar& yx, const btScalar& yy, const btScalar& yz,
     const btScalar& zx, const btScalar& zy, const btScalar& zz
     */
    btMatrix3x3 _btMatrix3x3([xx doubleValue], [xy doubleValue], [xz doubleValue],
                             [yx doubleValue], [yy doubleValue], [yz doubleValue],
                             [zx doubleValue], [zy doubleValue], [zz doubleValue]);
    btVector3 _btVector3([x doubleValue], [y doubleValue], [z doubleValue]);
    
    return btTransform(_btMatrix3x3, _btVector3);
}

void VertexAttributeLoader::createVector2Array(NSArray *fromArray, btAlignedObjectArray<btVector2> &toArray)const
{
    toArray.clear();
    for(int i = 0; i < [fromArray count]; i++)
        toArray.push_back(createVector2([fromArray objectAtIndex:i]));
}

void VertexAttributeLoader::createVector3Array(NSArray *fromArray, btAlignedObjectArray<btVector3> &toArray)const
{
    toArray.clear();
    for(int i = 0; i < [fromArray count]; i++)
        toArray.push_back(createVector3([fromArray objectAtIndex:i]));
}

void VertexAttributeLoader::createVector4Array(NSArray *fromArray, btAlignedObjectArray<btVector4> &toArray)const
{
    toArray.clear();
    for(int i = 0; i < [fromArray count]; i++)
        toArray.push_back(createVector4([fromArray objectAtIndex:i]));
}

void VertexAttributeLoader::createIntArray(NSArray *fromArray, btAlignedObjectArray<GLushort> &toArray)const
{
    toArray.clear();
    for(int i = 0; i < [fromArray count]; i++)
    {
        NSNumber *n = [fromArray objectAtIndex:i];
        toArray.push_back([n integerValue]);
    }
}
/*
template<class VERTEX_ATTRIBUTE>
void VertexAttributeLoader::reload(const BaseViewObject *vo,
                   const btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertexData)
{
    
}
*/