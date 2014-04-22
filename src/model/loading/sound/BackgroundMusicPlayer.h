//
//  BackgroundMusicPlayer.h
//  template
//
//  Created by James Folk on 12/11/11.
//  Copyright 2011 JFArmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>

//#define USING_ARC

@interface BackgroundMusicPlayer : NSObject 
{
	AVAudioPlayer *backgroundMusicPlayer;
	ALfloat crement;
}

@property (readwrite, strong) AVAudioPlayer *backgroundMusicPlayer;
@property (readwrite, assign) ALfloat crement;

- (id)initContents:(AVAudioPlayer*)_backgroundMusicPlayer crement:(ALfloat)_crement;

@end
