//
//  chatAppDelegate.m
//  chat
//
//  Created by  jiangwei on 10-5-12.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//
#import "chatAppDelegate.h"
#import "chatViewController.h"
#import "ShakeWindow.h"


@implementation chatAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize settingView;



- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    srandom(time(NULL));
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
	settingCount=NO;
//	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	chatViewController *chatView = [[chatViewController alloc] init];
	navigationController = [[UINavigationController alloc] initWithRootViewController:chatView];
 
	[chatView release];
	
	settingView=[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
 
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Settings) name:@"shake" object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnSetting) name:@"unshake" object:nil];
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}

- (void)dealloc {
    [navigationController release];
    [window release];
    [super dealloc];
}

-(void)UnSetting
{
	settingCount=NO;
}

-(void)Settings
{
	if(settingCount==NO)
	{
		settingCount=YES;
		
		[self.navigationController pushViewController:settingView animated:YES];
	}
}
@end
