/* File: bullet.i */

//#define SWIG_RUNTIME_VERSION
//#define SWIG_TYPE_TABLE "_JLIENGINE_"

%module jli

%ignore btStorageResult;
%ignore CProfileIterator;
%ignore btCollisionAlgorithmConstructionInfo::getDispatcherId();
%ignore btMultiSapBroadphase::quicksort(btBroadphasePairArray& a, int lo, int hi);
%ignore btRaycastVehicle::setRaycastWheelInfo(int wheelIndex , bool isInContact, const btVector3& hitPoint, const btVector3& hitNormal,btScalar depth);

%rename(btScalarPtr) operator btScalar*;
%rename(btScalarConstPtr) operator const btScalar*;
%rename(operator_btVector3) operator btVector3;

%rename(operator_new) operator new;
%rename(operator_delete) operator delete;
%rename(operator_new_array) operator new[];
%rename(operator_delete_array) operator delete[];

%ignore isInside;
%ignore btSelect;

%rename(btSwapEndian_unsigned_short) btSwapEndian(unsigned short);
%rename(btSwapEndian_signed_int) btSwapEndian(unsigned int);
%rename(btSwapEndian_int) btSwapEndian(int);
%rename(btSwapEndian_shore) btSwapEndian(short);

%rename(upcast_const) btGhostObject::upcast(btCollisionObject const *);
%rename(upcast_const) btSoftBody::upcast(btCollisionObject const *);
%rename(upcast_const) btRigidBody::upcast(btCollisionObject const *);
%rename(getOverlappingPairs_const) btGhostObject::getOverlappingPairs() const;

%ignore processAllOverlappingPairs;

%ignore btAxisSweep3Internal;

//%{
//#include "BulletCollision/BroadphaseCollision/btAxisSweep3.h"
//    %}
//
//#include "BulletCollision/BroadphaseCollision/btAxisSweep3.h"



%insert("runtime")

%{
    #include "btBulletDynamicsCommon.h"
%}


//%template(btAxisSweep3Internal_unsigned_short) btAxisSweep3Internal< unsigned short >;
//%template(btAxisSweep3Internal_unsigned_int) btAxisSweep3Internal< unsigned int >;

#include "btBulletDynamicsCommon.h"



%extend btMatrix3x3
{
    const char *__str__()
    {
        static char tmp[1024];
        sprintf(tmp,"btMatrix3x3(TODO)");
        return tmp;
    }
};

%extend btQuaternion
{
    const char *__str__()
    {
        static char tmp[1024];
        sprintf(tmp,"btQuaternion(TODO)");
        return tmp;
    }
    btQuaternion(const btQuaternion &rhs) {
        btQuaternion *v = new btQuaternion(rhs);
        return v;
    }
};

%extend btTransform
{
    const char *__str__()
    {
        static char tmp[1024];
        sprintf(tmp,"btTransform(TODO)");
        return tmp;
    }
};

%extend btVector2
{
    const char *__str__()
    {
        static char tmp[1024];
        sprintf(tmp,"btVector2(%f,%f)", self->x(),self->y());
        return tmp;
    }
};

%extend btVector3
{
    const char *__str__()
    {
        static char tmp[1024];
        sprintf(tmp,"btVector3(%f,%f,%f)", self->x(),self->y(),self->z());
        return tmp;
    }
    btVector3(const btVector3 &rhs) {
        btVector3 *v = new btVector3(rhs);
        return v;
    }
};

%extend btVector4
{
    const char *__str__()
    {
        static char tmp[1024];
        sprintf(tmp,"btVector4(%f,%f,%f,%f)", self->x(),self->y(),self->z(),self->w());
        return tmp;
    }
    btVector4(const btVector4 &rhs) {
        btVector4 *v = new btVector4(rhs);
        return v;
    }
};

%extend btManifoldPoint
{
    const char *__str__()
    {
        static char tmp[1024];
        sprintf(tmp,"\
                Distance: %f\n\
                LifeTime: %d\n\
                PositionOnA btVector3(%f, %f, %f)\n\
                PositionOnB btVector3(%f, %f, %f)\n\
                Applied Impulse %f\n",
                self->getDistance(),
                self->getLifeTime(),
                self->getPositionWorldOnA().x(), self->getPositionWorldOnA().y(), self->getPositionWorldOnA().z(),
                self->getPositionWorldOnB().x(), self->getPositionWorldOnB().y(), self->getPositionWorldOnB().z(),
                self->getAppliedImpulse());
        return tmp;
    }
    
    /*
     btScalar getDistance() const
     {
     return m_distance1;
     }
     int	getLifeTime() const
     {
     return m_lifeTime;
     }
     
     const btVector3& getPositionWorldOnA() const {
     return m_positionWorldOnA;
     //				return m_positionWorldOnB + m_normalWorldOnB * m_distance1;
     }
     
     const btVector3& getPositionWorldOnB() const
     {
     return m_positionWorldOnB;
     }
     
     void	setDistance(btScalar dist)
     {
     m_distance1 = dist;
     }
     
     ///this returns the most recent applied impulse, to satisfy contact constraints by the constraint solver
     btScalar	getAppliedImpulse() const
     {
     return m_appliedImpulse;
     }
     */
}

%include "opengles2.i"
//%include "openal.i"
%include "jli.i"
%include "fmod.i"


