//
//  SingletonSoundManager.h
//  Tutorial1
//
//  Created by Michael Daley on 22/05/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
// This sound engine class has been created based on the OpenAL tutorial at
// http://benbritten.com/blog/2008/11/06/openal-sound-on-the-iphone/

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
//#import "Common.h"

// Define the maximum number of sources we can use
#define kMaxSources 32

class btVector3;

@interface SingletonSoundManager : NSObject {
	
	BOOL gOtherAudioIsPlaying;
	
	// OpenAL context for playing sounds
	ALCcontext *context;
	
	// The device we are going to use to play sounds
	ALCdevice *device;
	
	// Array to store the OpenAL buffers we create to store sounds we want to play
	NSMutableArray *_SFXSources;
	NSMutableDictionary *soundLibrary;
	NSMutableDictionary *musicLibrary;
	
	// AVAudioPlayer responsible for playing background music
	AVAudioPlayer *currentBGMplayer;
	
	NSMutableDictionary *musicPlayers;
	
	// Background music volume which is remembered between tracks
	//ALfloat backgroundMusicVolume;
}

+ (SingletonSoundManager *)sharedSoundManager;

//- (ALCcontext*)getContext;
//- (ALCdevice*)getDevice;

- (id)init;


- (void) setSFXVolume:(NSUInteger)sourceID _volume:(ALfloat)volume;
- (void) setSFXPitch:(NSUInteger)sourceID _pitch:(ALfloat)pitch;
- (void) setSFXRollOffFactor:(NSUInteger)sourceID _rollOffFactor:(ALfloat)rollOffFactor;
- (void) setSFXPosition:(NSUInteger)sourceID _position:(const btVector3&)position;
- (void) setSFXVelocity:(NSUInteger)sourceID _velocity:(const btVector3&)velocity;
- (void) setSFXDirection:(NSUInteger)sourceID _direction:(const btVector3&)direction;
- (void) setSFXIsRelative:(NSUInteger)sourceID _isRelative:(bool)isRelative;
- (void) setSFXLooping:(NSUInteger)sourceID _isLooping:(bool)isLooping;
- (void) loadSFXWithKey:(NSString*)theSFXKey fileName:(NSString*)theFileName fileExt:(NSString*)theFileExt frequency:(NSUInteger)theFrequency;
- (void) unLoadSFXWithKey:(NSString*)theSFXKey;
- (NSUInteger) playSFXWithKey:(NSString*)theSFXKey 
						   gain:(ALfloat)theGain 
						  pitch:(ALfloat)thePitch
				  rollOffFactor:(ALfloat)theRollOffFactor
					   location:(const ALfloat*)theLocation
					   velocity:(const ALfloat*)theVelocity
					  direction:(const ALfloat*)theDirection
					 isRelative:(BOOL)theSourceRelative
					 shouldLoop:(BOOL)theShouldLoop;
- (NSUInteger) playSFXWithKey:(NSString*)theSFXKey;
- (void) stopSFXWithKey:(NSString*)theSFXKey;

- (void) pauseSFX:(NSUInteger)sourceID;
- (void) unPauseSFX:(NSUInteger)sourceID;
- (BOOL) isPausedSFX:(NSUInteger)sourceID;
- (BOOL) isPlayingSFX:(NSUInteger)sourceID;
- (void) pauseSFX;
- (void) unPauseSFX;


- (void) loadBGMWithKey:(NSString*)theMusicKey fileName:(NSString*)theFileName fileExt:(NSString*)theFileExt;
- (void) unLoadBGMWithKey:(NSString*)theMusicKey;
- (void) playBGMWithKey:(NSString*)theMusicKey timesToRepeat:(NSInteger)theTimesToRepeat fadeIn:(BOOL)fade;
- (void) stopBGMWithKey:(NSString*)theMusicKey fadeOut:(BOOL)fade;
- (void) setBGMVolume:(NSString*)theMusicKey volume:(ALfloat)theVolume;

- (void) pauseBGM;
- (void) unPauseBGM;
- (BOOL) isPlayingBGM;
- (double) getBGMDeviceTime;
- (double) getBGMCurrentTime;
- (double) getBGMDuration;
- (void) setBGMRate:(float)rate;
- (float) getBGMRate;
- (void) setBGMVolume:(ALfloat)volume;
- (ALfloat) getBGMVolume;




- (void) shutdownSoundManager;



- (void) update;

- (void) setupMenuListenerPosition;
// Stop/Start OpenAL
- (void)setActivated:(BOOL)aState;

- (void) errorAL:(const char*)_fname funct:(const char*)_funct line:(unsigned int)_line;

@end
