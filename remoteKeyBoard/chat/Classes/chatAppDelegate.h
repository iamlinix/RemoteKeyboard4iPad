//
//  chatAppDelegate.h
//  chat
//
//  Created by  jiangwei on 10-5-12.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewController.h"
@class ShakeWindow;


@interface chatAppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet  ShakeWindow *window;
    UINavigationController *navigationController;
	IBOutlet SettingViewController *settingView;
	bool settingCount;
}

@property (nonatomic, retain) IBOutlet SettingViewController *settingView;
@property (nonatomic, retain) IBOutlet ShakeWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;

-(void)Settings;
-(void)UnSetting;
-(void)PresentLoginModule;
@end

