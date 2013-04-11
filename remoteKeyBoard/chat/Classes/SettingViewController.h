//
//  SettingViewController.h
//  chat
//
//  Created by  jiangwei on 10-6-8.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalApi.h"

@interface SettingViewController : UIViewController <UITextFieldDelegate>{
	IBOutlet UILabel *ringLabel;
	IBOutlet UILabel *statusLabel;
	IBOutlet UISwitch *ringSwitch;
	IBOutlet UITextField *statusText;
	NSString *switchString;
	NSString *textString;

}

@property (nonatomic, retain) IBOutlet UILabel *ringLabel;
@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UISwitch *ringSwitch;
@property (nonatomic, retain) IBOutlet UITextField *statusText;

-(IBAction)switchChange:(id)sender;

@end
