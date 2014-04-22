//
//  ZipFileResourceLoader.mm
//  BaseProject
//
//  Created by library on 8/26/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "ZipFileResourceLoader.h"
#include "VertexAttributesInclude.h"



const char *const JLI_RESOURCE_PATH[JLIResourceTypes_MAX] = 
{
    "meshs/",
    "curves/",
    "cameras/",
	"lamps/",
    "materials/",
    "images/"
};


ZipFileResourceLoader::ZipFileResourceLoader() :
m_uf(NULL),
m_extractIndex(0)
{
}

ZipFileResourceLoader::~ZipFileResourceLoader()
{
    destroy();
}

bool ZipFileResourceLoader::open(const std::string zipfile)
{
    close();
    
    
    size_t marker = zipfile.find_last_of(".");
    NSString *fileName = [NSString stringWithUTF8String:zipfile.substr(0, marker).c_str()];
    NSString *extension = [NSString stringWithUTF8String:zipfile.substr(marker + 1).c_str()];
    
    //return [[NSBundle mainBundle] pathForResource:fileName ofType:extension];
    
    const char *stringAsChar = [[[NSBundle mainBundle] pathForResource:fileName ofType:extension] cStringUsingEncoding:[NSString defaultCStringEncoding]];
    
    //getBundledFile(zipfile);
    
    m_uf = unzOpen( stringAsChar );
    
    if(m_uf)
    {
        if(UNZ_OK != unzGetGlobalInfo( m_uf, &m_gi ))
            return false;
        
        if(UNZ_OK != unzGoToFirstFile( m_uf ))
            return false;
        
        return true;
    }
    
    return false;
}
bool ZipFileResourceLoader::close()
{
    if(m_uf)
    {
        unzClose(m_uf);
        m_uf = NULL;
        return true;
    }
    m_extractIndex = 0;
    
    return false;
}

int ZipFileResourceLoader::extract()
{
    if(m_uf)
    {
        const char *_password = NULL;
        
        
        
        unz_file_info fi;
        
        const size_t max_char = 64;
        
        char name[ max_char ] = {""};
        
        if(UNZ_OK == unzGetCurrentFileInfo( m_uf, &fi, name, max_char, NULL, 0, NULL, 0 ))
        {
            m_extractIndex++;
        }
        
        if( !fi.uncompressed_size )
        {
            unzGoToNextFile( m_uf );
            return m_extractIndex;
        }
        
        m_extractObjectName = "";
        if( unzOpenCurrentFilePassword( m_uf, _password ) == UNZ_OK )
        {
            JLIstream *pJLIstream = new JLIstream(fi.uncompressed_size, name);
            
            while( unzReadCurrentFile( m_uf, pJLIstream->buf, fi.uncompressed_size ) > 0 )
            {}
            
            unzCloseCurrentFile( m_uf );
            
            if(!parseStream(pJLIstream))
            {
                printf("Unable to parse %s\n", pJLIstream->fname.c_str());
            }
            
            delete pJLIstream;
        }
        
        unzGoToNextFile( m_uf );
        
        
    }
    
    return m_extractIndex;
}

void ZipFileResourceLoader::destroy()
{
    close();
    
    
    JLIstream *jlistream = NULL;
    for(int i = 0; i < m_Images.size(); i++)
    {
        jlistream = *m_Images.getAtIndex(i);
        delete jlistream;
        jlistream = NULL;
    }
    m_Images.clear();
    
    BaseMeshObject *object = NULL;
    for(int i = 0; i < m_Meshes.size(); i++)
    {
        object = *m_Meshes.getAtIndex(i);
        delete object;
        object = NULL;
    }
    m_Meshes.clear();
    
    CurveObject *curve = NULL;
    for(int i = 0; i < m_Curves.size(); i++)
    {
        curve = *m_Curves.getAtIndex(i);
        delete curve;
        curve = NULL;
    }
    m_Curves.clear();

    
    char *key = NULL;
    for (int i = 0; i < m_HashKeys.size(); i++)
    {
        key = m_HashKeys[i];
        delete [] key;
    }
    m_HashKeys.clear();
    
    m_extractIndex = 0;
}

bool ZipFileResourceLoader::finished()
{
    return m_extractIndex >= numObjects();
}

int ZipFileResourceLoader::currentObjectIndex()const
{
    return m_extractIndex;
}

int ZipFileResourceLoader::numObjects()const
{
    if(m_uf)
        return m_gi.number_entry;
    return 0;
}





static inline unsigned int jliStringLen( const char *_str )
{
	unsigned int i = 0;
	
	while( _str[ i ] )
	{ ++i; }
	
	return i;
}

static inline const char *jliStringTok( const char *_str1, const char *_str2 )
{
	unsigned int s = jliStringLen( _str2 );
    
	while( *_str1 )
	{
		if( *_str1 == *_str2 )
		{
			if( s == 1 )
			{ return _str1; }
			
			if( !memcmp( _str1, _str2, s ) )
			{ return _str1; }
		}
		
		++_str1;
	}
    
	return NULL;
}

bool ZipFileResourceLoader::parseStream(JLIstream *stream)
{
    unsigned int i = 0;
    unsigned int length = stream->fname.length() + 1;
	char *filename = new char[length];
    char *asset_name = new char[length];
    bool parsed = false;
    
    
    std::strcpy(filename, stream->fname.c_str());
    
	while( i != JLIResourceTypes_MAX )
	{
        if( jliStringTok(filename, JLI_RESOURCE_PATH[ i ]) )
		{ break; }
		
		++i;
	}
    
    
    char *temp = std::strtok(filename, "/");
    temp = std::strtok(NULL, "/");
    
    switch(i)
    {
        case JLIResourceTypes_MESHS:
        {
            stream->cur = stream->buf;
            
            char *byte = std::strtok((char*)stream->cur, ",");
            _Bool use_vertex_normals = (_Bool)atoi(byte);
            
            byte = std::strtok(NULL, ",");
            _Bool use_vertex_colors = (_Bool)atoi(byte);
            
            _Bool use_vertex_uv[32];
            for (int i = 0; i < 32; i++)
            {
                byte = std::strtok(NULL, ",");
                use_vertex_uv[i] = (_Bool)atoi(byte);
            }
            
            if(use_vertex_normals &&
                use_vertex_colors &&
                use_vertex_uv[0])
            {
                strcpy(asset_name, temp);
                
                if(!m_Meshes.find(btHashString(asset_name)))
                {
                    m_Meshes.insert(btHashString(asset_name),
                                    new MeshObject<VertexAttributes_Vertex_Normal_Color_UVLayer1>(use_vertex_normals,
                                                                                                                          use_vertex_colors,
                                                                                                                          use_vertex_uv,
                                                                                                                          (char*)stream->cur));
                    stream->cur = stream->buf;
                    
                    parsed = (*m_Meshes.find(btHashString(asset_name)) != NULL);
                }
            }
            else
            {
                btAssert(0 && "must add a new vertex attribute");
            }            
        }
            break;
        case JLIResourceTypes_CURVES:
        {
            strcpy(asset_name, temp);
            
            if(!m_Curves.find(btHashString(asset_name)))
            {
                stream->cur = stream->buf;
                
                m_Curves.insert(btHashString(asset_name),
                                new CurveObject((char*)stream->cur));
                
                stream->cur = stream->buf;
                
                parsed = (*m_Curves.find(btHashString(asset_name)) != NULL);
            }
        }
            break;
        case JLIResourceTypes_CAMERAS:
            break;
        case JLIResourceTypes_LAMPS:
            break;
        case JLIResourceTypes_MATERIALS:
            break;
        case JLIResourceTypes_IMAGES:
        {
            char *asset_name_short = temp;
            do
            {
                asset_name_short++;
            }
            while (*asset_name_short != '.' &&
                   *asset_name_short != '\0');
            *asset_name_short = 0;
            
            strcpy(asset_name, temp);
            
            if(!m_Images.find(btHashString(asset_name)))
            {
                stream->cur = stream->buf;
                
                m_Images.insert(btHashString(asset_name), new JLIstream(*stream));
                
                stream->cur = stream->buf;
                
                parsed = (*m_Images.find(btHashString(asset_name)) != NULL);
            }
        }
            break;
    }
    
    
    delete [] filename;
    filename = NULL;
    
    if(parsed)
    {
        m_HashKeys.push_back(asset_name);
        m_extractObjectName = asset_name;
    }
    else
    {
        m_extractObjectName = "INVALID PARSE or duplicate object";
    }
    
    return parsed;
}

size_t ZipFileResourceLoader::getNumImages()const
{
    return m_Images.size();
}

size_t ZipFileResourceLoader::getNumMeshes()const
{
    return m_Meshes.size();
}

size_t ZipFileResourceLoader::getNumCurves()const
{
    return m_Curves.size();
}

JLIstream *ZipFileResourceLoader::getImageData(const size_t index)const
{
    if(index < getNumImages())
        return *m_Images.getAtIndex(index);
    return NULL;
}

JLIstream *ZipFileResourceLoader::getImageData(const std::string &filename)const
{
    return *m_Images.find(btHashString(filename.c_str()));
}

const BaseMeshObject *ZipFileResourceLoader::getMeshObject(const size_t index)const
{
    if(index < getNumMeshes())
        return *m_Meshes.getAtIndex(index);
    return NULL;
}

const BaseMeshObject *ZipFileResourceLoader::getMeshObject(const std::string &objectname)const
{
    BaseMeshObject *mo = *m_Meshes.find(btHashString(objectname.c_str()));
    return mo;
//    return *m_Meshes.find(btHashString(objectname.c_str()));
}

const CurveObject *ZipFileResourceLoader::getCurveVertices(const size_t index)const
{
    if(index < getNumCurves())
        return *m_Curves.getAtIndex(index);
    return NULL;
}

const CurveObject *ZipFileResourceLoader::getCurveVertices(const std::string &objectname)const
{
    return *m_Curves.find(btHashString(objectname.c_str()));
}
