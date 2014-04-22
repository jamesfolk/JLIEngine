//
//  OcclusionBuffer.h
//  GameAsteroids
//
//  Created by James Folk on 4/22/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__OcclusionBuffer__
#define __GameAsteroids__OcclusionBuffer__

#include "btBulletDynamicsCommon.h"
#include "CameraFactory.h"
#include "BaseCamera.h"

struct OcclusionBuffer
{
    struct WriteOCL
	{
        static inline bool Process(btScalar& q,btScalar v) { if(q<v) q=v;return(false); }
	};
    struct QueryOCL
	{
        static inline bool Process(btScalar& q,btScalar v) { return(q<=v); }
	};
    bool							initialized;
    btAlignedObjectArray<btScalar>	buffer;
    int								sizes[2];
    btScalar						scales[2];
    btScalar						offsets[2];
    btScalar						wtrs[16];
    btVector3						eye;
    btVector3						neardist;
    btScalar						ocarea;
    btScalar						qrarea;
    //GLuint							texture;
    OcclusionBuffer()
	{
        initialized=false;
        neardist=btVector3(2,2,2);
        ocarea=(btScalar)0;
        qrarea=(btScalar)0;
	}
    void		setup(int w,int h)
	{
        initialized=true;
        sizes[0]=w;
        sizes[1]=h;
        scales[0]=w/2;
        scales[1]=h/2;
        offsets[0]=scales[0]+0.5;
        offsets[1]=scales[1]+0.5;
        //glGenTextures(1,&texture);
        clear();
	}
    void		clear()
	{
        buffer.resize(0);
        buffer.resize(sizes[0]*sizes[1],0);
	}
    void		initialize()
	{
        if(!initialized)
		{
            setup(128,128);
		}
        //GLint		v[4];
        //GLfloat	m[16],p[16];
        //glGetIntegerv(GL_VIEWPORT,v);
        //glGetDoublev(GL_MODELVIEW_MATRIX,m);
        //glGetDoublev(GL_PROJECTION_MATRIX,p);
        
//        GLKMatrix4 cameraLocationMatrix = getGLKMatrix4(CameraFactory::getInstance()->getCurrentCamera()->getWorldTransform().inverse());
        btTransform cameraLocationMatrix(CameraFactory::getInstance()->getCurrentCamera()->getWorldTransform().inverse());
        
//        GLKMatrix4 _projectionMatrix = CameraFactory::getInstance()->getCurrentCamera()->getProjection();
        btTransform projectionMatrix(CameraFactory::getInstance()->getCurrentCamera()->getProjection2());
        
        
//        GLKMatrix4 mvp = GLKMatrix4Multiply(_projectionMatrix, cameraLocationMatrix);
        btTransform mvp(projectionMatrix * cameraLocationMatrix);
        
        mvp.getOpenGLMatrix(wtrs);
//        for(int i=0;i<16;++i)
//        {
//            wtrs[i]=mvp.m[i];
//        }
        clear();
	}
//    void		drawBuffer(	btScalar l,btScalar t,
//                           btScalar r,btScalar b)
//	{
//        btAlignedObjectArray<GLubyte>	data;
//        data.resize(buffer.size());
//        for(int i=0;i<data.size();++i)
//		{
//            data[i]=int(32/buffer[i])%255;
//		}
//        glBindTexture(GL_TEXTURE_2D,texture);
//        glDisable(GL_BLEND);
//        glEnable(GL_TEXTURE_2D);
//        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
//        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);
//        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
//        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
//        glTexImage2D(GL_TEXTURE_2D,0,GL_LUMINANCE,sizes[0],sizes[1],0,GL_LUMINANCE,GL_UNSIGNED_BYTE,&data[0]);
//        glBegin(GL_QUADS);
//        glColor4ub(255,255,255,255);
//        glTexCoord2f(0,0);glVertex2f(l,t);
//        glTexCoord2f(1,0);glVertex2f(r,t);
//        glTexCoord2f(1,1);glVertex2f(r,b);
//        glTexCoord2f(0,1);glVertex2f(l,b);
//        glEnd();
//        glDisable(GL_TEXTURE_2D);
//	}
    btVector4	transform(const btVector3& x) const
	{
        btVector4	t;
        t[0]	=	x[0]*wtrs[0]+x[1]*wtrs[4]+x[2]*wtrs[8]+wtrs[12];
        t[1]	=	x[0]*wtrs[1]+x[1]*wtrs[5]+x[2]*wtrs[9]+wtrs[13];
        t[2]	=	x[0]*wtrs[2]+x[1]*wtrs[6]+x[2]*wtrs[10]+wtrs[14];
        t[3]	=	x[0]*wtrs[3]+x[1]*wtrs[7]+x[2]*wtrs[11]+wtrs[15];
        return(t);
	}
    static bool	project(btVector4* p,int n)
	{
        for(int i=0;i<n;++i)
		{
            //const btScalar	iw=1/p[i][3];
            p[i][2]=1/p[i][3];
            p[i][0]*=p[i][2];
            p[i][1]*=p[i][2];
		}
        return(true);
	}
    template <const int NP>
    static int	clip(const btVector4* pi,btVector4* po)
	{
        btScalar	s[NP];
        int			m=0;
        for(int i=0;i<NP;++i)
		{
            s[i]=pi[i][2]+pi[i][3];
            if(s[i]<0) m+=1<<i;
		}
        if(m==((1<<NP)-1)) return(0);
        if(m!=0)
		{
            int n=0;
            for(int i=NP-1,j=0;j<NP;i=j++)
			{
                const btVector4&	a=pi[i];
                const btVector4&	b=pi[j];
                const btScalar		t=s[i]/(a[3]+a[2]-b[3]-b[2]);
                if((t>0)&&(t<1))
				{
                    po[n][0]	=	a[0]+(b[0]-a[0])*t;
                    po[n][1]	=	a[1]+(b[1]-a[1])*t;
                    po[n][2]	=	a[2]+(b[2]-a[2])*t;
                    po[n][3]	=	a[3]+(b[3]-a[3])*t;
                    ++n;
				}
                if(s[j]>0) po[n++]=b;
			}
            return(n);
		}
        for(int i=0;i<NP;++i) po[i]=pi[i];
        return(NP);
	}
    template <typename POLICY>
    inline bool	draw(	const btVector4& a,
                     const btVector4& b,
                     const btVector4& c,
                     const btScalar minarea)
	{
        const btScalar		a2=(b-a).cross(c-a)[2];
        if(a2>0)
		{
            if(a2<minarea)	return(true);
            const int		x[]={	(int)(a.x()*scales[0]+offsets[0]),
                (int)(b.x()*scales[0]+offsets[0]),
                (int)(c.x()*scales[0]+offsets[0])};
            const int		y[]={	(int)(a.y()*scales[1]+offsets[1]),
                (int)(b.y()*scales[1]+offsets[1]),
                (int)(c.y()*scales[1]+offsets[1])};
            const btScalar	z[]={	a.z(),b.z(),c.z()};
            const int		mix=btMax(0,btMin(x[0],btMin(x[1],x[2])));
            const int		mxx=btMin(sizes[0],1+btMax(x[0],btMax(x[1],x[2])));
            const int		miy=btMax(0,btMin(y[0],btMin(y[1],y[2])));
            const int		mxy=btMin(sizes[1],1+btMax(y[0],btMax(y[1],y[2])));
            const int		width=mxx-mix;
            const int		height=mxy-miy;
            if((width*height)>0)
			{
                const int		dx[]={	y[0]-y[1],
                    y[1]-y[2],
                    y[2]-y[0]};
                const int		dy[]={	x[1]-x[0]-dx[0]*width,
                    x[2]-x[1]-dx[1]*width,
                    x[0]-x[2]-dx[2]*width};
                const int		a=x[2]*y[0]+x[0]*y[1]-x[2]*y[1]-x[0]*y[2]+x[1]*y[2]-x[1]*y[0];
                const btScalar	ia=1/(btScalar)a;
                const btScalar	dzx=ia*(y[2]*(z[1]-z[0])+y[1]*(z[0]-z[2])+y[0]*(z[2]-z[1]));
                const btScalar	dzy=ia*(x[2]*(z[0]-z[1])+x[0]*(z[1]-z[2])+x[1]*(z[2]-z[0]))-(dzx*width);
                int				c[]={	miy*x[1]+mix*y[0]-x[1]*y[0]-mix*y[1]+x[0]*y[1]-miy*x[0],
                    miy*x[2]+mix*y[1]-x[2]*y[1]-mix*y[2]+x[1]*y[2]-miy*x[1],
                    miy*x[0]+mix*y[2]-x[0]*y[2]-mix*y[0]+x[2]*y[0]-miy*x[2]};
                btScalar		v=ia*((z[2]*c[0])+(z[0]*c[1])+(z[1]*c[2]));
                btScalar*		scan=&buffer[miy*sizes[1]];
                for(int iy=miy;iy<mxy;++iy)
				{
                    for(int ix=mix;ix<mxx;++ix)
					{
                        if((c[0]>=0)&&(c[1]>=0)&&(c[2]>=0))
						{
                            if(POLICY::Process(scan[ix],v)) return(true);
						}
                        c[0]+=dx[0];c[1]+=dx[1];c[2]+=dx[2];v+=dzx;
					}
                    c[0]+=dy[0];c[1]+=dy[1];c[2]+=dy[2];v+=dzy;
                    scan+=sizes[0];
				}
			}
		}
        return(false);
	}
    template <const int NP,typename POLICY>
    inline bool	clipDraw(	const btVector4* p,
                         btScalar minarea)
	{
        btVector4	o[NP*2];
        const int	n=clip<NP>(p,o);
        bool		earlyexit=false;
        project(o,n);
        for(int i=2;i<n;++i)
		{
            earlyexit|=draw<POLICY>(o[0],o[i-1],o[i],minarea);
		}
        return(earlyexit);
	}
    void		appendOccluder(	const btVector3& a,
                               const btVector3& b,
                               const btVector3& c)
	{
        const btVector4	p[]={transform(a),transform(b),transform(c)};
        clipDraw<3,WriteOCL>(p,ocarea);
	}
    void		appendOccluder(	const btVector3& a,
                               const btVector3& b,
                               const btVector3& c,
                               const btVector3& d)
	{
        const btVector4	p[]={transform(a),transform(b),transform(c),transform(d)};
        clipDraw<4,WriteOCL>(p,ocarea);
	}
    void		appendOccluder( const btVector3& c,
                               const btVector3& e)
	{
        const btVector4	x[]={	transform(btVector3(c[0]-e[0],c[1]-e[1],c[2]-e[2])),
            transform(btVector3(c[0]+e[0],c[1]-e[1],c[2]-e[2])),
            transform(btVector3(c[0]+e[0],c[1]+e[1],c[2]-e[2])),
            transform(btVector3(c[0]-e[0],c[1]+e[1],c[2]-e[2])),
            transform(btVector3(c[0]-e[0],c[1]-e[1],c[2]+e[2])),
            transform(btVector3(c[0]+e[0],c[1]-e[1],c[2]+e[2])),
            transform(btVector3(c[0]+e[0],c[1]+e[1],c[2]+e[2])),
            transform(btVector3(c[0]-e[0],c[1]+e[1],c[2]+e[2]))};
        static const int	d[]={	1,0,3,2,
            4,5,6,7,
            4,7,3,0,
            6,5,1,2,
            7,6,2,3,
            5,4,0,1};
        for(int i=0;i<(sizeof(d)/sizeof(d[0]));)
		{
            const btVector4	p[]={	x[d[i++]],
                x[d[i++]],
                x[d[i++]],
                x[d[i++]]};
            clipDraw<4,WriteOCL>(p,ocarea);
		}	
	}
    void   appendOccluder( const btVector3& occluderInnerBoxCollisionShapeHalfExtent,
                          const btTransform& collisionObjectWorldTransform
                          )   {
        const btVector3 c(collisionObjectWorldTransform.getOrigin());
        const btVector3& e = occluderInnerBoxCollisionShapeHalfExtent;
        const btMatrix3x3& basis = collisionObjectWorldTransform.getBasis();
        const btVector4   x[]={   transform(c+basis*btVector3(-e[0],-e[1],-e[2])),
            transform(c+basis*btVector3(+e[0],-e[1],-e[2])),
            transform(c+basis*btVector3(+e[0],+e[1],-e[2])),
            transform(c+basis*btVector3(-e[0],+e[1],-e[2])),
            transform(c+basis*btVector3(-e[0],-e[1],+e[2])),
            transform(c+basis*btVector3(+e[0],-e[1],+e[2])),
            transform(c+basis*btVector3(+e[0],+e[1],+e[2])),
            transform(c+basis*btVector3(-e[0],+e[1],+e[2]))};
        static const int   d[]={   1,0,3,2,
            4,5,6,7,
            4,7,3,0,
            6,5,1,2,
            7,6,2,3,
            5,4,0,1};
        for(int i=0;i<(sizeof(d)/sizeof(d[0]));)
        {
            const btVector4   p[]={   x[d[i++]],
                x[d[i++]],
                x[d[i++]],
                x[d[i++]]};
            clipDraw<4,WriteOCL>(p,ocarea);
        }
    }
    inline bool	queryOccluder(	const btVector3& a,
                              const btVector3& b,
                              const btVector3& c)
	{	
        const btVector4	p[]={transform(a),transform(b),transform(c)};
        return(clipDraw<3,QueryOCL>(p,qrarea));
	}
    inline bool	queryOccluder(	const btVector3& a,
                              const btVector3& b,
                              const btVector3& c,
                              const btVector3& d)
	{
        const btVector4	p[]={transform(a),transform(b),transform(c),transform(d)};
        return(clipDraw<4,QueryOCL>(p,qrarea));
	}
    inline bool	queryOccluder(	const btVector3& c,
                              const btVector3& e)
	{
        const btVector4	x[]={	transform(btVector3(c[0]-e[0],c[1]-e[1],c[2]-e[2])),
            transform(btVector3(c[0]+e[0],c[1]-e[1],c[2]-e[2])),
            transform(btVector3(c[0]+e[0],c[1]+e[1],c[2]-e[2])),
            transform(btVector3(c[0]-e[0],c[1]+e[1],c[2]-e[2])),
            transform(btVector3(c[0]-e[0],c[1]-e[1],c[2]+e[2])),
            transform(btVector3(c[0]+e[0],c[1]-e[1],c[2]+e[2])),
            transform(btVector3(c[0]+e[0],c[1]+e[1],c[2]+e[2])),
            transform(btVector3(c[0]-e[0],c[1]+e[1],c[2]+e[2]))};
        for(int i=0;i<8;++i)
		{
            if((x[i][2]+x[i][3])<=0) return(true);
		}
        static const int	d[]={	1,0,3,2,
            4,5,6,7,
            4,7,3,0,
            6,5,1,2,
            7,6,2,3,
            5,4,0,1};
        for(int i=0;i<(sizeof(d)/sizeof(d[0]));)
		{
            const btVector4	p[]={	x[d[i++]],
                x[d[i++]],
                x[d[i++]],
                x[d[i++]]};
            if(clipDraw<4,QueryOCL>(p,qrarea)) return(true);
		}
        return(false);
	}
    
};

#endif /* defined(__GameAsteroids__OcclusionBuffer__) */