//
//  geometry.h
//  MazeADay
//
//  Created by James Folk on 2/4/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "control/abstractclasses/AbstractFactoryIncludes.h"
#include "control/abstractclasses/AbstractBehavior.h"
//#include "control/abstractclasses/AbstractCounter.h"
#include "control/abstractclasses/AbstractFactory.h"

#ifndef __MazeADay__geometry__
#define __MazeADay__geometry__
namespace Foo {
    class Geometry {
    public:
        enum GeomType{
            POINT,
            CIRCLE
        };
        
        virtual ~Geometry() {}
        virtual int draw() = 0;
        
        //
        // Factory method for all the Geometry objects
        //
        static Geometry *create(GeomType i);
    };

    struct Point : Geometry  {
        int draw() { return 1; }
        double width() { return 1.0; }
    };

    struct Circle : Geometry  {
        int draw() { return 2; }
        double radius() { return 1.5; }
    };

    //
    // Factory method for all the Geometry objects
    //
    Geometry *Geometry::create(GeomType type) {
        switch (type) {
            case POINT: return new Point();
            case CIRCLE: return new Circle();
            default: return 0;
        }
    }
}
#endif /* defined(__MazeADay__geometry__) */
