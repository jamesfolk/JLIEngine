import cairo
import math
import os
import sys
import string

from  os import system
from platform import uname
from PIL import Image

global cr


#sys.argv[0]
#sys.argv[1] = comma delimeted font name list (file)
#sys.argv[2] = comma delimeted font size list (file)
#sys.argv[3] = comma delimeted language list (file)




fontnames = []
ins = open( sys.argv[1], "r" )
array = []
for line in ins:
    tokens = line.split(',')
    
    for token in tokens:
        fontnames.append(string.strip(token))
    #end for
#end for

fontsizes = []
ins = open( sys.argv[2], "r" )
array = []
for line in ins:
    tokens = line.split(',')
    
    for token in tokens:
        fontsizes.append(int(token))
    #end for
#end for



print("font names" + repr(fontnames))
print("font sizes" + repr(fontsizes))



basefilepath = "../assets/strings/"
imagefilepath = "../assets/images/"
enumFilePath = "../src/view/text/TextViewObjectTypes"

textureWidth = 2048
textureHeight = 2048

def writeString(file, string):
    file.write(bytes(string))
#end def

def showImage(image):
    return;
    if uname()[0] == 'Linux':
        system("gnome-open " + image)
    else:
        system("open '" + image + "'")
    #end if
#end def


def writeData(image_localization_filepath, fontname, fontsize):
    dataFileData = ""
    font_prefix = "%s_%d" % (fontname, fontsize)
    
    image_file_suffix = "_%d.png"
    image_short_filename = font_prefix + image_file_suffix
    image_filename = image_localization_filepath + image_short_filename
    
    image_file_suffix_compressed = "_%d.pvr"
    image_short_filename_compressed = font_prefix + image_file_suffix_compressed
    image_filename_compressed = image_localization_filepath + image_short_filename_compressed
    
    
    
    #localizable_filename = file_localization_filepath + "Localizable.strings"
    #result_localized_filename = file_localization_filepath + font_prefix + "GeneratedText.strings"
    
    
    
    
#    ins = open( localizable_filename, "r" )
#    array = []
#    for line in ins:
#        tokens = line.split('=')
#        if(len(tokens) == 2):
#            key = tokens[0].split('"')[1].strip()
#            value = tokens[1].split('"')[1].strip()
#            
#            array.append( [key, value] )
#    #end if
#    #end for
    
    array = []
    #32 to 126
    for index in range(0, 128):
        str = chr(index)
        array.append(str)
    #end for
    
    #dataFile = open(result_localized_filename, 'wb')
    #dataFileData = ""
    
    current_image_number = 0
    
    image_short_filename_gen = image_short_filename % (current_image_number)
    image_short_filename_gen_compressed = image_short_filename_compressed % (current_image_number)
    
    image_filename_gen = image_filename % (current_image_number)
    image_filename_gen_compressed = image_filename_compressed % (current_image_number)
    
    imagesize = (textureWidth,textureHeight)
    viewport = (textureWidth,textureHeight)
    surface = cairo.ImageSurface(cairo.FORMAT_ARGB32, *imagesize)
    scale = [x/y for x, y in zip(imagesize, viewport)]
    cr = cairo.Context(surface)
    cr.scale(*scale)
    
    cr.select_font_face(fontname, cairo.FONT_SLANT_NORMAL, cairo.FONT_WEIGHT_NORMAL)
    cr.set_font_size(fontsize)
    cr.set_source_rgb(1,1,1)
    
    
    
    x = 0
    y = 0
    maxy = 0
    for str in array:
        
        x_bearing, y_bearing, width, height, x_advance, y_advance = cr.text_extents(str)[:6]
        
        if (x + width) > textureWidth :
            x = 0
            y = maxy
        #end if
        
        if (y + height) >= textureHeight :
            
            surface.write_to_png(image_filename_gen)
            print("written:", image_filename_gen)
            #alphaChannel = Image.open(image_filename_gen).split()[3]
            #alphaChannel.save(image_filename_gen)
            showImage(image_filename_gen)
            
            system_command = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/texturetool -m -f PVR -e PVRTC \"" + image_filename_gen + "\" -o \"" + image_filename_gen_compressed + "\"\nrm \"" + image_filename_gen + "\"\n"
            
            os.system(system_command)
            
            
            
            
            current_image_number += 1
            
            image_short_filename_gen = image_short_filename % (current_image_number)
            image_short_filename_gen_compressed = image_short_filename_compressed % (current_image_number)
            
            image_filename_gen = image_filename % (current_image_number)
            image_filename_gen_compressed = image_filename_compressed % (current_image_number)
            
            
            
            
            imagesize = (textureWidth,textureHeight)
            viewport = (textureWidth,textureHeight)
            surface = cairo.ImageSurface(cairo.FORMAT_ARGB32, *imagesize)
            scale = [x/y for x, y in zip(imagesize, viewport)]
            cr = cairo.Context(surface)
            cr.scale(*scale)
            
            cr.select_font_face(fontname, cairo.FONT_SLANT_NORMAL, cairo.FONT_WEIGHT_NORMAL)
            cr.set_font_size(fontsize)
            cr.set_source_rgb(1,1,1)
            
            
            x = 0
            y = 0
        #end if
        
        cr.move_to(x - x_bearing, y - y_bearing)
        cr.show_text(str)
        
        maxy = max(maxy, y + height)
        
        _temp = "%d,%s,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d;" % (ord(str),
                                                          image_short_filename_gen_compressed,
                                                          textureWidth, textureHeight,
                                                          x, y,
                                                          x_bearing, y_bearing,
                                                          width, height,
                                                          x_advance, y_advance)
        
        dataFileData += _temp

        x, y = x + width, y
    #end for
    
    surface.write_to_png(image_filename_gen)
    print("written:", image_filename_gen)
    #alphaChannel = Image.open(image_filename_gen).split()[3]
    #alphaChannel.save(image_filename_gen)
    showImage(image_filename_gen)
    
    system_command = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/texturetool -m -f PVR -e PVRTC \"" + image_filename_gen + "\" -o \"" + image_filename_gen_compressed + "\"\nrm \"" + image_filename_gen + "\"\n"
    
    os.system(system_command)
    
    
    
#    writeString(dataFile, dataFileData)
#    print("written:", result_localized_filename)
#    dataFile.flush()
#    dataFile.close()

    return dataFileData

#end def










for font_name in fontnames:
    result_localized_filename = basefilepath + font_name + ".strings"
    dataFile = open(result_localized_filename, 'wb')
    
    for font_size in fontsizes:
        dataFileData = "\"%s_%d\" = \"" % (font_name, font_size)
        dataFileData += writeData(imagefilepath, font_name, font_size)

        dataFileData += "\";\n\n"
        writeString(dataFile, dataFileData)

    #end for

    print("written:", result_localized_filename)
    dataFile.flush()
    dataFile.close()

#end for

#enumFilePath = "../ObjectView/Derived/Text/TextViewObjectTypes.h"
enumFile_h = open(enumFilePath + ".h", 'wb')
enumFile_mm = open(enumFilePath + ".mm", 'wb')

enumData_h = "\n\
#ifndef GameAsteroids_TextViewObjectTypes_h\n\
#define GameAsteroids_TextViewObjectTypes_h\n\
\t#include <string>\n\
enum TextViewObjectType\n\
{\n\
TextViewObjectType_NONE,\n\
"

enumLine = ""
for font_name in fontnames:
    for font_size in fontsizes:
        enumLine = "%s" % (font_name)
        enumLine = ''.join(e for e in enumLine if e.isalnum())
        
        enumLine = ("TextViewObjectType_%s_%dpt,\n\t" % (enumLine, font_size))
        
        enumData_h += enumLine
    #end for
#end for


enumData_h += "TextViewObjectType_MAX\n\
};\n\
\n\
\n\
struct TextViewObjectStruct\n\
{\n\
TextViewObjectType type;\n\
std::string font_name;\n\
int font_size;\n\
};\n\
\n\
extern TextViewObjectStruct g_TextViewObjectStructData[];\
\n\
\n\
#endif\n\
"

writeString(enumFile_h, enumData_h)
print("written:", enumFile_h)
enumFile_h.flush()
enumFile_h.close()







enumData_mm = "\
#include \"TextViewObjectTypes.h\"\n\
TextViewObjectStruct g_TextViewObjectStructData[] =\n\
{\n\
{TextViewObjectType_NONE, \"Invalid\", -1},\n\
"

font_name_fixed = ""
for font_name in fontnames:
    for font_size in fontsizes:
        font_name_fixed = ''.join(e for e in font_name if e.isalnum())
        
        enumValue = "TextViewObjectType_%s_%dpt" % (font_name_fixed, font_size)
        
        enumData_mm += "   {%s, \"%s\", %d},\n" % (enumValue, font_name, font_size)
#end for
#end for

enumData_mm += "};\n\
\n\
\n\
"

writeString(enumFile_mm, enumData_mm)
print("written:", enumFile_mm)
enumFile_mm.flush()
enumFile_mm.close()
