//
//  FacebookSingleton.mm
//  BaseProject
//
//  Created by library on 11/8/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "FacebookSingleton.h"
#include "JLIEngineCommon.h"
#include "TextureFactory.h"
#include "TextureFactoryIncludes.h"

void FacebookSingleton::createNewSession()const
{
    FBSession* session = [[FBSession alloc] init];
    [FBSession setActiveSession: session];
}

//template<class Function>
//void FacebookSingleton::login(Function &fn)const


IDType FacebookSingleton::loadFriendAvatar(const u32 index, const u16 avatar_width, const u16 avatar_height)const
{
    TextureFactoryInfo info;
    info.right = getAvatarAddress(getFriendID(index), avatar_width, avatar_height);
    info.m_type = TextureFactoryTypes_URL;
    
    return TextureFactory::getInstance()->create(&info);
}

IDType FacebookSingleton::loadAvatar(const u16 avatar_width, const u16 avatar_height)const
{
    TextureFactoryInfo info;
    info.right = getAvatarAddress(getID(), avatar_width, avatar_height);
    info.m_type = TextureFactoryTypes_URL;
    
    return TextureFactory::getInstance()->create(&info);
}

//
std::string FacebookSingleton::getAvatarAddress(s64 ID, const u16 width, const u16 height)const 
{//
    NSString *resourceAddress = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/%llu/picture?width=%d&height=%d", ID, width, height];
    
    return std::string([resourceAddress UTF8String]);
}

FacebookSingleton::FacebookSingleton() :
m_fbUser(nil),
m_fetchedFriendData(nil),
m_FBRequestHandler(nil),
m_IsLoggedIn(false)
{
    
}

FacebookSingleton::~FacebookSingleton()
{
    
}
