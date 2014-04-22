//
//  BackgroundMusicPlayer.m
//  template
//
//  Created by James Folk on 12/11/11.
//  Copyright 2011 JFArmy. All rights reserved.
//

#import "BackgroundMusicPlayer.h"


@implementation BackgroundMusicPlayer

@synthesize backgroundMusicPlayer;
@synthesize crement;

- (id)init {
	if(self = [super init]) 
	{
		[self setBackgroundMusicPlayer:nil];
        [self setCrement:0.0];
		
		return self;
	}
#if not defined(USING_ARC) || defined (_USING_ARC)
//#ifndef USING_ARC
	[self release];
#endif
	return nil;
}

- (id)initContents:(AVAudioPlayer*)_backgroundMusicPlayer crement:(ALfloat)_crement;
{
	if(self = [super init]) 
	{
		[self setBackgroundMusicPlayer:_backgroundMusicPlayer];
        [self setCrement:_crement];
		
		return self;
	}
//#ifndef USING_ARC
#if not defined(USING_ARC) || defined (_USING_ARC)
	[self release];
#endif
	return nil;
}

#if not defined(USING_ARC) || defined (_USING_ARC)
//#ifndef USING_ARC
- (void) dealloc
{	
    [super dealloc];
}
#endif

@end

