//
//  UserSettingsSingleton.h
//  BaseProject
//
//  Created by library on 9/24/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__UserSettings__
#define __BaseProject__UserSettings__

#include "AbstractSingleton.h"
#include <string>

class UserSettingsSingleton : public AbstractSingleton<UserSettingsSingleton>
{
public:
    UserSettingsSingleton();
    ~UserSettingsSingleton();
    
    virtual void registerDefaults(const std::string &userDefaultsFile);
    
    bool getBool(const std::string &key)const;
    float getFloat(const std::string &key)const;
    int getInteger(const std::string &key)const;
    std::string getString(const std::string &key)const;
    
    void setBool(const std::string &key, bool value)const;
    void setFloat(const std::string &key, float value)const;
    void setInteger(const std::string &key, int value)const;
    void setString(const std::string &key, const std::string value)const;
    
};

#endif /* defined(__BaseProject__UserSettings__) */
