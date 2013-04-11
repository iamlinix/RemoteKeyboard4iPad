//
//  ShakeWindow.m
//  chat
//
//  Created by  jiangwei on 10-6-8.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ShakeWindow.h"


@implementation ShakeWindow



- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	if (motion == UIEventSubtypeMotionShake )
	{
		// User was shaking the device. Post a notification named "shake".
		[[NSNotificationCenter defaultCenter] postNotificationName:@"shake" object:self];
	}
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{	
}

@end
