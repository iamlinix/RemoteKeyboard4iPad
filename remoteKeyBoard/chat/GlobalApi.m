//
//  GlobalApi.m
//  chat
//
//  Created by  jiangwei on 10-6-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GlobalApi.h"

static GlobalApi *_GlobalApi;

@implementation GlobalApi
@synthesize delegate=_delegate;

+ (GlobalApi *)sharedGlobalApi
{
	if (!_GlobalApi) {
		_GlobalApi = [[GlobalApi alloc] init];
	}
	return _GlobalApi;
}

- (id)init
{
	if(self = [super init])
	{
		NSDictionary *confDic=[self ReadConfigDicFromFile:CONFIG_FILE];
		if(confDic != nil)
		{
			if([confDic objectForKey:@"key"] != nil && [confDic objectForKey:@"switch"]!=nil  && [confDic objectForKey:@"status"]!=nil)
			{
				key = [confDic objectForKey:@"key"];
				ringSwitch=[confDic objectForKey:@"switch"];
				status = [confDic objectForKey:@"status"];
			}
			else
			{
				key=[self GetRandomString];
				NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithDictionary:confDic];
				[mutDic setValue:key forKey:@"key"];
				[mutDic setValue:@"" forKey:@"status"];
				[mutDic setValue:@"yes" forKey:@"switch"];
				[self WriteConfigDicToFile:CONFIG_FILE withData:mutDic];
				[mutDic release];
			}
		}
		else
		{
			key=[self GetRandomString];
			NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithDictionary:confDic];
			[mutDic setValue:key forKey:@"key"];
			[mutDic setValue:@"" forKey:@"status"];
			[mutDic setValue:@"yes" forKey:@"switch"];
			[self WriteConfigDicToFile:CONFIG_FILE withData:mutDic];
			[mutDic release];
		}
		key=[@"Key:" stringByAppendingString:key];		
	}
	return self;
}

-(NSString*)GetKey
{
	return key;
}

-(NSString*)GetSwitch
{
	return ringSwitch;
}

-(NSString*)GetStatus
{
	return status;
}

-(void)SetSwitch:(NSString*)para
{
	ringSwitch=para;
}

-(void)SetStatus:(NSString*)para
{
	status=para;
}

-(void)SaveAllConfig
{
	NSDictionary *confDic=[self ReadConfigDicFromFile:CONFIG_FILE];
	NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithDictionary:confDic];
	[mutDic setValue:key forKey:@"key"];
	[mutDic setValue:status forKey:@"status"];
	[mutDic setValue:ringSwitch forKey:@"switch"];
	[self WriteConfigDicToFile:CONFIG_FILE withData:mutDic];
	[mutDic release];
}


NSInteger MyRandomIntegerBetween(NSInteger min, NSInteger max) {	
	return (random() % (max - min + 1)) + min;
}

-(NSString*)GetRandomString
{
	char string[2] = {0,0};
	NSString *test=[[NSString alloc]init];
	for(int i=0;i<16;i++)
	{
		string[0] = MyRandomIntegerBetween(65, 90); /// 'A' -> 'Z' in ASCII.
		test=[test stringByAppendingString:[[NSString alloc]initWithCString:string encoding:NSASCIIStringEncoding]];
	}
	return test;
}


-(BOOL)WriteConfigDicToFile:(NSString*)fileName withData:(NSDictionary*)configDic
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *path = [self GetPathForFileName:fileName];
	BOOL bSuccess = [configDic writeToFile:path atomically:YES];
	
	[pool release];
	return bSuccess;
}

-(NSDictionary*)ReadConfigDicFromFile:(NSString*)fileName
{
	NSString *path = [self GetPathForFileName:fileName];
	NSDictionary *configDic = [NSDictionary dictionaryWithContentsOfFile:path];
	return configDic;
}

-(NSString*)GetPathForFileName:(NSString*)fileName
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSLog(path);
	
	return path;
}

- (void)dealloc
{		
	[_GlobalApi release];
	[super dealloc];
}


@end
