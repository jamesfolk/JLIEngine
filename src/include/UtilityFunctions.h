//
//  UtilityFunctions.h
//  GameAsteroids
//
//  Created by James Folk on 3/28/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef GameAsteroids_UtilityFunctions_h
#define GameAsteroids_UtilityFunctions_h

#include "btScalar.h"
#include "btVector3.h"
#include "btMatrix3x3.h"
#include "btQuaternion.h"
#include "btTransform.h"
#include "BulletCollision/NarrowPhaseCollision/btManifoldPoint.h"
#include "btAlignedObjectArray.h"

#include <stdlib.h>
#include <limits>
#include <string>

#include <algorithm>
#include <functional>
#include <cctype>
#include <locale>

static void getFrom4x4Matrix(const btTransform &t, btScalar *m);
static btTransform setFrom4x4Matrix(const btScalar *m);


static inline int randomInteger()
{
    return (rand() % RAND_MAX);
}
//returns a random integer between low and high
static inline int randomIntegerRange(int low, int high)
{
    return low + (int)rand()/((int)RAND_MAX/(high-low));
}

//returns a random btScalar between zero and 1
static inline btScalar randomScalar()
{
    return (btScalar)rand()/(btScalar)RAND_MAX;
}

inline btScalar randomScalarInRange(btScalar low, btScalar high)
{
    return low + (btScalar)rand()/((btScalar)RAND_MAX/(high-low));
}

//returns a random bool
static inline bool   randomBool()
{
	if (randomScalar() > 0.5) return true;
	
	else return false;
}

//returns a random btScalar in the range -1 < n < 1
static inline btScalar randomScalarClamped()
{
    return randomScalar() - randomScalar();
}

static inline btScalar RADIANS_TO_DEGREES(btScalar radians)
{
    return ((radians) * (180.0 / M_PI));
}

static inline btScalar DEGREES_TO_RADIANS(btScalar angle)
{
    return ((angle) / 180.0 * M_PI);
}


const btVector3 g_vYawAxis	= btVector3(0.0f, 1.0f, 0.0f);
const btVector3 g_vRollAxis	= btVector3(0.0f, 0.0f, -1.0f);
const btVector3 g_vPitchAxis = btCross(g_vYawAxis, g_vRollAxis);

const btVector3 g_vSideVector   = (g_vPitchAxis);
const btVector3 g_vUpVector	    = (g_vYawAxis);
const btVector3 g_vHeadingVector = (g_vRollAxis);


static inline bool planeLineIntersection(const btVector3 &plane_position, const btVector3 &plane_normal, const btVector3 &point_0, const btVector3 &point_1, btVector3 *intersection_point)
{
    btVector3 u = point_1 - point_0;
    btVector3 w = point_0 - plane_position;
    
    btScalar D = btDot(plane_normal, u);
    btScalar N = -btDot(plane_normal, w);
    
    if (fabs(D) < 0.00000001)
    {
        if(N == 0)
        {
            *intersection_point = point_0;	//line lies in plane
        }
        else
        {
            return false;					//No intersection
        }
    }
    btScalar sI = N / D;
    if (sI < 0 || sI > 1)
        return false;                       // no intersection
    
    *intersection_point = point_0 + sI * u;                 // compute segment intersect point
    return true;
}

static inline btVector3 pointToWorldSpace(const btVector3 &vPoint,
                            const btVector3 &vAgentHeading,
                            const btVector3 &vAgentSide,
                            const btVector3 &vAgentPosition)
{
	if(vAgentHeading.length2() != 0 && vAgentSide.length2() != 0)
	{
		btQuaternion qHeading(g_vRollAxis, 0);
		btQuaternion qSide(g_vPitchAxis, 0);
		btQuaternion qUp(g_vYawAxis, 0);
		btTransform tTransform((qHeading * qSide * qUp), vPoint);
		
		return (tTransform * vAgentPosition);
	}
	return vAgentPosition;
}

//static inline GLKMatrix4 getGLKMatrix4(const btTransform &transform)
//{
//    GLKMatrix4 _out;
//    
//    //    btVector3 tmp = transform.getOrigin();
//    
//    
//    _out.m[12] = transform.getOrigin().x();
//    _out.m[13] = transform.getOrigin().y();
//    _out.m[14] = transform.getOrigin().z();
//    
//    //    tmp = transform.getBasis().getRow(0);
//    
//    _out.m[0] = transform.getBasis().getRow(0).x();
//    _out.m[4] = transform.getBasis().getRow(0).y();
//    _out.m[8] = transform.getBasis().getRow(0).z();
//    //    tmp = transform.getBasis().getRow(1);
//    _out.m[1] = transform.getBasis().getRow(1).x();
//    _out.m[5] = transform.getBasis().getRow(1).y();
//    _out.m[9] = transform.getBasis().getRow(1).z();
//    //    tmp = transform.getBasis().getRow(2);
//    _out.m[2] = transform.getBasis().getRow(2).x();
//    _out.m[6] = transform.getBasis().getRow(2).y();
//    _out.m[10] = transform.getBasis().getRow(2).z();
//    
//    //    _out.m[3] = 0.0;
//    //    _out.m[7] = 0.0;
//    //    _out.m[11] = 0.0;
//    //    _out.m[15] = 1.0;
//    
//    _out.m[3] = transform.getBasis().getRow(0).w();
//    _out.m[7] = transform.getBasis().getRow(1).w();
//    _out.m[11] = transform.getBasis().getRow(2).w();
//    _out.m[15] = transform.getOrigin().w();
//    
//    return _out;
//}

//static inline GLKMatrix4 getGLKMatrix4(const btTransform &transform)
//{
//    GLKMatrix4 _out;
//    _out.m[3] = 0.0;
//    _out.m[7] = 0.0;
//    _out.m[11] = 0.0;
//    _out.m[15] = 1.0;
//    btVector3 tmp = transform.getOrigin();
//    _out.m[12] = tmp.x();
//    _out.m[13] = tmp.y();
//    _out.m[14] = tmp.z();
//    tmp = transform.getBasis().getRow(0);
//    _out.m[0] = tmp.x();
//    _out.m[4] = tmp.y();
//    _out.m[8] = tmp.z();
//    tmp = transform.getBasis().getRow(1);
//    _out.m[1] = tmp.x();
//    _out.m[5] = tmp.y();
//    _out.m[9] = tmp.z();
//    tmp = transform.getBasis().getRow(2);
//    _out.m[2] = tmp.x();
//    _out.m[6] = tmp.y();
//    _out.m[10] = tmp.z();
//    return _out;
//}



static inline btScalar fixAngle(const btScalar angle)
{
    btScalar degAngle(RADIANS_TO_DEGREES(angle));
    btScalar pi = RADIANS_TO_DEGREES(M_PI * 2.0f);
    btScalar pi_2 = RADIANS_TO_DEGREES(M_PI);
    btScalar fixedAngle = angle;
    
    if(degAngle < 0.0f)
    {
        fixedAngle = pi + degAngle;
        fixedAngle += pi_2;
    }
    
    return DEGREES_TO_RADIANS(fixedAngle);
}
static inline btVector3 fixVector3(const btVector3 &vec)
{
    btVector3 vRet(vec);
    
    if(isnan(vRet.x()))
        vRet.setX(0);
    if(isinf(vRet.x()))
        vRet.setX(std::numeric_limits<btScalar>::max());
    
    if(isnan(vRet.y()))
        vRet.setY(0);
    if(isinf(vRet.y()))
        vRet.setY(std::numeric_limits<btScalar>::max());
    
    if(isnan(vRet.z()))
        vRet.setZ(0);
    if(isinf(vRet.z()))
        vRet.setZ(std::numeric_limits<btScalar>::max());
    
    return vRet;
}

/*
inline static btTransform toBtTransform(const egl::core::Matrix4x4 &matrix) {
    btTransform out;
    out.setBasis(btMatrix3x3(matrix.M[0], matrix.M[4], matrix.M[8], matrix.M[1], matrix.M[5], matrix.M[9], matrix.M[2], matrix.M[6], matrix.M[10]));
    out.setOrigin(btVector3(matrix.M[12], matrix.M[13], matrix.M[14]));
    return out;
}

inline static egl::core::Matrix4x4 toMatrix4x4(const btTransform &transform) {
    egl::core::Matrix4x4 out;
    out.M[3] = 0.0;
    out.M[7] = 0.0;
    out.M[11] = 0.0;
    out.M[15] = 1.0;
    btVector3 tmp = transform.getOrigin();
    out.M[12] = tmp.x();
    out.M[13] = tmp.y();
    out.M[14] = tmp.z();
    tmp = transform.getBasis().getRow(0);
    out.M[0] = tmp.x();
    out.M[4] = tmp.y();
    out.M[8] = tmp.z();
    tmp = transform.getBasis().getRow(1);
    out.M[1] = tmp.x();
    out.M[5] = tmp.y();
    out.M[9] = tmp.z();
    tmp = transform.getBasis().getRow(2);
    out.M[2] = tmp.x();
    out.M[6] = tmp.y();
    out.M[10] = tmp.z();
    return out;
}
*/

//DiffuseRimLighting
//static const char *VERTEX_SHADER        = "DiffuseRimLighting.vsh";
//static const char *FRAGMENT_SHADER      = "DiffuseRimLighting.fsh";

static const char VERTEX_SHADER[]        = "TextureShader.vsh";
static const char FRAGMENT_SHADER[]      = "TextureShader.fsh";

//static const char *VERTEX_SHADER        = "DebugShader.vsh";
//static const char *FRAGMENT_SHADER      = "DebugShader.fsh";

namespace DebugString
{

    static const int CHARLEN = 1024;
    
    static inline void log(const std::string &msg)
    {
        NSString *_msg = [NSString stringWithUTF8String:msg.c_str()];
        NSLog(@"%@", _msg);
    }
    
    static inline std::string boolStr(bool value)
    {
        if(value)
            return std::string("True");
        return std::string("False");
    }
    
    static inline std::string btVectorStr(const btVector3 &value, const bool print_w = true)
    {
        char _value[CHARLEN];
        if(print_w)
            std::sprintf(_value, "{%f, %f, %f, %f}", value.x(), value.y(), value.z(), value.w());
        else
            std::sprintf(_value, "{%f, %f, %f}", value.x(), value.y(), value.z());
        return std::string(_value);
    }
    
    static inline std::string btScalarStr(const btScalar value)
    {
        char _value[CHARLEN];
        std::sprintf(_value, "%.2f", value);
        return std::string(_value);
    }
    
//    static inline std::string GLKMatrix3Str(const GLKMatrix3 value)
//    {
//        char _value[CHARLEN];
//        
//        std::sprintf(_value, "[%f, %f, %f]\n[%f, %f, %f]\n[%f, %f, %f]",
//                     value.m00, value.m01, value.m02,
//                     value.m10, value.m11, value.m12,
//                     value.m20, value.m21, value.m22);
//        return std::string(_value);
//    }
    
//    static inline std::string GLKMatrix4Str(const GLKMatrix4 value)
//    {
//        char _value[CHARLEN];
//        
//        std::sprintf(_value, "[%f, %f, %f, %f]\n[%f, %f, %f, %f]\n[%f, %f, %f, %f]\n[%f, %f, %f, %f]",
//                     value.m00, value.m01, value.m02, value.m03,
//                     value.m10, value.m11, value.m12, value.m13,
//                     value.m20, value.m21, value.m22, value.m23,
//                     value.m30, value.m31, value.m32, value.m33);
//        return std::string(_value);
//    }
    
    static inline std::string btMatrix3x3Str(const btMatrix3x3 &value)
    {
        char _value[CHARLEN];
        
        std::sprintf(_value,
                     "%s\n%s\n%s",
                     btVectorStr(value.getRow(0), false).c_str(),
                     btVectorStr(value.getRow(1), false).c_str(),
                     btVectorStr(value.getRow(2), false).c_str());
        return std::string(_value);
        
        
    }
    static inline std::string btTransformStr(const btTransform &value)
    {
        char _value[CHARLEN];
        
        std::sprintf(_value,
                     "%s\n%s\n%s\n%s",
                     btVectorStr(value.getBasis().getRow(0)).c_str(),
                     btVectorStr(value.getBasis().getRow(1)).c_str(),
                     btVectorStr(value.getBasis().getRow(2)).c_str(),
                     btVectorStr(value.getOrigin()).c_str());
        return std::string(_value);
    }
    
    static inline std::string btManifoldPointStr(const btManifoldPoint &pt)
    {
        char _value[CHARLEN];
        
        btScalar impulse = pt.getAppliedImpulse();
        btScalar distance = pt.getDistance();
        btVector3 wPosOnA(pt.getPositionWorldOnA());
        btVector3 wPosOnB(pt.getPositionWorldOnB());
        
        std::sprintf(_value, "impulse : %s\ndistance : %s\nWorld Pos On A : %s\n World Pos On B : %s",
                     btScalarStr(impulse).c_str(),
                     btScalarStr(distance).c_str(),
                     btVectorStr(wPosOnA).c_str(),
                     btVectorStr(wPosOnB).c_str());
        return std::string(_value);
    }
    /*
     GLKMatrix4
     bool m_hidden;
     GLKMatrix3 m_normalMatrix;
     btVector3 m_scale;
     bool m_Tagged;
     btVector3 m_Heading;
     btVector3 m_Up;
     btTransform
     btMatrix3x3
     btManifoldPoint
     */
}

static btQuaternion createPitchRotation(const btScalar angle)
{
    return btQuaternion(g_vPitchAxis, angle);
}

static btQuaternion createYawRotation(const btScalar angle)
{
    return btQuaternion(g_vYawAxis, angle);
}

static btQuaternion createRollRotation(const btScalar angle)
{
    return btQuaternion(g_vRollAxis, angle);
}

static btVector3 TriNormal(const btVector3 &v0, const btVector3 &v1, const btVector3 &v2)
{
    //const btVector3 n=btCross(b-a,c-a).normalized();
    
    return btCross(v1-v0,v2-v0).normalized();
    
//    // return the normal of the triangle
//    // inscribed by v0, v1, and v2
//    btVector3 _v1 = v1 - v0;
//    btVector3 _v2 = v2 - v1;
//    
//    btVector3 cp = _v1.cross(_v2);
//    
//    //btVector3 cp=cross(v1-v0,v2-v1);
//    btScalar m=cp.length();
//    if(m==0) return btVector3(1,0,0);
//    return cp*(btScalar(1.0)/m);
}

// trim from start
static inline std::string &ltrim(std::string &s)
{
    s.erase(s.begin(), std::find_if(s.begin(), s.end(), std::not1(std::ptr_fun<int, int>(std::isspace))));
    return s;
}

// trim from end
static inline std::string &rtrim(std::string &s)
{
    s.erase(std::find_if(s.rbegin(), s.rend(), std::not1(std::ptr_fun<int, int>(std::isspace))).base(), s.end());
    return s;
}

// trim from both ends
static inline std::string &trim(std::string &s)
{
    return ltrim(rtrim(s));
}

/*
private void drawCasteljau(List<point> points) {
    Point tmp;
    for (double t = 0; t <= 1; t += 0.001) {
        tmp = getCasteljauPoint(points.Count-1, 0, t);
        image.SetPixel(tmp.X, tmp.Y, color);
    }
}


private Point getCasteljauPoint(int r, int i, double t) {
    if(r == 0) return points[i];
    
    Point p1 = getCasteljauPoint(r - 1, i, t);
    Point p2 = getCasteljauPoint(r - 1, i + 1, t);
    
    return new Point((int) ((1 - t) * p1.X + t * p2.X), (int) ((1 - t) * p1.Y + t * p2.Y));
}
 */

/*
function deCasteljau(i,j)
begin
    if i = 0 then
        return P0,j
    else
        return (1-u)* deCasteljau(i-1,j) + u* deCasteljau(i-1,j+1)
end
*/

static btVector3 deCasteljauPoint(const int i, const int j, const double t, const btAlignedObjectArray<btVector3> &points)
{
    if(i == 0)
        return points[j];
    return (1 - t) * deCasteljauPoint(i - 1, j, t, points) + t * deCasteljauPoint(i - 1, j + 1, t, points);
}

static btVector3 calculateBezierPoint(btScalar t, const btAlignedObjectArray<btVector3> &points)
{
    btAssert(t >= 0.f && t <= 1.f);
    
    return deCasteljauPoint(points.size() - 1, 0, t, points);
}

//$$[x, y] = (1 – t)P_0 + tP_1$$
static btVector3 calculateBezierPoint(btScalar t,
                               const btVector3 &p0,
                               const btVector3 &p1)
{
    btAssert(t >= 0.f && t <= 1.f);
    
    btScalar u =   (1.f - t);
    
    btVector3 p(u * p0); //first term     (1 – t) * P_0
    p += (t * p1); //second term          t * P_1
    
    return p;
}


//$$[x, y] = (1 – t)^2P_0 + 2(1 – t)tP_1 + t^2P_2$$
static btVector3 calculateBezierPoint(btScalar t,
                               const btVector3 &p0,
                               const btVector3 &p1,
                               const btVector3 &p2)
{
    btAssert(t >= 0.f && t <= 1.f);
    
    btScalar u =   (1.f - t);
    btScalar tt =  (t * t);
    btScalar uu =  (u * u);
    
    btVector3 p(uu * p0); //first term     (1 – t)^2 * P_0
    p += 2.0f * u * t * p1; //second term   2 * (1 – t) * t * P_1
    p += tt * p2; //third term              t^2 * P_2
    
    return p;
}

//$$[x, y] = (1 – t)^3P_0 + 3(1 – t)^2tP_1 + 3(1 – t)t^2P_2 + t^3P_3$$
static btVector3 calculateBezierPoint(btScalar t,
                               const btVector3 &p0,
                               const btVector3 &p1,
                               const btVector3 &p2,
                               const btVector3 &p3)
{
    btAssert(t >= 0.f && t <= 1.f);
    
    btScalar u =   (1.f - t);
    btScalar tt =  (t * t);
    btScalar uu =  (u * u);
    btScalar uuu = (u * u * u);
    btScalar ttt = (t * t * t);
    
    btVector3 p(uuu * p0); //first term     (1 – t)^3 * P_0
    p += 3.0f * uu * t * p1; //second term  3 * (1 – t)^2 * t * P_1
    p += 3.0f * u * tt * p2; //third term   3 * (1 – t) * t^2 * P_2
    p += ttt * p3; //fourth term            t^3 * P_3
    
    return p;
}











//
//
//
//class BezierPath
//{
//    List controlPoints;
//    
//    Vector3 CalculateBezierPoint(float t,
//                                 Vector3 p0, Vector3 p1, Vector3 p2, Vector3 p3){...}
//    
//    List GetDrawingPoints()
//    {
//        List drawingPoints = new List();
//        for(int i = 0; i < controlPoints.Count - 3; i+=3)
//        {
//            Vector3 p0 = controlPoints[i];
//            Vector3 p1 = controlPoints[i + 1];
//            Vector3 p2 = controlPoints[i + 2];
//            Vector3 p3 = controlPoints[i + 3];
//            
//            if(i == 0) //Only do this for the first endpoint.
//                //When i != 0, this coincides with the end
//                //point of the previous segment
//            {
//                drawingPoints.Add(CalculateBezierPoint(0, p0, p1, p2, p3));
//            }
//            
//            for(int j = 1; j <= SEGMENTS_PER_CURVE; j++)
//            {
//                float t = j / (float) SEGMENTS_PER_CURVE;
//                drawingPoints.Add(CalculateBezierPoint(t, p0, p1, p2, p3));
//            }
//        }
//        
//        return drawingPoints;
//    }
//}




//#define check_gl_error(__FILE__, __LINE__);() _check_gl_error(__FILE__,__LINE__,__FUNCTION__)

//static void _check_gl_error(const char *file, int line, const char *function) {
//    GLenum err (glGetError());
//    
//    while(err!=GL_NO_ERROR) {
//        std::string error;
//        
//        switch(err) {
//            case GL_INVALID_OPERATION:
//                error="INVALID_OPERATION";
//                break;
//            case GL_INVALID_ENUM:           error="INVALID_ENUM";           break;
//            case GL_INVALID_VALUE:          error="INVALID_VALUE";          break;
//            case GL_OUT_OF_MEMORY:          error="OUT_OF_MEMORY";          break;
//            case GL_INVALID_FRAMEBUFFER_OPERATION:  error="INVALID_FRAMEBUFFER_OPERATION";  break;
//        }
//        
//        NSLog(@"\nGL_%s\n\t%s\n\t%d\n\t%s\n\n", error.c_str(), file, line, function);
//        err=glGetError();
//    }
//}




static inline btTransform makeLookAt(btScalar eyeX, btScalar eyeY, btScalar eyeZ,
                                 btScalar centerX, btScalar centerY, btScalar centerZ,
                                 btScalar upX, btScalar upY, btScalar upZ)
{
    btVector3 ev(eyeX, eyeY, eyeZ );
    btVector3 cv(centerX, centerY, centerZ );
    btVector3 uv( upX, upY, upZ );
    btVector3 n((ev + -cv).normalized());
    btVector3 u((uv.cross(n).normalized()));
    btVector3 v(n.cross(u));
    
    btScalar m[16] = { u.x(), v.x(), n.x(), 0.0f,
        u.y(), v.y(), n.y(), 0.0f,
        u.z(), v.z(), n.z(), 0.0f,
        (-u).dot(ev),
        (-v).dot(ev),
        (-n).dot(ev),
        1.0f };
    
    return setFrom4x4Matrix(m);
    
    

//    btVector3 ev(eyeX, eyeY, eyeZ);
//    btVector3 cv(centerX, centerY, centerZ);
//    btVector3 uv(upX, upY, upZ);
//    btVector3 n((ev + (-cv)).normalized());
//    btVector3 u((uv.cross(n)).normalized());
//    btVector3 v(n.cross(u));
//    
//    btTransform t(btTransform::getIdentity());
//    
//    btVector3 v0(u.x(), u.y(), u.z());
//    v0.setW(0.0f);
//    
//    btVector3 v1(v.x(),v.y(),v.z());
//    v1.setW(0.0f);
//    
//    btVector3 v2(n.x(),n.y(),n.z());
//    v2.setW(0.0f);
//    
//    btMatrix3x3 basis(v0.x(), v0.y(), v0.z(),
//                      v1.x(), v1.y(), v1.z(),
//                      v2.x(), v2.y(), v2.z());
//    
//    
//    btVector3 origin((-u).dot(ev),
//                     (-v).dot(ev),
//                     (-n).dot(ev));
//    origin.setW(1.0f);
//    
//    t.setBasis(basis);
//    t.setOrigin(origin);
//    
//    return t;
}


static inline btTransform makeFrustum(btScalar left, btScalar right,
                               btScalar bottom, btScalar top,
                               btScalar nearZ, btScalar farZ)
{
    btScalar ral = right + left;
    btScalar rsl = right - left;
    btScalar tsb = top - bottom;
    btScalar tab = top + bottom;
    btScalar fan = farZ + nearZ;
    btScalar fsn = farZ - nearZ;
    
    btScalar m[16] = { 2.0f * nearZ / rsl, 0.0f, 0.0f, 0.0f,
        0.0f, 2.0f * nearZ / tsb, 0.0f, 0.0f,
        ral / rsl, tab / tsb, -fan / fsn, -1.0f,
        0.0f, 0.0f, (-2.0f * farZ * nearZ) / fsn, 0.0f };
    
    return setFrom4x4Matrix(m);
}


//static inline btTransform getbtTransform(const GLKMatrix4 &transform)
//{
//    btTransform _out;
//    _out.setBasis(btMatrix3x3(transform.m[0], transform.m[4], transform.m[8], transform.m[1], transform.m[5], transform.m[9], transform.m[2], transform.m[6], transform.m[10]));
//    _out.setOrigin(btVector3(transform.m[12], transform.m[13], transform.m[14]));
//    return _out;
//}

static inline btScalar *getScalarArray(const btMatrix3x3 &t)
{
    static btScalar s[9] =
    {
        t.getRow(0).x(), t.getRow(0).y(), t.getRow(0).z(), 
        t.getRow(1).x(), t.getRow(1).y(), t.getRow(1).z(), 
        t.getRow(2).x(), t.getRow(2).y(), t.getRow(2).z()
    };
    
    return s;
}


static inline btScalar *getScalarArray(const btTransform &t)
{
    static btScalar s[16] =
    {
        t.getBasis().getRow(0).x(), t.getBasis().getRow(0).y(), t.getBasis().getRow(0).z(), t.getBasis().getRow(0).w(),
        t.getBasis().getRow(1).x(), t.getBasis().getRow(1).y(), t.getBasis().getRow(1).z(), t.getBasis().getRow(1).w(),
        t.getBasis().getRow(2).x(), t.getBasis().getRow(2).y(), t.getBasis().getRow(2).z(), t.getBasis().getRow(2).w(),
        t.getBasis().getRow(3).x(), t.getBasis().getRow(3).y(), t.getBasis().getRow(3).z(), t.getBasis().getRow(3).w()
    };
    
    return s;
}

static btTransform makeOrtho(btScalar left, btScalar right,
                             btScalar bottom, btScalar top,
                             btScalar nearZ, btScalar farZ)
{
    btScalar ral = right + left;
    btScalar rsl = right - left;
    btScalar tab = top + bottom;
    btScalar tsb = top - bottom;
    btScalar fan = farZ + nearZ;
    btScalar fsn = farZ - nearZ;
    
    btScalar m[16] = { 2.0f / rsl, 0.0f, 0.0f, 0.0f,
        0.0f, 2.0f / tsb, 0.0f, 0.0f,
        0.0f, 0.0f, -2.0f / fsn, 0.0f,
        -ral / rsl, -tab / tsb, -fan / fsn, 1.0f };
    
    return setFrom4x4Matrix(m);
    
//    btScalar ral = right + left;
//    btScalar rsl = right - left;
//    btScalar tab = top + bottom;
//    btScalar tsb = top - bottom;
//    btScalar fan = farZ + nearZ;
//    btScalar fsn = farZ - nearZ;
//    
//    btTransform t(btTransform::getIdentity());
//    
//    btVector3 v0(2.0f / rsl, 0.0f,0.0f);
//    v0.setW(0.0f);
//    
//    btVector3 v1(0.0f,2.0f / tsb,0.0f);
//    v1.setW(0.0f);
//    
//    btVector3 v2(0.0f,0.0f,-2.0f / fsn);
//    v2.setW(-1.0f);
//    
//    btMatrix3x3 basis(v0.x(), v0.y(), v0.z(),
//                      v1.x(), v1.y(), v1.z(),
//                      v2.x(), v2.y(), v2.z());
//    
//    btVector3 origin(-ral / rsl,-tab / tsb,-fan / fsn);
//    origin.setW(1.0f);
//    
//    t.setBasis(basis);
//    t.setOrigin(origin);
//    
//    return t;
    
//    GLKMatrix4 m = {
    //0        2.0f / rsl,
    //1        0.0f,
    //2        0.0f,
//3        0.0f,
    //4        0.0f,
    //5        2.0f / tsb,
    //6        0.0f,
//7        0.0f,
    //8        0.0f,
    //9        0.0f,
    //10        -2.0f / fsn,
//11        0.0f,
//12        -ral / rsl,
//13        -tab / tsb,
//14        -fan / fsn,
//15        1.0f };
    
    //return m;
}
/**@brief Set from an array
 * @param m A pointer to a 15 element array (12 rotation(row major padded on the right by 1), and 3 translation */
static inline btTransform setFrom4x4Matrix(const btScalar *m)
{
    btMatrix3x3 basis;
    btVector3 origin;
    
    basis.setFromOpenGLSubMatrix(m);
    origin.setValue(m[12],m[13],m[14]);
    
    basis[0].setW(m[3]);
    basis[1].setW(m[7]);
    basis[2].setW(m[11]);
    origin.setW(m[15]);
    
    return btTransform(basis, origin);
}

/**@brief Fill an array representation
 * @param m A pointer to a 15 element array (12 rotation(row major padded on the right by 1), and 3 translation */
static inline void getFrom4x4Matrix(const btTransform &t, btScalar *m)
{
    t.getBasis().getOpenGLSubMatrix(m);
    
    m[3] = t.getBasis()[0].w();
    m[7] = t.getBasis()[1].w();
    m[11] = t.getBasis()[2].w();
    
    m[12] = t.getOrigin().x();
    m[13] = t.getOrigin().y();
    m[14] = t.getOrigin().z();
    m[15] = t.getOrigin().w();
}


#endif


