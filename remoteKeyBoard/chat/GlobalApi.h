//
//  GlobalApi.h
//  chat
//
//  Created by  jiangwei on 10-6-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define CONFIG_FILE     @"settings.config"

@class GlobalApi;
@protocol GlobalApiDelegate <NSObject>
@end

@interface GlobalApi : NSObject {
	NSString *key;
	NSString *ringSwitch;
	NSString *status;
@private
	id _delegate;
}

@property(assign) id<GlobalApiDelegate> delegate;

@property (nonatomic, retain) NSString *key;
@property NSUInteger ringSwitch;
@property (nonatomic, retain) NSString *status;

+ (GlobalApi *)sharedGlobalApi;

-(NSString*)GetKey;
-(NSString*)GetSwitch;
-(NSString *)GetStatus;

-(void)SetSwitch:(NSString*)para;
-(void)SetStatus:(NSString*)para;
-(void)SaveAllConfig;


-(NSString*)GetRandomString;
-(NSDictionary*)ReadConfigDicFromFile:(NSString*)fileName;
-(BOOL)WriteConfigDicToFile:(NSString*)fileName withData:(NSDictionary*)configDic;
-(NSString*)GetPathForFileName:(NSString*)fileName;


@end
