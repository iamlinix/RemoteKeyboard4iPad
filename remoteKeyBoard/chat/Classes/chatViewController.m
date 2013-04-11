//
//  chatViewController.m
//  chat
//
//  Created by  jiangwei on 10-5-12.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "chatViewController.h"


@implementation chatViewController


#define CHATFILENAME	@"chatLog.xml"

#define TEXTFIELDTAG	100
#define TOOLBARTAG		200
#define TABLEVIEWTAG	300
#define LOADINGVIEWTAG	400

- (id)init {
	if(self = [super init]) {
		[Communicator sharedCommunicator].delegate=self;
		[[Communicator sharedCommunicator]StartCommunication];
		UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
		self.view = contentView;
		[contentView release];
		
		chatArray = [[NSMutableArray alloc] initWithCapacity:0];
		isMySpeaking = YES;
		loadingLog = NO;
		
		self.title=NSLocalizedString(@"randomchat", nil);
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"clearLog", nil)
																				   style:UIBarButtonItemStyleBordered 
																				  target:self
																				  action:@selector(rightButtonAction)] autorelease];
		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"next", nil)
																				  style:UIBarButtonItemStyleBordered
																				 target:self
																				 action:@selector(leftButtonAction)] autorelease];
		
		UITextField *textfield = [[[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 31.0f)] autorelease];
		textfield.tag = TEXTFIELDTAG;
		textfield.delegate = self;
		textfield.autocorrectionType = UITextAutocorrectionTypeNo;
		textfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
		textfield.enablesReturnKeyAutomatically = YES;
		textfield.borderStyle = UITextBorderStyleRoundedRect;
		textfield.returnKeyType = UIReturnKeySend;
		textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
		
		UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 372.0f, 320.0f, 44.0f)];
		toolBar.tag = TOOLBARTAG;
		NSMutableArray* allitems = [[NSMutableArray alloc] init];
		[allitems addObject:[[[UIBarButtonItem alloc] initWithCustomView:textfield] autorelease]];
		[toolBar setItems:allitems];
		[allitems release];
		[self.view addSubview:toolBar];
		[toolBar release];
		
		UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 372.0f) style:UITableViewStylePlain];
		tableView.delegate = self;
		tableView.dataSource = self;
		tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		tableView.backgroundColor = [UIColor colorWithRed:0.859f green:0.886f blue:0.929f alpha:1.0f];
		tableView.tag = TABLEVIEWTAG;
		[self.view addSubview:tableView];
		[tableView release];
		[self introduce];
		[[Communicator sharedCommunicator]SendV];

	}
	
	return self;
}


#pragma mark Table view methods
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf {
	// build single chat bubble cell with given text
	UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
	returnView.backgroundColor = [UIColor clearColor];
	
	UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"bubbleSelf":@"bubble" ofType:@"png"]];
	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
	
	UIFont *font = [UIFont systemFontOfSize:13];
	CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(150.0f, 1000.0f) lineBreakMode:  UILineBreakModeWordWrap];
	
	UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(21.0f, 14.0f, size.width+10, size.height+10)];
	bubbleText.backgroundColor = [UIColor clearColor];
	bubbleText.font = font;
	bubbleText.numberOfLines = 0;
	bubbleText.lineBreakMode = UILineBreakModeWordWrap;
	bubbleText.text = text;
	
	bubbleImageView.frame = CGRectMake(0.0f, 0.0f, 200.0f, size.height+30.0f);
	if(fromSelf)
		returnView.frame = CGRectMake(120.0f, 0.0f, 200.0f, size.height+50.0f);
	else
		returnView.frame = CGRectMake(0.0f, 0.0f, 200.0f, size.height+50.0f);
	
	[returnView addSubview:bubbleImageView];
	[bubbleImageView release];
	[returnView addSubview:bubbleText];
	[bubbleText release];
	
	return [returnView autorelease];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	// return NO to disallow editing.
	if(loadingLog)
		return NO;
	
	self.navigationItem.rightBarButtonItem.title =NSLocalizedString(@"hideKeyboard",nil);
	UIToolbar *toolbar = (UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
	toolbar.frame = CGRectMake(0.0f, 156.0f, 320.0f, 44.0f);
	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 156.0f);
	if([chatArray count])
		[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
	self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"clearLog", nil);
	UIToolbar *toolbar = (UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
	toolbar.frame = CGRectMake(0.0f, 372.0f, 320.0f, 44.0f);
	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 372.0f);
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	// called when 'return' key pressed. return NO to ignore.
//	self.navigationItem.leftBarButtonItem.title = @"save chat log";
//	self.navigationItem.leftBarButtonItem.enabled = YES;
	UIView *chatView = [self bubbleView:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"self",nil), textField.text] 
								   from:isMySpeaking];
	NSString *sendString=@"c:";
	sendString=[sendString stringByAppendingString:textField.text];
	[[Communicator sharedCommunicator]SendMsg:sendString];
	[chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:textField.text, @"text", @"self", @"speaker", chatView, @"view", nil]];

	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	[tableView reloadData];
	[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	textField.text = @"";
	return YES;
}

#pragma mark navigation button methods
- (BOOL) hideKeyboard {
	UITextField *textField = (UITextField *)[self.view viewWithTag:TEXTFIELDTAG];
	if(textField.editing) {
		textField.text = @"";
		[self.view endEditing:YES];
		
		return YES;
	}
	
	return NO;
}

- (void) clickOutOfTextField:(id)sender {
	[self hideKeyboard];
}

- (void)introduce
{
	UIView *chatView = [self bubbleView:[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"system",nil), NSLocalizedString(@"introduce",nil)] 
								   from:isMySpeaking];
	[chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"introduce",nil), @"text", @"self", @"speaker", chatView, @"view", nil]];
	
	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	[tableView reloadData];
	[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];

}

- (void) rightButtonAction {
	if ( [self.navigationItem.rightBarButtonItem.title isEqualToString:NSLocalizedString(@"clearLog", nil) ] )
	{
		[self clearLog];
	}
	else if ( [self.navigationItem.rightBarButtonItem.title isEqualToString:NSLocalizedString(@"hideKeyboard",nil)] )
	{
		self.navigationItem.rightBarButtonItem.title=NSLocalizedString(@"clearLog", nil);
		[self hideKeyboard];
	}
}

-(void)clearLog
{
	[chatArray removeAllObjects];
	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	[tableView reloadData];
}

-(void)timerFireMethod
{
	self.navigationItem.leftBarButtonItem.enabled=YES;
}

- (void) leftButtonAction {
	 self.navigationItem.leftBarButtonItem.enabled=NO;
	[self performSelector:@selector(timerFireMethod)  withObject:nil afterDelay:10];
//	[timer fire];

	 [[Communicator sharedCommunicator]SendR];
	
	UIView *chatView = [self bubbleView:[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"system",nil), NSLocalizedString(@"switch",nil)] 
								   from:isMySpeaking];
	[chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"switch",nil), @"text", @"self", @"speaker", chatView, @"view", nil]];
	
	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	[tableView reloadData];
	[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	
}

#pragma mark view controller methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [chatArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UIView *chatView = [[chatArray objectAtIndex:[indexPath row]] objectForKey:@"view"];
	return chatView.frame.size.height+10.0f;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		
		cell.backgroundColor = [UIColor colorWithRed:0.859f green:0.886f blue:0.929f alpha:1.0f];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Set up the cell...
	NSDictionary *chatInfo = [chatArray objectAtIndex:[indexPath row]];
	for(UIView *subview in [cell.contentView subviews])
		[subview removeFromSuperview];
	[cell.contentView addSubview:[chatInfo objectForKey:@"view"]];
    return cell;
}

- (void)dealloc {
	[currentChatInfo release];
	[currentString release];
	
	[chatArray release];
	[chatFile release];
    [super dealloc];
}

-(void)ReturnDataFromCommunicator:(NSString*)data
{
//	chatlogView.text=[chatlogView.text stringByAppendingString:@"\n"];
	NSLog(data);
	if([data length]<=0)
		return;
	
	NSRange startRange = NSMakeRange(0, 2);
	
	NSString *startString = [data substringWithRange:startRange];
	if ( [startString isEqualToString:@"c:"] )
	{
		NSRange leftRange = NSMakeRange(2, [data length]-2);
		startString = [data substringWithRange:leftRange];
		UIView *chatView = [self bubbleView:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"other",nil), startString] from:NO];
		[chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:data, @"text", @"other", @"speaker", chatView, @"view", nil]];
	}
	else if([startString isEqualToString:@"v:"]) 
	{
		NSRange detectUpdateRange=NSMakeRange(2, 1);
		startString = [data substringWithRange:detectUpdateRange];
		if ( [startString isEqualToString:@"1"] )
		{
			NSRange updateUrlRange=NSMakeRange(3, [data length]-3);
			if (urlNotification==nil)
			{
				urlNotification=[[NSString alloc]init];
			}
			urlNotification = [data substringWithRange:updateUrlRange];
			[self alertYouAction:NSLocalizedString(@"Notice", nil) withMsg:NSLocalizedString(@"UpdateMsg", nil) withOK:NSLocalizedString(@"confirm", nil)];
		}
	}
	
	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	[tableView reloadData];
	[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];

}

-(void)alertYouAction:(NSString*)title withMsg:(NSString*)alertMsg withOK:(NSString*)okMsg
{
	if(alert == nil)
	{
		alert = [[UIAlertView alloc] initWithTitle:title message:alertMsg delegate:self cancelButtonTitle:okMsg otherButtonTitles:nil];
		[alert setDelegate:self];
	}
	alert.message = alertMsg;
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[alert release];
	alert = nil;
	[[UIApplication sharedApplication]openURL:urlNotification];
	
}

@end
