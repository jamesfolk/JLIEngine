//
//  FacebookSingleton.h
//  BaseProject
//
//  Created by library on 11/8/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__FacebookSingleton__
#define __BaseProject__FacebookSingleton__

#include "JLIEngineCommon.h"
#include "AbstractSingleton.h"
#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBGraphUser.h>


class FacebookSingleton : public AbstractSingleton<FacebookSingleton>
{
    friend class AbstractSingleton;
public:    
    void createNewSession()const;
    
    bool isLoggedIn()const
    {
        return m_IsLoggedIn;
    }
    
    template<class Function>
    void login(Function &fn)
    {
        FBSessionStateHandler handler = ^(FBSession *session,
                                    FBSessionState status,
                                    NSError *error)
        {
            if(error)
            {
                NSLog(@"ERROR %s, %d, %s, %@\n", __FILE__,__LINE__,__FUNCTION__, error.description);
            }
            else
            {
                // Did something go wrong during login? I.e. did the user cancel?
                if (status == FBSessionStateClosedLoginFailed || status == FBSessionStateCreatedOpening)
                {
                    // If so, just send them round the loop again
                    [[FBSession activeSession] closeAndClearTokenInformation];
                    [FBSession setActiveSession:nil];
                    //FB_CreateNewSession();
                    createNewSession();
                }
                else
                {
                    fn();
                    m_IsLoggedIn = true;
                }
            }
        };
        
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"email",
                                nil];
        
        // Attempt to open the session. If the session is not open, show the user the Facebook login UX
        [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:true completionHandler:handler];
    }
    
    void logout()
    {
        [[FBSession activeSession] closeAndClearTokenInformation];
        [FBSession setActiveSession:nil];
        
        m_fbUser = nil;
        m_fetchedFriendData = nil;
        m_FBRequestHandler = nil;
        m_IsLoggedIn = false;
    }
    
    template<class Function>
    void loadUserData(Function &fn)
    {
        FBRequestHandler handler = ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *result, NSError *error)
        {
            // Did everything come back okay with no errors?
            if (!error && result)
            {
                // If so we can extract out the player's Facebook ID and first name
                
                m_fbUser = result;
                
                fn();
            }
            else
            {
                if(error)
                    NSLog(@"ERROR %s, %d, %s, %@\n", __FILE__,__LINE__,__FUNCTION__, error.description);
            }
        };
        
        // Provide some social context to the game by requesting the basic details of the player from Facebook
        
        // Start the Facebook request
        [[FBRequest requestForMe]
         startWithCompletionHandler:handler];
    }
    
    template<class Function>
    void loadFriends(Function &fn)
    {
        FBRequestHandler handler = ^(FBRequestConnection *connection,
                                     NSDictionary *result,
                                     NSError *error)
        {
            if (!error && result)
            {
                m_fetchedFriendData = [[NSArray alloc] initWithArray:[result objectForKey:@"data"]];
                
                fn();
            }
            else
            {
                if(error)
                    NSLog(@"ERROR %s, %d, %s, %@\n", __FILE__,__LINE__,__FUNCTION__, error.description);
            }
        };
        
        [[FBRequest requestForGraphPath:@"me/friends"]
         startWithCompletionHandler:handler];
    }
    
    
    
    void processIncomingURL(NSURL* targetURL)
    {
        NSRange range = [targetURL.query rangeOfString:@"notif" options:NSCaseInsensitiveSearch];
        
        // If the url's query contains 'notif', we know it's coming from a notification - let's process it
        if(targetURL.query && range.location != NSNotFound)
        {
            // Yes the incoming URL was a notification
            processIncomingRequest(targetURL);
        }
    }
    
    
    void sendRequest(const std::string &message, const std::string &data)
    {
        NSString *challengeStr = [NSString stringWithFormat:@"%s", data.c_str()];
        
        FBWebDialogHandler handler = ^(FBWebDialogResult result, NSURL *resultURL, NSError *error)
        {
            if (error)
            {
                NSLog(@"ERROR %s, %d, %s, %@\n", __FILE__,__LINE__,__FUNCTION__, error.description);
            }
            else
            {
                if (result == FBWebDialogResultDialogNotCompleted)
                {
                    // Case B: User clicked the "x" icon
                    NSLog(@"User canceled request.");
                }
                else
                {
                    NSLog(@"Request Sent.");
                }
            }
        };
        
        NSString *msg = [NSString stringWithFormat:@"%s", message.c_str()];
        
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:challengeStr, @"data", nil];

        [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                      message:msg
                                                        title:nil
                                                   parameters:params
                                                      handler:handler];
//        FBFrictionlessRecipientCache *friendCache = [[FBFrictionlessRecipientCache alloc] init];
//        [friendCache prefetchAndCacheForSession:nil];
//        
//        [FBWebDialogs presentRequestsDialogModallyWithSession:nil
//                                                      message:msg
//                                                        title:nil
//                                                   parameters:params
//                                                      handler:handler
//                                                  friendCache:friendCache];
    }
    
    
    u32 getNumberOfFriends()const
    {
        if(m_fetchedFriendData)
            return m_fetchedFriendData.count;
        return 0;
    }
    
    std::string getFriendName(const u32 index)const
    {
        if(m_fetchedFriendData && index < getNumberOfFriends())
        {
            NSDictionary *friendData = [m_fetchedFriendData objectAtIndex:index];
            
            return std::string([[friendData objectForKey:@"name"] UTF8String]);
        }
        return std::string("");
    }
    
    s64 getFriendID(const u32 index)const
    {
        if(m_fetchedFriendData && index < getNumberOfFriends())
        {
            NSDictionary *friendData = [m_fetchedFriendData objectAtIndex:index];
            NSString *friendId = [friendData objectForKey:@"id"];
            return [friendId longLongValue];
            
        }
        return 0;
    }
    
    IDType loadFriendAvatar(const u32 index, const u16 avatar_width, const u16 avatar_height)const;
    
    
    
    IDType loadAvatar(const u16 avatar_width, const u16 avatar_height)const;
    
    s64 getID()const
    {
        if(m_fbUser)
            return [m_fbUser.id longLongValue];
        return 0;
    }
    std::string getFirstName()const
    {
        if(m_fbUser && m_fbUser.first_name)
            return std::string([m_fbUser.first_name UTF8String]);
        return std::string("");
    }
    std::string getMiddleName()const
    {
        if(m_fbUser && m_fbUser.middle_name)
            return std::string([m_fbUser.middle_name UTF8String]);
        return std::string("");
    }
    std::string getLastName()const
    {
         if(m_fbUser && m_fbUser.last_name)
            return std::string([m_fbUser.last_name UTF8String]);
        return std::string("");
    }
    
    void setRequestHandler(FBRequestHandler handler)
    {
        m_FBRequestHandler = handler;
    }
    
private:
    
    void processIncomingRequest(NSURL* targetURL)
    {
        // Extract the notification id
        NSArray *pairs = [targetURL.query componentsSeparatedByString:@"&"];
        NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
        for (NSString *pair in pairs)
        {
            NSArray *kv = [pair componentsSeparatedByString:@"="];
            NSString *val = [[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [queryParams setObject:val forKey:[kv objectAtIndex:0]];
        }
        
        NSString *requestIDsString = [queryParams objectForKey:@"request_ids"];
        NSArray *requestIDs = [requestIDsString componentsSeparatedByString:@","];
        
        FBRequest *req = [[FBRequest alloc] initWithSession:[FBSession activeSession] graphPath:[requestIDs objectAtIndex:0]];
        
        if(m_FBRequestHandler)
        {
            [req startWithCompletionHandler:m_FBRequestHandler];
        }
    }
    
    std::string getAvatarAddress(s64 ID, const u16 width, const u16 height)const ;
    
    FacebookSingleton();
    virtual ~FacebookSingleton();
    
    //s64 m_FBID;
    NSDictionary<FBGraphUser> *m_fbUser;
    
    NSArray *m_fetchedFriendData;
    
    FBRequestHandler m_FBRequestHandler;
    
    bool m_IsLoggedIn;
};

#endif /* defined(__BaseProject__FacebookSingleton__) */
