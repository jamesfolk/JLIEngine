//
//  LocalizedTextLoader.h
//  BaseProject
//
//  Created by library on 9/12/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__LocalizedTextLoader__
#define __BaseProject__LocalizedTextLoader__

#include "AbstractSingleton.h"
#include "LocalizedTextViewObjectTypes.h"
#include "TextViewObjectFactoryIncludes.h"
#include "btAlignedObjectArray.h"
#include "btHashMap.h"

class LocalizedTextLoader : public AbstractSingleton<LocalizedTextLoader>
{
    friend class AbstractSingleton;
    
    LocalizedTextLoader();
    virtual ~LocalizedTextLoader();
public:
    void load(LocalizedTextViewObjectType type);
    void unLoad(LocalizedTextViewObjectType type);
    void unLoadAll();
    
    const TextInfo *getTextInfo(const std::string &localized_key,
                                LocalizedTextViewObjectType type) const;
    TextInfo *getTextInfo(const std::string &localized_key,
                          LocalizedTextViewObjectType type);
    IDType getTextureFactoryID(const std::string &localized_key, LocalizedTextViewObjectType type)const;
private:
    typedef btHashMap<btHashString, TextInfo*> LocalizedTextHashMap;
    typedef btAlignedObjectArray<char*> AllocatedNamesArray;
    typedef btHashMap<btHashString, IDType> TextureIdHashmap;
    
    typedef btHashMap<btHashInt, LocalizedTextHashMap*> TextInfoMapHashMap;
    typedef btHashMap<btHashInt, AllocatedNamesArray*> ImageNameArrayHashMap;
    typedef btHashMap<btHashInt, TextureIdHashmap*> TextureMapHashMap;
    
    TextInfoMapHashMap *m_pTextInfoMapHashMap;
    ImageNameArrayHashMap *m_pImageNameArrayHashMap;
    TextureMapHashMap *m_pTextureMapHashMap;
    
    btAlignedObjectArray<LocalizedTextViewObjectType> *m_LocalizedTextViewObjects;
};

#endif /* defined(__BaseProject__LocalizedTextLoader__) */
