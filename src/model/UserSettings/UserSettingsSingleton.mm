//
//  UserSettingsSingleton.mm
//  BaseProject
//
//  Created by library on 9/24/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "UserSettingsSingleton.h"
#include "FileLoader.h"

UserSettingsSingleton::UserSettingsSingleton()
{
    
}
UserSettingsSingleton::~UserSettingsSingleton()
{
    
}

void UserSettingsSingleton::registerDefaults(const std::string &userDefaultsFile)
{
    NSString *defaultsPath = [NSString stringWithUTF8String:FileLoader::getInstance()->getFilePath(userDefaultsFile).c_str()];
    
    NSDictionary *appDefaults = [NSDictionary dictionaryWithContentsOfFile:defaultsPath];
    
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    if(standardDefaults)
    {
        [standardDefaults registerDefaults:appDefaults];
        [standardDefaults synchronize];
    }
}

bool UserSettingsSingleton::getBool(const std::string &key)const
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pkey = [NSString stringWithUTF8String:key.c_str()];
    
    if(standardDefaults)
        return ([standardDefaults boolForKey:pkey]==YES)?true:false;
    return false;
}

float UserSettingsSingleton::getFloat(const std::string &key)const
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pkey = [NSString stringWithUTF8String:key.c_str()];
    return [standardDefaults floatForKey:pkey];
}
int UserSettingsSingleton::getInteger(const std::string &key)const
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pkey = [NSString stringWithUTF8String:key.c_str()];
    return [standardDefaults integerForKey:pkey];
}

std::string UserSettingsSingleton::getString(const std::string &key)const
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pkey = [NSString stringWithUTF8String:key.c_str()];
    return std::string([[standardDefaults stringForKey:pkey] UTF8String]);
}

void UserSettingsSingleton::setBool(const std::string &key, bool value)const
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pkey = [NSString stringWithUTF8String:key.c_str()];
    [standardDefaults setBool:(value)?YES:NO forKey:pkey];
    [standardDefaults synchronize];
}

void UserSettingsSingleton::setFloat(const std::string &key, float value)const
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pkey = [NSString stringWithUTF8String:key.c_str()];
    [standardDefaults setFloat:value forKey:pkey];
    [standardDefaults synchronize];
}

void UserSettingsSingleton::setInteger(const std::string &key, int value)const
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pkey = [NSString stringWithUTF8String:key.c_str()];
    [standardDefaults setInteger:value forKey:pkey];
    [standardDefaults synchronize];
}

void UserSettingsSingleton::setString(const std::string &key, const std::string value)const
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pkey = [NSString stringWithUTF8String:key.c_str()];
    NSString *pvalue = [NSString stringWithUTF8String:value.c_str()];
    [standardDefaults setValue:pvalue forKey:pkey];
    [standardDefaults synchronize];
}