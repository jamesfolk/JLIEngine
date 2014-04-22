import cairo
import math
import os
import sys
import string

from  os import system
from platform import uname
from PIL import Image

global cr

basefilepath = "../assets/strings/"
imagefilepath = "../assets/images/"
enumFilePath = "../src/view/text/LocalizedTextViewObjectTypes"
font_properties = []
languages = []
file_localization_filepaths = []
image_localization_filepaths = []



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

def writeLocalizedData(image_localization_filepath,
                       file_localization_filepath,
                       fontname,
                       fontsize,
                       textureWidth,
                       textureHeight):
    dataFileData = ""
    font_prefix = "%s_%d" % (fontname, fontsize)
    
    image_file_suffix = "_%d_Localized.png"
    image_short_filename = font_prefix + image_file_suffix
    image_filename = image_localization_filepath + image_short_filename
    
    image_file_suffix_compressed = "_%d_Localized.pvr"
    image_short_filename_compressed = font_prefix + image_file_suffix_compressed
    image_filename_compressed = image_localization_filepath + image_short_filename_compressed
    
    
    
    localizable_filename = file_localization_filepath + "Localizable.strings"
    
    
    
    ins = open( localizable_filename, "r" )
    array = []
    for line in ins:
        tokens = line.split('=')
        if(len(tokens) == 2):
            key = tokens[0].split('"')[1].strip()
            value = tokens[1].split('"')[1].strip()
            
            array.append( [key, value] )
        #end if
    #end for
    
    current_image_number = 0
    
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
    
    
    
    
    maxy = 0
    gutter = 6
    
    x = gutter
    y = gutter
    for str in array:
        str_val = str[1]
        str_key = str[0]
        
        x_bearing, y_bearing, width, height, x_advance, y_advance = cr.text_extents(str_val)[:6]
        
        if (x + width) > textureWidth :
            x = gutter
            y = maxy + gutter
        #end if
        
        if (y + height) >= textureHeight :
            
            surface.write_to_png(image_filename_gen)
            print("written:", image_filename_gen)
            showImage(image_filename_gen)
            
            system_command = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/texturetool -m -f PVR -e PVRTC \"" + image_filename_gen + "\" -o \"" + image_filename_gen_compressed + "\"\n"#rm \"" + image_filename_gen + "\"\n"
            
            os.system(system_command)
            print("compressed:", image_filename_gen, " to ", image_filename_gen_compressed)
            
            
            
            current_image_number += 1
            
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
            
            
            x = gutter
            y = gutter
        #end if
        
        cr.move_to(x - x_bearing, y - y_bearing)
        cr.show_text(str_val)
        
        maxy = max(maxy, y + height)
        
        _temp = "%s,%s,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d;" % (str_key, image_short_filename_gen_compressed,
                                                          textureWidth, textureHeight,
                                                          x - (gutter/2), y - (gutter/2),
                                                          x_bearing, y_bearing,
                                                          width + ((gutter/2) * 2), height + ((gutter/2) * 2),
                                                          x_advance, y_advance)
        
        dataFileData += _temp
        
        x = x + width + gutter
    #end for
    
    surface.write_to_png(image_filename_gen)
    print("written:", image_filename_gen)
    showImage(image_filename_gen)
    
    system_command = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/texturetool -m -f PVR -e PVRTC \"" + image_filename_gen + "\" -o \"" + image_filename_gen_compressed + "\"\n"#rm \"" + image_filename_gen + "\"\n"
    
    os.system(system_command)
    print("compressed:", image_filename_gen, " to ", image_filename_gen_compressed)
    
    
    return dataFileData

#end def

#sys.argv[1] = comma delimeted [font_name, font_size, texture_width, texture_height]
with open(sys.argv[1]) as f:
    content = f.readlines()
lines = content[0].split('\r')

for index in range(len(lines)):
    if(index > 0):
        line = lines[index]
        font_property = []
        tokens = line.split(',')
        
        for token in tokens:
            font_property.append(string.strip(token))
        #end for

        font_properties.append(font_property)
    #end if
#end for

print(repr(lines))
print(repr(font_properties))

font_dict = dict()
texture_dim_dict = dict()
for font_property in font_properties:
    
    font_name = font_property[0]
    font_size = font_property[1]
    
    if not font_name in font_dict:
        font_dict[font_name] = []
    #end if
    
    font_dict[font_name].append(font_size)

    texture_width = font_property[2]
    texture_height = font_property[3]

    font_name_size_key = font_name + ", " + font_size

    if not font_name_size_key in texture_dim_dict:
        texture_dim_dict[font_name_size_key] = []
    #end if

    texture_dim_dict[font_name_size_key].append(texture_width)
    texture_dim_dict[font_name_size_key].append(texture_height)
#end for

#sys.argv[2] = comma delimeted [lang1, lang2, ...]
ins = open( sys.argv[2], "r" )
for line in ins:
    tokens = line.split(',')
    
    for token in tokens:
        languages.append(string.strip(token))
    #end for
#end for

for lang in languages:
    file_localization_filepaths.append(basefilepath + lang + "/")
    image_localization_filepaths.append(imagefilepath + lang + "/")
#end for

for index in range(len(languages)):
    for font_name in font_dict.keys():
        result_localized_filename = file_localization_filepaths[index] + font_name + "_Localized.strings"
        dataFile = open(result_localized_filename, 'wb')
        
        for font_size in font_dict[font_name]:
            font_name_size_key = font_name + ", " + font_size
            
            texture_width = int(texture_dim_dict[font_name_size_key][0])
            texture_height = int(texture_dim_dict[font_name_size_key][1])

            dataFileData = "\"%s_%d\" = \"" % (font_name, int(font_size))
            
            dataFileData += writeLocalizedData(image_localization_filepaths[index],
                                               file_localization_filepaths[index],
                                               font_name,
                                               int(font_size),
                                               int(texture_width),
                                               int(texture_height))
            
            dataFileData += "\";\n\n"
            writeString(dataFile, dataFileData)
        
        #end for

        print("written:", dataFile)
        dataFile.flush()
        dataFile.close()
    #end for
#end for

enumFile_h = open(enumFilePath + ".h", 'wb')
enumFile_mm = open(enumFilePath + ".mm", 'wb')

enumData_h = "\n\
#ifndef GameAsteroids_LocalizedTextViewObjectTypes_h\n\
#define GameAsteroids_LocalizedTextViewObjectTypes_h\n\
\t#include <string>\n\
enum LocalizedTextViewObjectType\n\
{\n\
LocalizedTextViewObjectType_NONE,\n\
"

#enumLine = ""
#for font_name in fontnames:
#    for font_size in fontsizes:
#        enumLine = "%s" % (font_name)
#        enumLine = ''.join(e for e in enumLine if e.isalnum())
#        
#        enumLine = ("LocalizedTextViewObjectType_%s_%dpt,\n\t" % (enumLine, font_size))
#        
#        enumData_h += enumLine
#    #end for
##end for

enumLine = ""
for font_name in font_dict.keys():
    for font_size in font_dict[font_name]:
        enumLine = "%s" % (font_name)
        enumLine = ''.join(e for e in enumLine if e.isalnum())
        
        enumLine = ("LocalizedTextViewObjectType_%s_%dpt,\n\t" % (enumLine, int(font_size)))
        
        enumData_h += enumLine
    #end for
#end for

enumData_h += "LocalizedTextViewObjectType_MAX\n\
};\n\
\n\
\n\
struct LocalizedTextViewObjectStruct\n\
{\n\
LocalizedTextViewObjectType type;\n\
std::string font_name;\n\
int font_size;\n\
};\n\
\n\
extern LocalizedTextViewObjectStruct g_LocalizedTextViewObjectStructData[];\
\n\
\n\
#endif\n\
"

writeString(enumFile_h, enumData_h)
print("written:", enumFile_h)
enumFile_h.flush()
enumFile_h.close()







enumData_mm = "\
#include \"LocalizedTextViewObjectTypes.h\"\n\
LocalizedTextViewObjectStruct g_LocalizedTextViewObjectStructData[] =\n\
{\n\
{LocalizedTextViewObjectType_NONE, \"Invalid\", -1},\n\
"

#font_name_fixed = ""
#for font_name in fontnames:
#    for font_size in fontsizes:
#        font_name_fixed = ''.join(e for e in font_name if e.isalnum())
#        
#        enumValue = "LocalizedTextViewObjectType_%s_%dpt" % (font_name_fixed, font_size)
#        
#        enumData_mm += "   {%s, \"%s\", %d},\n" % (enumValue, font_name, font_size)
#    #end for
##end for

font_name_fixed = ""
for font_name in font_dict.keys():
    for font_size in font_dict[font_name]:
        font_name_fixed = ''.join(e for e in font_name if e.isalnum())
        
        enumValue = "LocalizedTextViewObjectType_%s_%dpt" % (font_name_fixed, int(font_size))
        
        enumData_mm += "   {%s, \"%s\", %d},\n" % (enumValue, font_name, int(font_size))
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

