
#ifndef GameAsteroids_TextViewObjectTypes_h
#define GameAsteroids_TextViewObjectTypes_h
	#include <string>
enum TextViewObjectType
{
TextViewObjectType_NONE,
TextViewObjectType_Helvetica_72pt,
	TextViewObjectType_MAX
};


struct TextViewObjectStruct
{
TextViewObjectType type;
std::string font_name;
int font_size;
};

extern TextViewObjectStruct g_TextViewObjectStructData[];

#endif
