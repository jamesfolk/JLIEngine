//
//  ImageFileEditor.cpp
//  BaseProject
//
//  Created by library on 10/8/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "ImageFileEditor.h"
#import <GLKit/GLKTextureLoader.h>
//#include <OpenGLES/ES2/gl.h>
//#include <OpenGLES/ES2/glext.h>
#include "png.h"
#include "jpeglib.h"
#include "FileLoader.h"

static void jliImageSetAlpha( JLIimage *_SIO2image0,
                              JLIimage *_SIO2image1 )
{
	if( _SIO2image0->bits   == 3				  &&
       _SIO2image1->bits   == 1				  &&
       _SIO2image0->width  == _SIO2image1->width &&
       _SIO2image0->height == _SIO2image1->height )
	{
		unsigned int i   = 0,
        rgb = 0,
        a   = 0,
        size;
        
		unsigned char *tex;
        
		_SIO2image0->bits = 4;
		size = _SIO2image0->width * _SIO2image0->height * _SIO2image0->bits;
		
		tex = new unsigned char[size];
		
		while( i != size )
		{
			tex[ i     ] = _SIO2image0->tex[ rgb + 2 ];
			tex[ i + 1 ] = _SIO2image0->tex[ rgb + 1 ];
			tex[ i + 2 ] = _SIO2image0->tex[ rgb     ];
			tex[ i + 3 ] = _SIO2image1->tex[ a 	     ];
            
			++a;
			rgb += 3;
			i   += 4;
		}
		
		//free( _SIO2image0->tex );
        delete [] _SIO2image0->tex;
        
		_SIO2image0->tex = tex;
	}
}

static void jliImageBlur( JLIimage *_SIO2image )
{
	unsigned int i = 1,
    j,
    w  = _SIO2image->width  - 1,
    h  = _SIO2image->height - 1,
    bw = _SIO2image->width * _SIO2image->bits;
    
	if( _SIO2image->bits < 3 )
	{ return; }
	
	while( i != h )
	{
		j = 1;
		while( j < w )
		{
			unsigned int jb   =   j       * _SIO2image->bits,
            jp   = ( j + 1 ) * _SIO2image->bits,
            jm   = ( j - 1 ) * _SIO2image->bits,
            ib   =   i       * bw,
            im   = ( i - 1 ) * bw,
            ip   = ( i + 1 ) * bw,
            ibjb = ib + jb;
            
			unsigned char *px1 = &_SIO2image->tex[ ib + jb ],
            *px2 = &_SIO2image->tex[ ib + jm ],
            *px3 = &_SIO2image->tex[ ib + jp ],
            *px4 = &_SIO2image->tex[ im + jb ],
            *px5 = &_SIO2image->tex[ ip + jb ],
            *px6 = &_SIO2image->tex[ im + jm ],
            *px7 = &_SIO2image->tex[ im + jp ],
            *px8 = &_SIO2image->tex[ ip + jm ],
            *px9 = &_SIO2image->tex[ ip + jp ];
			
			_SIO2image->tex[ ibjb     ] = ( ( px1[ 0 ] << 2 ) +
                                           ( ( px2[ 0 ] + px3[ 0 ] + px4[ 0 ] + px5[ 0 ] ) << 1 ) +
                                           px6[ 0 ] + px7[ 0 ] + px8[ 0 ] + px9[ 0 ] ) >> 4;
            
			_SIO2image->tex[ ibjb + 1 ] = ( ( px1[ 1 ] << 2 ) +
                                           ( ( px2[ 1 ] + px3[ 1 ] + px4[ 1 ] + px5[ 1 ] ) << 1 ) +
                                           px6[ 1 ] + px7[ 1 ] + px8[ 1 ] + px9[ 1 ] ) >> 4;
            
			_SIO2image->tex[ ibjb + 2 ] = ( ( px1[ 2 ] << 2 ) +
                                           ( ( px2[ 2 ] + px3[ 2 ] + px4[ 2 ] + px5[ 2 ] ) << 1 ) +
                                           px6[ 2 ] + px7[ 2 ] + px8[ 2 ] + px9[ 2 ] ) >> 4;
			++j;
		}
		
		++i;
	}
}

static inline void jliEnableState( unsigned int *_var, unsigned int  _state )
{  *_var = *_var | _state; }


static inline void jliDisableState( unsigned int *_var, unsigned int  _state )
{ *_var = *_var & ~_state; }

static inline unsigned char jliIsStateEnabled( unsigned int _var, unsigned int _state )
{ return _var & _state ? 1 : 0; }

typedef enum
{
	SIO2_IMAGE_MIPMAP = ( 1 << 0 ),
	SIO2_IMAGE_CLAMP  = ( 1 << 1 )
	
} SIO2_IMAGE_FLAG;


typedef enum
{
	SIO2_IMAGE_BILINEAR = 0,
	SIO2_IMAGE_TRILINEAR,
	SIO2_IMAGE_QUADLINEAR
	
} SIO2_IMAGE_FILTERING_TYPE;


typedef enum
{
	SIO2_IMAGE_ISOTROPIC = 0,
	SIO2_IMAGE_ANISOTROPIC_1X,
	SIO2_IMAGE_ANISOTROPIC_2X
	
} SIO2_IMAGE_ANISOTROPIC_TYPE;

static void jliImageGenId( JLIimage	  *_SIO2image,
                           unsigned int  _flags,
                           float		   _filter )
{
	int iformat,
    format;
    
	switch( _SIO2image->bits )
	{
		case 0:
		{ return; }
            
		case 1:
		{
			iformat = GL_LUMINANCE;
			format	= GL_LUMINANCE;
			
			break;
		}
            
		case 2:
		{
			iformat = GL_LUMINANCE_ALPHA;
			format	= GL_LUMINANCE_ALPHA;
			
			break;
		}
            
		case 3:
		{
			iformat = GL_RGB;
			format	= GL_RGB;
			
			break;
		}
            
		case 4:
		{
			iformat = GL_RGBA;
			format	= GL_BGRA;
			
			break;
		}
	}
    
    
	if( !_SIO2image->tid )
	{
		_SIO2image->flags = _flags;
        
		glGenTextures( 1, &_SIO2image->tid );
		
		glBindTexture( GL_TEXTURE_2D, _SIO2image->tid );
        
        //glLabelObjectEXT(GL_BUFFER_OBJECT_EXT, _SIO2image->tid, 0, "BREAKING BAD");//_SIO2image->name.c_str());
        
		if( jliIsStateEnabled( _flags, SIO2_IMAGE_CLAMP ) )
		{
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE );
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE );
		}
		
        
//		if( sio2->afilter != SIO2_IMAGE_ISOTROPIC )
//		{
//			glTexParameterf( GL_TEXTURE_2D,
//                            GL_TEXTURE_MAX_ANISOTROPY_EXT,
//                            ( float )sio2->afilter );
//		}
        
        
		_SIO2image->filter = _filter;
        
//		glTexEnvf( GL_TEXTURE_FILTER_CONTROL_EXT,
//                  GL_TEXTURE_LOD_BIAS_EXT, _SIO2image->filter );
        
        
		if( !jliIsStateEnabled( _flags, SIO2_IMAGE_MIPMAP ) )
		{
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
		}
		else
		{
//			if( sio2->tfilter == SIO2_IMAGE_BILINEAR )
//			{
//				glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST );
//				glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST );
//			}
//			
//			else if( sio2->tfilter == SIO2_IMAGE_TRILINEAR )
//			{
//				glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
//				glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST );
//			}
//			
//			else if( sio2->tfilter == SIO2_IMAGE_QUADLINEAR )
//			{
//				glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
//				glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR );
//			}
//			
//			glTexParameteri( GL_TEXTURE_2D,
//                            GL_GENERATE_MIPMAP,
//                            GL_TRUE );
		}
        
        
		glTexImage2D( GL_TEXTURE_2D,
                     0,
                     iformat,
                     _SIO2image->width,
                     _SIO2image->height,
                     0,
                     format,
                     GL_UNSIGNED_BYTE,
                     _SIO2image->tex );
	}
	else
	{
		glBindTexture( GL_TEXTURE_2D, _SIO2image->tid );
        
		glTexSubImage2D( GL_TEXTURE_2D,
                        0, 0, 0,
                        _SIO2image->width,
                        _SIO2image->height,						 
                        format,
                        GL_UNSIGNED_BYTE,
                        _SIO2image->tex );
	}
	
	//free( _SIO2image->tex );
	//_SIO2image->tex = NULL;
}

static inline void jliImageRGBAtoBGRA( JLIimage *_SIO2image )
{
	unsigned int i = 0,
    s = _SIO2image->width  *
    _SIO2image->height *
    _SIO2image->bits;
	
	unsigned char t;
    
	while( i != s )
	{
		t = _SIO2image->tex[ i ];
		
		_SIO2image->tex[ i ] = _SIO2image->tex[ i + 2 ];
		
		_SIO2image->tex[ i + 2 ] = t;
        
		i += _SIO2image->bits;
	}
}
//
static inline void jliImageFlip( JLIimage *_SIO2image )
{
	unsigned int i    = 0,
    size = _SIO2image->width  *
    _SIO2image->height *
    _SIO2image->bits,
    
    rows = _SIO2image->width * _SIO2image->bits;
    
	unsigned char *buf = new unsigned char[size];
    
	while( i != _SIO2image->height )
	{
		memcpy( buf + ( i * rows ),
               _SIO2image->tex + ( ( ( _SIO2image->height - i ) - 1 ) * rows ),
               rows );
		++i;
	}
	
	memcpy( &_SIO2image->tex[ 0 ],
           &buf[ 0 ], size );
    
	//free( buf );
    delete [] buf;
	buf = NULL;
}
//
static inline unsigned int jliStreamRead( JLIstream   *_SIO2stream,
                                          void		  *_ptr,
                                          unsigned int  _size_t )
{
	if( ( _SIO2stream->pos + _size_t ) > _SIO2stream->size )
	{
        _size_t = _SIO2stream->size - _SIO2stream->pos;
    }
    
	memcpy( _ptr, &_SIO2stream->buf[ _SIO2stream->pos ], _size_t );
	_SIO2stream->pos += _size_t;
    
	return _size_t;
}
//
static inline void jliPngRead( png_structp _png_structp, png_bytep	_png_bytep, png_size_t  _png_size_t )
{
	JLIstream *_SIO2stream = ( JLIstream * ) png_get_io_ptr( _png_structp );
    
	jliStreamRead( _SIO2stream, _png_bytep, _png_size_t );
}

static inline void jliImageLoadPNG( JLIimage  *_SIO2image,
                                    JLIstream *_SIO2stream )
{
	png_structp _png_structp;
	
	png_infop _png_infop;
	
	png_bytep *_png_bytep;
    
	int	i = 0,
    bits,
    type;
    
	_png_structp = png_create_read_struct( PNG_LIBPNG_VER_STRING,
                                          ( png_voidp * )_SIO2stream->fname.c_str(),
                                          NULL, NULL );
    
	_png_infop = png_create_info_struct( _png_structp );
//	
	png_set_read_fn( _png_structp, ( png_voidp * )_SIO2stream, jliPngRead );
//	
	png_read_info (_png_structp, _png_infop);
//    
//    
	bits = png_get_bit_depth ( _png_structp, _png_infop );
	type = png_get_color_type( _png_structp, _png_infop );
//    
//    
	if( type == PNG_COLOR_TYPE_PALETTE )
	{ png_set_palette_to_rgb( _png_structp ); }
//
	if( type == PNG_COLOR_TYPE_GRAY && bits < 8 )
	{ png_set_expand_gray_1_2_4_to_8( _png_structp ); }
//
	if( png_get_valid( _png_structp, _png_infop, PNG_INFO_tRNS ) )
	{ png_set_tRNS_to_alpha (_png_structp); }
//
//	
	if( bits == 16 )
	{ png_set_strip_16( _png_structp ); }
//
	else if( bits < 8 )
    { png_set_packing( _png_structp ); }
//
	png_read_update_info( _png_structp, _png_infop );
//    
	png_get_IHDR( _png_structp,
                 _png_infop,
                 ( png_uint_32 * )( &_SIO2image->width  ),
                 ( png_uint_32 * )( &_SIO2image->height ),
                 &bits,
                 &type,
                 NULL, NULL, NULL );
//
	switch( type )
	{
		case PNG_COLOR_TYPE_GRAY:
		{
			_SIO2image->bits = 1;
			break;
		}
            
		case PNG_COLOR_TYPE_GRAY_ALPHA:
		{
			_SIO2image->bits = 2;
			break;
		}
            
		case PNG_COLOR_TYPE_RGB:
		{
			_SIO2image->bits = 3;
			break;
		}
            
		case PNG_COLOR_TYPE_RGB_ALPHA:
		{
			_SIO2image->bits = 4;
			break;
		}
	}
    
    if(_SIO2image->tex)
        delete [] _SIO2image->tex;
    
    _SIO2image->tex = new unsigned char[_SIO2image->width  *
                                        _SIO2image->height *
                                        _SIO2image->bits];

    _png_bytep = new png_bytep[_SIO2image->height * sizeof( png_bytep )];
//    
	while( i < ( int )_SIO2image->height )
	{
		_png_bytep[ i ] = ( png_bytep )(   _SIO2image->tex    +
                                        ( _SIO2image->height - ( i + 1 ) ) *
                                        _SIO2image->width  *
                                        _SIO2image->bits );
		++i;
	}
//
	png_read_image( _png_structp,
                   _png_bytep );
//    
	png_read_end( _png_structp, NULL );
//    
	png_destroy_read_struct( &_png_structp,
                            &_png_infop, NULL );
	//free( _png_bytep );
    delete [] _png_bytep;
    _png_bytep = NULL;
//	
	jliImageFlip( _SIO2image );
//	
	if( _SIO2image->bits == 4 )
	{ jliImageRGBAtoBGRA( _SIO2image ); }
}










static void *jliStreamReadPtr( JLIstream	*_SIO2stream,
                        unsigned int  _size_t )
{
	void *ptr;
	
	if( ( _SIO2stream->pos + _size_t ) > _SIO2stream->size )
	{ _size_t = _SIO2stream->size - _SIO2stream->pos; }
    
    
	ptr = &_SIO2stream->buf[ _SIO2stream->pos ];
	
	_SIO2stream->pos += _size_t;
    
	return ptr;
}

static void jliImageLoadTGA( JLIimage  *_SIO2image,
                      JLIstream *_SIO2stream )
{
	unsigned int size;
	
	unsigned char *header;
    
	header = ( unsigned char * )jliStreamReadPtr( _SIO2stream, 18 );
    
	_SIO2image->width  = header[ 13 ] * 256 + header[ 12 ];
	_SIO2image->height = header[ 15 ] * 256 + header[ 14 ];
	_SIO2image->bits   = header[ 16 ] >> 3;
	
	size = _SIO2image->width * _SIO2image->height * _SIO2image->bits;
	
	if(_SIO2image->tex)
        delete [] _SIO2image->tex;
    
    _SIO2image->tex = new unsigned char[size];
    
    
	if( header[ 2 ] == 10 || header[ 2 ] == 11 )
	{
		unsigned int i,
        px_count = _SIO2image->width * _SIO2image->height,
        px_index = 0,
        by_index = 0;
		
		unsigned char chunk = 0,
        *bgra;
        
		do
		{
			jliStreamRead( _SIO2stream, &chunk, 1 );
			
			if( chunk < 128 )
			{
				chunk++;
				
				i = 0;
				while( i != chunk )
				{
					jliStreamRead( _SIO2stream, &_SIO2image->tex[ by_index ], _SIO2image->bits );
					by_index += _SIO2image->bits;
					
					++i;
				}
			}
			else
			{
				chunk -= 127;
                
				bgra = ( unsigned char * )jliStreamReadPtr( _SIO2stream, _SIO2image->bits );
				
				i = 0;
				while( i != chunk )
				{
					memcpy( &_SIO2image->tex[ by_index ], &bgra[ 0 ], _SIO2image->bits );
					by_index += _SIO2image->bits;
					
					++i;
				}
			}
			px_index += chunk;
		}
		while( px_index < px_count );
	}
	else
	{ jliStreamRead( _SIO2stream, &_SIO2image->tex[ 0 ], size ); }
	
	
	if( _SIO2image->bits == 3 )
	{
		unsigned int i = 0;
		
		while( i != size )
		{
			unsigned char tmp = _SIO2image->tex[ i ];
			
			_SIO2image->tex[ i     ] = _SIO2image->tex[ i + 2 ];
			_SIO2image->tex[ i + 2 ] = tmp;
			
			i += 3;
		}
	}
	
	if( !header[ 17 ] || header[ 17 ] == 8 )
	{ jliImageFlip( _SIO2image ); }
}


static void jliImageLoadJPEG( JLIimage  *_SIO2image,
                              JLIstream *_SIO2stream )
{
//	unsigned char *row;
//    
//	unsigned int size;
//	
//	struct jpeg_decompress_struct cinfo;
//	struct jpeg_error_mgr jerr;
//	
//	cinfo.err = jpeg_std_error( &jerr );
//	jpeg_create_decompress( &cinfo );
//	
//	jpeg_stdio_src_buf( &cinfo, _SIO2stream->buf,  _SIO2stream->size );
//	jpeg_read_header( &cinfo, 1 );
//	
//	jpeg_start_decompress( &cinfo );
//	
//	_SIO2image->width  = cinfo.image_width;
//	_SIO2image->height = cinfo.image_height;
//	_SIO2image->bits   = cinfo.output_components;
//	
//    size = _SIO2image->width * _SIO2image->height * _SIO2image->bits;
//    
//	_SIO2image->tex = ( unsigned char * ) malloc( size );
//	
//	row = _SIO2image->tex;
//	
//	while( cinfo.output_scanline < _SIO2image->height )
//	{
//		row = _SIO2image->tex   +
//        _SIO2image->bits  *
//        _SIO2image->width *
//        cinfo.output_scanline;
//		
//		jpeg_read_scanlines( &cinfo, &row, 1 );
//	}
//    
//	jpeg_finish_decompress ( &cinfo );
//	jpeg_destroy_decompress( &cinfo );
}

ImageFileEditor::ImageFileEditor() :
m_pImage(new JLIimage()),
m_IsDirty(false)
{
    
}

ImageFileEditor::~ImageFileEditor()
{
    unload();
    
    delete m_pImage;
    m_pImage = NULL;
}

bool ImageFileEditor::load(const std::string &file)
{
    JLIstream *pStream = new JLIstream();
    
    pStream->open(FileLoader::getInstance()->getFilePath(file).c_str());
    
    std::string ext(FileLoader::getInstance()->getFileExtension(file));
    std::transform(ext.begin(), ext.end(),ext.begin(), ::toupper);
    
    if(ext == "TGA")
    {
        jliImageLoadTGA(m_pImage, pStream);
        jliImageGenId(m_pImage, 0, 0.0f);
    }
    else if(ext == "PNG")
    {
        jliImageLoadPNG(m_pImage, pStream);
        jliImageGenId(m_pImage, 0, 0.0f);
    }
    else if(ext == "JPG" || ext == "JPEG")
    {
        jliImageLoadJPEG(m_pImage, pStream);
        jliImageGenId(m_pImage, 0, 0.0f);
    }
    
    delete pStream;
    pStream = NULL;
    
    m_IsDirty = false;    
    return false;
}

bool ImageFileEditor::load(size_t width, size_t height, size_t num_bits, const btVector4 &color)
{
    m_pImage->width = fixDim(width);
    m_pImage->height = fixDim(height);
    m_pImage->bits = fixBits(num_bits);
    
    if(m_pImage->tex)
        delete [] m_pImage->tex;
    
    m_pImage->tex = new unsigned char[m_pImage->width * m_pImage->height * m_pImage->bits];
    
    
    memset(m_pImage->tex, 0, m_pImage->width * m_pImage->height * m_pImage->bits);
    
    jliImageGenId(m_pImage, 0, 0.0f);
    
    return m_pImage->tex != NULL;
}

bool ImageFileEditor::reload()
{
    int format = 0;
    
    switch( m_pImage->bits )
	{
		case 0:
		{ return false; }
            
		case 1:
		{
			format	= GL_LUMINANCE;
			
			break;
		}
            
		case 2:
		{
			format	= GL_LUMINANCE_ALPHA;
			
			break;
		}
            
		case 3:
		{
			format	= GL_RGB;
			
			break;
		}
            
		case 4:
		{
			format	= GL_BGRA;
			
			break;
		}
	}
    
    glBindTexture( GL_TEXTURE_2D, m_pImage->tid );
    
    glTexSubImage2D( GL_TEXTURE_2D,
                    0, 0, 0,
                    m_pImage->width,
                    m_pImage->height,
                    format,
                    GL_UNSIGNED_BYTE,
                    m_pImage->tex );
    
    //glBindTexture(GL_TEXTURE_2D, 0);
    
    m_IsDirty = false;
    
    return true;
}

bool ImageFileEditor::isDirty()const
{
    return m_IsDirty;
}

GLuint ImageFileEditor::name()const
{
    return m_pImage->tid;
}
bool ImageFileEditor::unload()
{
    glDeleteTextures(1, &m_pImage->tid);
    
    if (m_pImage->tex)
        delete [] m_pImage->tex;
    m_pImage->tex = NULL;
}

btVector4 ImageFileEditor::getPixel(size_t x, size_t y)const
{   
    int x_indice = x * m_pImage->bits;
    int y_indice = y * m_pImage->bits * m_pImage->width;
    float red = 0.0f;
    float green = 0.0f;
    float blue = 0.0f;
    float alpha = 0.0f;
    
    switch (m_pImage->bits)
    {
        case 4:
            alpha = m_pImage->tex[x_indice + y_indice + 3] / 255.0f;
        case 3:
            blue = m_pImage->tex[x_indice + y_indice + 2] / 255.0f;
        case 2:
            green = m_pImage->tex[x_indice + y_indice + 1] / 255.0f;
        case 1:
            red = m_pImage->tex[x_indice + y_indice + 0] / 255.0f;
    }
    
    return btVector4(red, green, blue, alpha);
}

void ImageFileEditor::setPixel(size_t x, size_t y, const btVector4 &color)
{
    int x_indice = x * m_pImage->bits;
    int y_indice = y * m_pImage->bits * m_pImage->width;
    
    switch (m_pImage->bits)
    {
        case 4:
            m_pImage->tex[x_indice + y_indice + 3] = (color.w() * 255.0f);
        case 3:
            m_pImage->tex[x_indice + y_indice + 2] = (color.z() * 255.0f);
        case 2:
            m_pImage->tex[x_indice + y_indice + 1] = (color.y() * 255.0f);
        case 1:
            m_pImage->tex[x_indice + y_indice + 0] = (color.x() * 255.0f);
    }
    m_IsDirty = true;
}

inline void ImageFileEditor::getPixel(size_t x, size_t y, unsigned char *pixel)const
{
    int x_indice = x * m_pImage->bits;
    int y_indice = y * m_pImage->bits * m_pImage->width;
    memcpy(pixel, &m_pImage->tex[x_indice + y_indice + 0], sizeof(unsigned char) * m_pImage->bits);
}

inline void ImageFileEditor::setPixel(size_t x, size_t y, const unsigned char *pixel)
{
    int x_indice = x * m_pImage->bits;
    int y_indice = y * m_pImage->bits * m_pImage->width;
    memcpy(&m_pImage->tex[x_indice + y_indice + 0], pixel, sizeof(unsigned char) * m_pImage->bits);
}

size_t ImageFileEditor::getWidth()const
{
    return m_pImage->width;
}

size_t ImageFileEditor::getHeight()const
{
    return m_pImage->height;
}

size_t ImageFileEditor::getNumBits()const
{
    return m_pImage->bits;
}
void ImageFileEditor::draw(size_t x_offset, size_t y_offset, ImageFileEditor &canvas)const
{
    for (size_t row = 0; row < m_pImage->height; row++)
    {
        canvas.setPixelRow(x_offset, m_pImage, row, row + y_offset);
    }
}

void ImageFileEditor::drawLine(const btVector2 &from, const btVector2 &to, const btVector4 &color)
//static void line(int x,int y,int x2, int y2, int color)
{
    
    //http://tech-algorithm.com/articles/drawing-line-using-bresenham-algorithm/
    
    int x = from.x();
    int y = from.y();
    int x2 = to.x();
    int y2 = to.y();
    
    
    int w = x2 - x ;
    int h = y2 - y ;
    int dx1 = 0, dy1 = 0, dx2 = 0, dy2 = 0 ;
    if (w<0) dx1 = -1 ; else if (w>0) dx1 = 1 ;
    if (h<0) dy1 = -1 ; else if (h>0) dy1 = 1 ;
    if (w<0) dx2 = -1 ; else if (w>0) dx2 = 1 ;
    int longest = fabs(w) ;
    int shortest = fabs(h) ;
    
    if (!(longest>shortest))
    {
        longest = fabs(h) ;
        shortest = fabs(w) ;
        if (h<0) dy2 = -1 ; else if (h>0) dy2 = 1 ;
        dx2 = 0 ;
    }
    int numerator = longest >> 1 ;
    
    for (int i=0;i<=longest;i++)
    {
        setPixel(x, y, color);
        numerator += shortest ;
        if (!(numerator<longest))
        {
            numerator -= longest ;
            x += dx1 ;
            y += dy1 ;
        }
        else
        {
            x += dx2 ;
            y += dy2 ;
        }
    }
}

//void ImageFileEditor::drawLine(const btVector2 &from, const btVector2 &to, const btVector4 &color)
//{
//    int x,y,dx,dy,dx1,dy1,px,py,xe,ye,i;
//    dx=to.x()-from.x();
//    dy=to.y()-from.y();
//    dx1=fabs(dx);
//    dy1=fabs(dy);
//    px=2*dy1-dx1;
//    py=2*dx1-dy1;
//    if(dy1<=dx1)
//    {
//        if(dx>=0)
//        {
//            x=from.x();
//            y=from.y();
//            xe=to.x();
//        }
//        else
//        {
//            x=to.x();
//            y=to.y();
//            xe=from.x();
//        }
//        setPixel(x, y, color);
//        //putpixel(x,y,c);
//        for(i=0;x<xe;i++)
//        {
//            x=x+1;
//            if(px<0)
//            {
//                px=px+2*dy1;
//            }
//            else
//            {
//                if((dx<0 && dy<0) || (dx>0 && dy>0))
//                {
//                    y=y+1;
//                }
//                else
//                {
//                    y=y-1;
//                }
//                px=px+2*(dy1-dx1);
//            }
//            //delay(0);
//            setPixel(x, y, color);
//            //putpixel(x,y,c);
//        }
//    }
//    else
//    {
//        if(dy>=0)
//        {
//            x=from.x();
//            y=from.y();
//            ye=to.y();
//        }
//        else
//        {
//            x=to.x();
//            y=to.y();
//            ye=from.y();
//        }
//        //putpixel(x,y,c);
//        setPixel(x, y, color);
//        for(i=0;y<ye;i++)
//        {
//            y=y+1;
//            if(py<=0)
//            {
//                py=py+2*dx1;
//            }
//            else
//            {
//                if((dx<0 && dy<0) || (dx>0 && dy>0))
//                {
//                    x=x+1;
//                }
//                else
//                {
//                    x=x-1;
//                }
//                py=py+2*(dx1-dy1);
//            }
//            //delay(0);
//            //putpixel(x,y,c);
//            setPixel(x, y, color);
//        }
//    }
//}

void ImageFileEditor::blur()
{
    jliImageBlur(m_pImage);
}

inline size_t ImageFileEditor::fixDim(const size_t dim)const
{
    for(int shift = 0; shift < 12; shift++)
    {
        if((1 << shift) > dim)
            return 1 << (shift);
    }
    return 1 << 11;
    
}
inline size_t ImageFileEditor::fixBits(const size_t bits)const
{
    if(bits > 4)
        return 4;
    return bits;
}

void ImageFileEditor::setPixelRow(size_t x_offset,
                                  JLIimage *jliFromImage,
                                  size_t from_row,
                                  size_t to_row)
{
    btAssert(jliFromImage->bits == m_pImage->bits);
    
    int x_from = 0;
    int y_from = from_row;
    int x_indice_from = x_from * jliFromImage->bits;
    int y_indice_from = y_from * jliFromImage->bits * jliFromImage->width;
    
    int x_to = x_offset;
    int y_to = to_row;
    int x_indice_to = x_to * m_pImage->bits;
    int y_indice_to = y_to * m_pImage->bits * m_pImage->width;
    
    int width = jliFromImage->width;
    if(width > m_pImage->width)
        width = m_pImage->width;
    
    memcpy(&m_pImage->tex[x_indice_to + y_indice_to],
           &jliFromImage->tex[x_indice_from + y_indice_from],
           sizeof(unsigned char) * m_pImage->bits * width);
}
