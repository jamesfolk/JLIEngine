//
//  SingletonSoundManager.m
//  Tutorial1
//
//  Created by Michael Daley on 22/05/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
// This sound engine class has been created based on the OpenAL tutorial at
// http://benbritten.com/blog/2008/11/06/openal-sound-on-the-iphone/


#import "SingletonSoundManager.h"

#import "BackgroundMusicPlayer.h"

#include "btVector3.h"

#import <OpenAL/al.h>
#import <OpenAL/alc.h>

@interface SingletonSoundManager (Private)
- (BOOL)initOpenAL;
- (NSUInteger) nextAvailableSFXSource;
- (AudioFileID) openAudioFile:(NSString*)theFilePath;
- (UInt32) audioFileSize:(AudioFileID)fileDescriptor;
@end


@implementation SingletonSoundManager

// This var will hold our Singleton class instance that will be handed to anyone who asks for it
SingletonSoundManager *sharedSoundManager = nil;

// Class method which provides access to the sharedSoundManager var.
+ (SingletonSoundManager *)sharedSoundManager {
	
	// synchronized is used to lock the object and handle multiple threads accessing this method at
	// the same time
	@synchronized(self) {
		
		// If the sharedSoundManager var is nil then we need to allocate it.
		if(sharedSoundManager == nil) {
			// Allocate and initialize an instance of this class
//#ifndef USING_ARC
			sharedSoundManager = [[self alloc] init];
//#endif
		}
	}
	
	// Return the sharedSoundManager
	return sharedSoundManager;
}


/* This is called when you alloc an object.  To protect against instances of this class being
 allocated outside of the sharedSoundManager method, this method checks to make sure 
 that the sharedSoundManager is nil before allocating and initializing it.  If it is not
 nil then nil is returned and the instance would need to be obtained through the sharedSoundManager method
 */
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedSoundManager == nil) {
            sharedSoundManager = [super allocWithZone:zone];
            return sharedSoundManager;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}


- (id)copyWithZone:(NSZone *)zone {
    return self;
}


//- (ALCcontext*)getContext
//{
//	return context;
//}
//- (ALCdevice*)getDevice
//{
//	return device;
//}

/* 
 When the init is called from the sharedSoundManager class method, this method will get called.
 This is where we then initialize the arrays and dictionaries which will store the OpenAL buffers
 create as well as the soundLibrary dictionary
 */
- (id)init
{
	if(self = [super init])
    {
		
//		// Register to be notified of both the UIApplicationWillResignActive and UIApplicationDidBecomeActive.
//		// Set up notifications that will let us know if the application resigns being active or becomes active
//		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
//                                                     name:@"UIApplicationWillResignActiveNotification" object:nil];
//		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) 
//                                                     name:@"UIApplicationDidBecomeActiveNotification" object:nil];
		
		_SFXSources = [[NSMutableArray alloc] init];
		soundLibrary = [[NSMutableDictionary alloc] init];
		musicLibrary = [[NSMutableDictionary alloc] init];
		
		musicPlayers = [[NSMutableDictionary alloc] init];
		
		// Set the default volume for music
		//backgroundMusicVolume = 1.0f;
		
		[self CheckIfOtherAudioIsPlaying];
		
		// Set up the OpenAL
		BOOL result = [self initOpenAL];
		if(!result)	return nil;
		return self;
	}
#if not defined(USING_ARC) || defined (_USING_ARC)
//#ifndef USING_ARC
	[self release];
#endif
	return nil;
}


- (void) setSFXVolume:(NSUInteger)sourceID _volume:(ALfloat)volume
{
    alSourcef(sourceID, AL_GAIN, volume);
}

- (void) setSFXPitch:(NSUInteger)sourceID _pitch:(ALfloat)pitch
{
    alSourcef(sourceID, AL_PITCH, pitch);
}

- (void) setSFXRollOffFactor:(NSUInteger)sourceID _rollOffFactor:(ALfloat)rollOffFactor
{
    alSourcef( sourceID, AL_ROLLOFF_FACTOR, rollOffFactor );
}

- (void) setSFXPosition:(NSUInteger)sourceID _position:(const btVector3&)position
{
    ALfloat pos[3] = {position.getX(), position.getY(), position.getZ()};
    alSourcefv(sourceID, AL_POSITION, pos);
}

- (void) setSFXVelocity:(NSUInteger)sourceID _velocity:(const btVector3&)velocity
{
    ALfloat vel[3] = {velocity.getX(), velocity.getY(), velocity.getZ()};
    alSourcefv( sourceID, AL_VELOCITY, vel );
}

- (void) setSFXDirection:(NSUInteger)sourceID _direction:(const btVector3&)direction
{
    ALfloat dir[3] = {direction.getX(), direction.getY(), direction.getZ()};
    alSourcefv( sourceID, AL_DIRECTION, dir );
}

- (void) setSFXIsRelative:(NSUInteger)sourceID _isRelative:(bool)isRelative
{
    if(isRelative)
	{
		alSourcei( sourceID, AL_SOURCE_RELATIVE, AL_TRUE );
	}
    else
    {
		alSourcei( sourceID, AL_SOURCE_RELATIVE, AL_FALSE );
	}
}

- (void) setSFXLooping:(NSUInteger)sourceID _isLooping:(bool)isLooping
{
    if(isLooping)
	{
		alSourcei(sourceID, AL_LOOPING, AL_TRUE);
	}
    else
    {
		alSourcei(sourceID, AL_LOOPING, AL_FALSE);
	}
}

- (void) loadSFXWithKey:(NSString*)theSoundKey
				 fileName:(NSString*)theFileName
				  fileExt:(NSString*)theFileExt
				frequency:(NSUInteger)theFrequency
{
	// Find the buffer linked to the key which has been passed in
	NSNumber *numVal = [soundLibrary objectForKey:theSoundKey];
	if(numVal != nil)
		return;
	
	// Get the full path of the audio file
	NSString *filePath = [[NSBundle mainBundle] pathForResource:theFileName ofType:theFileExt];
	
	// Now we need to open the file
	AudioFileID fileID = [self openAudioFile:filePath];
	
	// Find out how big the actual audio data is
	UInt32 fileSize = [self audioFileSize:fileID];
	
	// Create a location for the audio data to live temporarily
	//unsigned char *outData = (unsigned char *)malloc(fileSize);
    unsigned char *outData = new unsigned char[fileSize];
	
	// Load the byte data from the file into the data buffer
	OSStatus result = noErr;
	result = AudioFileReadBytes(fileID, FALSE, 0, &fileSize, outData);
	AudioFileClose(fileID);
	
	if(result != 0) {
		NSLog(@"ERROR SoundEngine: Cannot load sound: %@", theFileName);
		return;
	}
	
	NSUInteger bufferID;
	
	// Generate a buffer within OpenAL for this sound
	alGenBuffers(1, &bufferID);
	
	// Place the audio data into the new buffer
	alBufferData(bufferID, AL_FORMAT_STEREO16, outData, fileSize, theFrequency);
	
	// Save the buffer to be used later
	[soundLibrary setObject:[NSNumber numberWithUnsignedInt:bufferID] forKey:theSoundKey];
	
	// Clean the buffer
	if(outData)
    {
		//free(outData);
        delete [] outData;
		outData = NULL;
	}
}

- (void) unLoadSFXWithKey:(NSString*)theSoundKey
{
    NSNumber *bufferIDVal = [soundLibrary objectForKey:theSoundKey];
    
    if(bufferIDVal != nil)
    {
        NSUInteger bufferID = [bufferIDVal unsignedIntValue];
        alDeleteBuffers(1, &bufferID);
    }
}

/*
 Plays the sound which matches the key provided.  The Gain, pitch and if the sound should loop can
 also be set from the method signature
 */
- (NSUInteger) playSFXWithKey:(NSString*)theSoundKey
						   gain:(ALfloat)theGain
						  pitch:(ALfloat)thePitch
                  rollOffFactor:(ALfloat)theRollOffFactor
                       location:(const ALfloat*)theLocation
                       velocity:(const ALfloat*)theVelocity
					  direction:(const ALfloat*)theDirection
					 isRelative:(BOOL)theSourceRelative
					 shouldLoop:(BOOL)theShouldLoop
{
	alGetError(); // clear the error code
	
	// Find the buffer linked to the key which has been passed in
	NSNumber *numVal = [soundLibrary objectForKey:theSoundKey];
	if(numVal == nil) return 0;
	NSUInteger bufferID = [numVal unsignedIntValue];
	
	// Find an available source i.e. it is currently not playing anything
	NSUInteger sourceID = [self nextAvailableSFXSource];
	
	// Make sure that the source is clean by resetting the buffer assigned to the source
	// to 0
	alSourcei(sourceID, AL_BUFFER, 0);
	//Attach the buffer we have looked up to the source we have just found
	alSourcei(sourceID, AL_BUFFER, bufferID);
	
	// Set the pitch and gain of the source
	alSourcef(sourceID, AL_GAIN, theGain);
	alSourcef(sourceID, AL_PITCH, thePitch);
	
	alSourcef( sourceID, AL_ROLLOFF_FACTOR, theRollOffFactor );
	
	alSourcefv(sourceID, AL_POSITION, theLocation);
	
	alSourcefv( sourceID, AL_VELOCITY, theVelocity );
	
    alSourcefv( sourceID, AL_DIRECTION, theDirection );
	
    if(theSourceRelative)
	{
		alSourcei( sourceID, AL_SOURCE_RELATIVE, AL_TRUE );
	} else {
		alSourcei( sourceID, AL_SOURCE_RELATIVE, AL_FALSE );
	}
	
	// Set the looping value
	if(theShouldLoop)
	{
		alSourcei(sourceID, AL_LOOPING, AL_TRUE);
	} else {
		alSourcei(sourceID, AL_LOOPING, AL_FALSE);
	}
	
	// Check to see if there were any errors
#if defined(DEBUG) || defined (_DEBUG)
    [sharedSoundManager errorAL:__FILE__ funct:__FUNCTION__ line:__LINE__];
#endif
	
	// Now play the sound
	alSourcePlay(sourceID);
	
	// Return the source ID so that loops can be stopped etc
	return sourceID;
}

- (NSUInteger) playSFXWithKey:(NSString*)theSoundKey;
{
	const ALfloat v[] = {0.0f, 0.0f, 0.0f};
	return [sharedSoundManager playSFXWithKey:theSoundKey
										   gain:1.0f
										  pitch:1.0f
								  rollOffFactor:1.0f
									   location:v
									   velocity:v
									  direction:v
									 isRelative:YES
									 shouldLoop:NO];
}

- (void) stopSFXWithKey:(NSString*)theSoundKey
{
	
	// Get the buffer ID for the sound key
	NSNumber *numVal = [soundLibrary objectForKey:theSoundKey];
	if(numVal == nil) return;
	NSUInteger bufferID = [numVal unsignedIntValue];
	
	// Loop through the OpenAL sources and stop them
	// if it is using the wanted buffer.
	for(NSNumber *sourceIDVal in _SFXSources)
    {
		
		NSUInteger sourceID = [sourceIDVal unsignedIntValue];
		
		NSInteger bufferForSource;
		alGetSourcei(sourceID, AL_BUFFER, &bufferForSource);
		
		if (bufferForSource == bufferID) {
			
			alSourceStop( sourceID );
			alSourcei( sourceID, AL_BUFFER, 0);
			
		}
		
	}
	
	// Remove the object from the sound library
	//[soundLibrary removeObjectForKey:theSoundKey];
}

- (void) pauseSFX:(NSUInteger)sourceID
{
    if([self isPausedSFX:sourceID] &&
       ![self isPlayingSFX:sourceID])
    {
        alSourcePause(sourceID);
    }
}

- (void) unPauseSFX:(NSUInteger)sourceID
{
    if(![self isPausedSFX:sourceID] &&
       [self isPlayingSFX:sourceID])
    {
        alSourcePause(sourceID);
    }
}

- (BOOL) isPausedSFX:(NSUInteger)sourceID
{
    NSInteger sourceState;
    alGetSourcei(sourceID, AL_SOURCE_STATE, &sourceState);
    
    return (AL_PAUSED == sourceState);
}

- (BOOL) isPlayingSFX:(NSUInteger)sourceID
{
    NSInteger sourceState;
    alGetSourcei(sourceID, AL_SOURCE_STATE, &sourceState);
    
    return (AL_PLAYING == sourceState);
}

- (void) pauseSFX
{
    for(NSNumber *sourceIDVal in _SFXSources)
    {
        [self pauseSFX:[sourceIDVal unsignedIntValue]];
    }
}

- (void) unPauseSFX
{
    for(NSNumber *sourceIDVal in _SFXSources)
    {
        [self unPauseSFX:[sourceIDVal unsignedIntValue]];
    }
}



- (void) loadBGMWithKey:(NSString*)theMusicKey fileName:(NSString*)theFileName fileExt:(NSString*)theFileExt
{
	NSString *path = [[NSBundle mainBundle] pathForResource:theFileName ofType:theFileExt];
	[musicLibrary setObject:path forKey:theMusicKey];
}

- (void) unLoadBGMWithKey:(NSString*)theMusicKey
{
#if not defined(USING_ARC) || defined (_USING_ARC)
//#ifndef USING_ARC
    BackgroundMusicPlayer *musicPlayer = [musicPlayers objectForKey:theMusicKey];
    AVAudioPlayer *player = [musicPlayer backgroundMusicPlayer];
	[player release];
#endif
	[musicLibrary removeObjectForKey:theMusicKey];
	[musicPlayers removeObjectForKey:theMusicKey];
}

/*
 Play the background track which matches the key
 */
- (void) playBGMWithKey:(NSString*)theMusicKey timesToRepeat:(NSInteger)theTimesToRepeat fadeIn:(BOOL)fade
{
	if (gOtherAudioIsPlaying == YES)
		return;
    
	NSString *path = [musicLibrary objectForKey:theMusicKey];
	
	if(path)
	{
		NSError *error;
		// Initialize the AVAudioPlayer
		AVAudioPlayer *backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
		
        backgroundMusicPlayer.enableRate = YES;
        
		// If the backgroundMusicPlayer object is nil then there was an error
		if(nil != backgroundMusicPlayer)
		{
			if(fade)
			{
				[musicPlayers setObject:[[BackgroundMusicPlayer alloc] initContents:backgroundMusicPlayer crement:0.01] forKey: theMusicKey];
				[backgroundMusicPlayer setVolume:0.0f];
			}
			else
			{
				[musicPlayers setObject:[[BackgroundMusicPlayer alloc] initContents:backgroundMusicPlayer crement:0.0] forKey: theMusicKey];
				[backgroundMusicPlayer setVolume:1.0f];
			}
            
			
			
			// Set the number of times this music should repeat.  -1 means never stop until its asked to stop
			[backgroundMusicPlayer setNumberOfLoops:theTimesToRepeat];
			
			// Play the music
			[backgroundMusicPlayer play];
            
			currentBGMplayer = backgroundMusicPlayer;
		}
		else
		{
			NSLog(@"ERROR SoundManager: Could not play music for key '%@'", theMusicKey);
		}
	}
	else
	{
		NSLog(@"ERROR SoundEngine: The music key '%@' could not be found", theMusicKey);
	}
}


/*
 Stop playing the currently playing music
 */
- (void) stopBGMWithKey:(NSString*)theMusicKey fadeOut:(BOOL)fade
{
	if (gOtherAudioIsPlaying == YES)
		return;
	
	BackgroundMusicPlayer *musicPlayer = [musicPlayers objectForKey:theMusicKey];
	AVAudioPlayer *player = [musicPlayer backgroundMusicPlayer];
	
	if(nil != player)
	{
		if(fade)
		{
			[musicPlayer setCrement:-0.01f];
		}
		else
		{
			[player stop];
			[player setVolume:0.0];
		}
	}
}

/*
 Set the volume of the music which is between 0.0 and 1.0
 */
- (void) setBGMVolume:(NSString*)theMusicKey volume:(ALfloat)theVolume
{
	BackgroundMusicPlayer *musicPlayer = [musicPlayers objectForKey:theMusicKey];
	AVAudioPlayer *player = [musicPlayer backgroundMusicPlayer];
	
	// Check to make sure that the audio player exists and if so set its volume
	if(nil != player)
		[player setVolume:theVolume];
}

- (void) pauseBGM
{
	[self setActivated:NO];
	if(currentBGMplayer)
		[currentBGMplayer pause];
}
- (void) unPauseBGM
{
	[self setActivated:YES];
	if(currentBGMplayer)
		[currentBGMplayer play];
}

- (BOOL) isPlayingBGM
{
    if(currentBGMplayer)
        return [currentBGMplayer isPlaying];
    return NO;
}

- (double) getBGMDeviceTime
{
    return [currentBGMplayer deviceCurrentTime];
}

- (double) getBGMCurrentTime
{
    return [currentBGMplayer currentTime];
}

- (double) getBGMDuration
{
    return [currentBGMplayer duration];
}

- (void) setBGMRate:(float)rate
{
    [currentBGMplayer setRate:rate];
}

- (float) getBGMRate
{
    return [currentBGMplayer rate];
}

- (void) setBGMVolume:(ALfloat)volume
{
    if (volume > 1.0f)
        [currentBGMplayer setVolume:1.0f];
    else if (volume < 0.0f)
        [currentBGMplayer setVolume:0.0f];
    else
        [currentBGMplayer setVolume:volume];
}
- (ALfloat) getBGMVolume
{
    return [currentBGMplayer volume];
}


/*
 This method is used to initialize OpenAL.  It gets the default device, creates a new context 
 to be used and then preloads the define # sources.  This preloading means we wil be able to play up to
 (max 32) different sounds at the same time
 */
- (BOOL) initOpenAL
{
	// Get the device we are going to use for sound.  Using NULL gets the default device
	device = alcOpenDevice(NULL);
	
	// If a device has been found we then need to create a context, make it current and then
	// preload the OpenAL Sources
	if(device)
    {
		// Use the device we have now got to create a context "air"
		context = alcCreateContext(device, NULL);
		// Make the context we have just created into the active context
		alcMakeContextCurrent(context);
		// Pre-create 32 sound sources which can be dynamically allocated to buffers (sounds)
		NSUInteger sourceID;
		for(int index = 0; index < kMaxSources; index++)
        {
			// Generate an OpenAL source
			alGenSources(1, &sourceID);
			// Add the generated sourceID to our array of sound sources
			[_SFXSources addObject:[NSNumber numberWithUnsignedInt:sourceID]];
		}
		
		// Return YES as we have successfully initialized OpenAL
		return YES;
	}
	// Something went wrong so return NO
	return NO;
}

- (void) shutdownSoundManager {
	@synchronized(self) {
		if(sharedSoundManager != nil) {
#if not defined(USING_ARC) || defined (_USING_ARC)
//#ifndef USING_ARC
			[self dealloc];
#endif
		}
	}
}


- (void) update
{
	for(id theMusicKey in musicPlayers) 
	{
		BackgroundMusicPlayer *musicPlayer = [musicPlayers objectForKey:theMusicKey];
		AVAudioPlayer *player = [musicPlayer backgroundMusicPlayer];
		ALfloat crement = [musicPlayer crement];
        
		if(0 != crement)
		{
			ALfloat volume = [player volume] + crement;
			
			if(volume < 0)
			{
				[player stop];
				[musicPlayer setCrement:0.0f];
				//[player release];
				//[musicLibrary removeObjectForKey:theMusicKey];
				//[musicPlayers removeObjectForKey:theMusicKey];
				
				//TODO: remove from musicPlayers
			}
			else
			{
				if(volume > 1)
				{
					volume = 1.0f;
					[musicPlayer setCrement:0.0f];
				}
				[player setVolume:volume];
			}
		}
	}
}

- (void) setupMenuListenerPosition
{
	// Set up the listener position
	ALfloat listener_pos[] = {0, 0, 0};
	ALfloat listener_ori[] = {0.0, 1.0, 0.0, 0.0, 0.0, 1.0}; //for stereo sounds
	ALfloat listener_vel[] = {0, 0, 0};
	
	alListenerfv(AL_POSITION, listener_pos);
	alListenerfv(AL_ORIENTATION, listener_ori);
	alListenerfv(AL_VELOCITY, listener_vel);
}

// Method which handles an interruption message from the audio session.  It reacts to the
// type of interruption state i.e. beginInterruption or endInterruption
void interruptionListener(	void *	inClientData,
                          UInt32	inInterruptionState) {
    
	if (inInterruptionState == kAudioSessionBeginInterruption) 
	{
        [sharedSoundManager setActivated:NO];
	} 
	else if (inInterruptionState == kAudioSessionEndInterruption) 
	{
        [sharedSoundManager setActivated:YES];
	}
}

-(void) CheckIfOtherAudioIsPlaying
{
	UInt32		propertySize, audioIsAlreadyPlaying;
	
	// do not open the track if the audio hardware is already in use (could be the iPod app playing music)
	propertySize = sizeof(UInt32);
#if not defined(USING_ARC) || defined (_USING_ARC)
//#ifndef USING_ARC
    AudioSessionInitialize(NULL,NULL,interruptionListener, self);
#else
    AudioSessionInitialize(NULL,NULL,interruptionListener, (__bridge void *)(self));
#endif
	
	
	AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &propertySize, &audioIsAlreadyPlaying);
	if (audioIsAlreadyPlaying != 0)
	{
		gOtherAudioIsPlaying = YES;
		UInt32	sessionCategory = kAudioSessionCategory_AmbientSound;
		AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
		AudioSessionSetActive(YES);
	}
	else
	{
		
		gOtherAudioIsPlaying = NO;
		
		// since no other audio is *supposedly* playing, then we will make darn sure by changing the audio session category temporarily
		// to kick any system remnants out of hardware (iTunes (or the iPod App, or whatever you wanna call it) sticks around)
		UInt32	sessionCategory = kAudioSessionCategory_MediaPlayback;
		AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
		AudioSessionSetActive(YES);
		
		// now change back to ambient session category so our app honors the "silent switch"
		sessionCategory = kAudioSessionCategory_AmbientSound;
		AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
	}
}





/*
 Used to load an audiofile from the file path which is provided.
 */
- (AudioFileID) openAudioFile:(NSString*)theFilePath {
	
	AudioFileID outAFID;
	// Create an NSURL which will be used to load the file.  This is slightly easier
	// than using a CFURLRef
	NSURL *afUrl = [NSURL fileURLWithPath:theFilePath];
	
	// Open the audio file provided
#if not defined(USING_ARC) || defined (_USING_ARC)
//#ifndef USING_ARC
    OSStatus result = AudioFileOpenURL((CFURLRef)afUrl, kAudioFileReadPermission, 0, &outAFID);
#else
    OSStatus result = AudioFileOpenURL((__bridge CFURLRef)afUrl, kAudioFileReadPermission, 0, &outAFID);
    
#endif
	
	
	// If we get a result that is not 0 then something has gone wrong.  We report it and 
	// return the out audio file id
	if(result != 0)	{
		NSLog(@"ERROR SoundEngine: Cannot open file: %@", theFilePath);
		return nil;
	}
	
	return outAFID;
}


/*
 This helper method returns the file size in bytes for a given AudioFileID
 */
- (UInt32) audioFileSize:(AudioFileID)fileDescriptor {
	UInt64 outDataSize = 0;
	UInt32 thePropSize = sizeof(UInt64);
	OSStatus result = AudioFileGetProperty(fileDescriptor, kAudioFilePropertyAudioDataByteCount, &thePropSize, &outDataSize);
	if(result != 0)	NSLog(@"ERROR: cannot file file size");
	return (UInt32)outDataSize;
}












/* 
 Search through the max number of sources to find one which is not playing.  If one cannot
 be found that is not playing then the first one which is looping is stopped and used instead.
 If a source still cannot be found then the first source is stopped and used
 */
- (NSUInteger) nextAvailableSFXSource
{
	
	// Holder for the current state of the current source
	NSInteger sourceState;
	
	// Find a source which is not being used at the moment
	for(NSNumber *sourceNumber in _SFXSources)
    {
		alGetSourcei([sourceNumber unsignedIntValue], AL_SOURCE_STATE, &sourceState);
		// If this source is not playing then return it
		if(sourceState != AL_PLAYING) return [sourceNumber unsignedIntValue];
	}
	
	// If all the sources are being used we look for the first non looping source
	// and use the source associated with that
	NSInteger looping;
	for(NSNumber *sourceNumber in _SFXSources) {
		alGetSourcei([sourceNumber unsignedIntValue], AL_LOOPING, &looping);
		if(!looping) {
			// We have found a none looping source so return this source and stop checking
			NSUInteger sourceID = [sourceNumber unsignedIntValue];
			alSourceStop(sourceID);
			return sourceID;
		}
	}
	
	// If there are no looping sources to be found then just use the first source and use that
	NSUInteger sourceID = [[_SFXSources objectAtIndex:0] unsignedIntegerValue];
	alSourceStop(sourceID);
	return sourceID;
}

#if not defined(USING_ARC) || defined (_USING_ARC)
//#ifndef USING_ARC
- (id)retain {
    return self;
}


- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
} 


//- (void)release {
//    //do nothing
//}


- (id)autorelease {
    return self;
}

#endif

- (void)dealloc
{
	// Loop through the OpenAL sources and delete them
	for(NSNumber *numVal in _SFXSources)
    {
		NSUInteger sourceID = [numVal unsignedIntValue];
		alDeleteSources(1, &sourceID);
	}
	
	// Loop through the OpenAL buffers and delete 
	NSEnumerator *enumerator = [soundLibrary keyEnumerator];
	id key;
	while ((key = [enumerator nextObject]))
    {
		NSNumber *bufferIDVal = [soundLibrary objectForKey:key];
		NSUInteger bufferID = [bufferIDVal unsignedIntValue];
		alDeleteBuffers(1, &bufferID);		
	}
	
	// Release the arrays and dictionaries we have been using
#if not defined(USING_ARC) || defined (_USING_ARC)
//#ifndef USING_ARC
	[soundLibrary release];
	[_SFXSources release];
	[musicLibrary release];
	
	[musicPlayers release];
#else
    soundLibrary = nil;
    _SFXSources = nil;
    musicLibrary = nil;
    musicPlayers = nil;
#endif
	
	// Disable and then destroy the context
	alcMakeContextCurrent(NULL);
	alcDestroyContext(context);
	
	// Close the device
	alcCloseDevice(device);
#if not defined(USING_ARC) || defined (_USING_ARC)
//#ifndef USING_ARC
	[super dealloc];
#endif
}


//- (void)applicationWillResignActive:(NSNotification *)notification
//{
//	[sharedSoundManager pauseBGM];
//}
//
//
//- (void)applicationDidBecomeActive:(NSNotification *)notification
//{
//	[sharedSoundManager unPauseBGM];
//}

- (void)setActivated:(BOOL)aState
{
    //return;
    //NSLog(@"Currently SingletonSoundManager setActivated doesn't work");
    
	//Currently not working.
    if(aState) 
	{
		
		UInt32 category = kAudioSessionCategory_AmbientSound;
		AudioSessionSetProperty ( kAudioSessionProperty_AudioCategory, sizeof (category), &category );
		
		// Reactivate the current audio session
		AudioSessionSetActive(YES);
		

#if defined(DEBUG) || defined (_DEBUG)
        [sharedSoundManager errorAL:__FILE__ funct:__FUNCTION__ line:__LINE__];
#endif
		
		// Bind and start the current context
        alcMakeContextCurrent(context);
        alcProcessContext(context);
    } 
	else 
	{
        
		// Set the audio session state to false (NO)
		AudioSessionSetActive(NO);
		
#if defined(DEBUG) || defined (_DEBUG)
        [sharedSoundManager errorAL:__FILE__ funct:__FUNCTION__ line:__LINE__];
#endif
		
        // Unbind the current context and suspend it
        alcMakeContextCurrent(NULL);
        alcSuspendContext(context);
    }
}

- (void) errorAL:(const char*)_fname funct:(const char*)_funct line:(unsigned int)_line
{
    unsigned int error = AL_NO_ERROR;
    NSString *log;
    while( ( error = alGetError() ) != AL_NO_ERROR )
	{
        switch( error )
		{
			case AL_INVALID_NAME:
			{
				log = [[NSString alloc] initWithUTF8String:"AL_INVALID_NAME"];//"AL_INVALID_NAME";
				break;
			}
                
			case AL_INVALID_ENUM:
			{
				log = [[NSString alloc] initWithUTF8String:"AL_INVALID_ENUM"];//"AL_INVALID_ENUM" ;
				break;
			}
                
			case AL_INVALID_VALUE:
			{
				log = [[NSString alloc] initWithUTF8String:"AL_INVALID_VALUE"];//"AL_INVALID_VALUE";
				break;
			}
                
			case AL_INVALID_OPERATION:
			{
				log = [[NSString alloc] initWithUTF8String:"AL_INVALID_OPERATION"];//"AL_INVALID_OPERATION";
				break;
			}
                
			case AL_OUT_OF_MEMORY:
			{
				log = [[NSString alloc] initWithUTF8String:"AL_OUT_OF_MEMORY"];//"AL_OUT_OF_MEMORY";
				break;
			}
		}
		
        NSLog(@"AL_ERROR: %@ %s(%d):%s", log, _fname, _line, _funct);
	}
}

@end
