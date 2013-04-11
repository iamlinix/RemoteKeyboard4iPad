//
//  SettingViewController.m
//  chat
//
//  Created by  jiangwei on 10-6-8.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"



@implementation SettingViewController

@synthesize ringLabel;
@synthesize statusLabel;
@synthesize ringSwitch;
@synthesize statusText;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.title=NSLocalizedString(@"setting", nil);
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	statusText.delegate=self;
	self.ringLabel.text=NSLocalizedString(@"ring",nil);
	self.statusLabel.text=NSLocalizedString(@"twitter",nil);
}


-(IBAction)switchChange:(id)sender
{

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	
	return YES;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"unshake" object:self];
}

- (void)dealloc {
    [super dealloc];
}


@end
