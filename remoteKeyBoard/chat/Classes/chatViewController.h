//
//  chatViewController.h
//  chat
//
//  Created by  jiangwei on 10-5-12.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communicator.h"

@interface chatViewController : UIViewController < UIAlertViewDelegate,UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate, UINavigationControllerDelegate,CommunicatorDelegate>
{
	NSMutableArray		*chatArray;
	NSString			*chatFile;
	
	NSMutableDictionary	*currentChatInfo;
	NSMutableString		*currentString;
    BOOL				storingCharacters;
	
	BOOL				isMySpeaking;
	BOOL				loadingLog;
	UIAlertView *alert;
	NSString *urlNotification;
	
//	NSTimer *timer;
}

@property (nonatomic, retain) NSString *urlNotification;

- (IBAction)nextPeople:(id)sender;
- (IBAction)sendMessage:(id)sender;

-(void)timerFireMethod;
-(void)introduce;
-(void)ReturnDataFromCommunicator:(NSString*)data;
-(void)clearLog;
@end

