
#ifndef GameAsteroids_LocalizedTextViewObjectTypes_h
#define GameAsteroids_LocalizedTextViewObjectTypes_h
	#include <string>
enum LocalizedTextViewObjectType
{
LocalizedTextViewObjectType_NONE,
LocalizedTextViewObjectType_Ariel_8pt,
	LocalizedTextViewObjectType_Helvetica_72pt,
	LocalizedTextViewObjectType_Helvetica_8pt,
	LocalizedTextViewObjectType_Helvetica_32pt,
	LocalizedTextViewObjectType_Helvetica_64pt,
	LocalizedTextViewObjectType_Helvetica_128pt,
	LocalizedTextViewObjectType_Monaco_32pt,
	LocalizedTextViewObjectType_MAX
};


struct LocalizedTextViewObjectStruct
{
LocalizedTextViewObjectType type;
std::string font_name;
int font_size;
};

extern LocalizedTextViewObjectStruct g_LocalizedTextViewObjectStructData[];

#endif
