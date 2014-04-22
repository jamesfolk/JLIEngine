//
//  ImageFileEditor.h
//  BaseProject
//
//  Created by library on 10/8/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__ImageFileEditor__
#define __BaseProject__ImageFileEditor__


#include <string>
#include "ZipFileResourceLoader.h"

class btVector4;

class ImageFileEditor
{
public:
    ImageFileEditor();
    virtual ~ImageFileEditor();
    
    virtual bool load(const std::string &file);
    virtual bool load(size_t width, size_t height, size_t num_bits, const btVector4 &color = btVector4(0, 0, 0, 0));
    virtual bool reload();
    virtual bool unload();
    
    virtual GLuint name()const;
    virtual bool isDirty()const;
    
    virtual btVector4 getPixel(size_t x, size_t y)const;
    virtual void setPixel(size_t x, size_t y, const btVector4 &color);
    virtual void getPixel(size_t x, size_t y, unsigned char *pixel)const;
    virtual void setPixel(size_t x, size_t y, const unsigned char *pixel);
    
    virtual size_t getWidth()const;
    virtual size_t getHeight()const;
    virtual size_t getNumBits()const;
    
    virtual void draw(size_t x, size_t y, ImageFileEditor &canvas)const;
    
    virtual void drawLine(const btVector2 &from, const btVector2 &to, const btVector4 &color);
    
    
    void blur();
private:
    size_t fixDim(const size_t dim)const;
    size_t fixBits(const size_t bits)const;
    
    virtual void setPixelRow(size_t x, JLIimage *jliFromImage, size_t from_row, size_t to_row);
    
    JLIimage *m_pImage;
    bool m_IsDirty;
};



#endif /* defined(__BaseProject__ImageFileEditor__) */
