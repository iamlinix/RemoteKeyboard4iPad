//
//  Communicator.m
//  chat
//
//  Created by  jiangwei on 10-5-13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Communicator.h"
#include <UIKit/UIKit.h>


static Communicator *_sharedCommunicator;

@implementation Communicator

@synthesize delegate=_delegate;

+ (Communicator *)sharedCommunicator
{
	if (!_sharedCommunicator) {
		_sharedCommunicator = [[Communicator alloc] init];
	}
	return _sharedCommunicator;
}

- (id)init
{
	if(self = [super init])
	{
		tcpSocket = [[AsyncSocket alloc] initWithDelegate:self];
		udpSocket = [[AsyncUdpSocket alloc]initWithDelegate:self];
	}
	return self;
}

- (void)dealloc
{		
	[_sharedCommunicator release];
	[super dealloc];
}

-(void)StartCommunication
{
	NSLog(@"Ready");
	
	key=[[GlobalApi sharedGlobalApi]GetKey];
	[key retain];
	NSError *err = nil;
	if ( ![udpSocket connectToHost:@"xx.xx.xx.xx" onPort:4567 error:err])
	{
		NSLog(@"UDP ERROR: %@",err);
	}
	[err release];
}

-(void)SendH
{
	[self SendMsg:@"H:"];
}

-(void)SendV
{
	[self SendMsg:CLIENT_VERSION];
}

-(void)SendR
{
	[self SendMsg:@"R:"];
}

-(void)SendMsg:(NSString *)requestString
{
	NSString *sendOneString=[key stringByAppendingString:requestString];
	NSString *sendTwoString=[sendOneString stringByAppendingString:@"\n"];
	NSData *requestData = [sendTwoString dataUsingEncoding:NSUTF8StringEncoding];
	[udpSocket sendData:requestData	withTimeout:-1 tag:1];
	[udpSocket receiveWithTimeout:-1 tag:0];
//	[sendString release];
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
	NSString *test=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(test);
	[self.delegate ReturnDataFromCommunicator:test];
	[udpSocket receiveWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
/*	isConnected=YES;
	NSString *requestString=@"hello server u";
	 NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];

	[tcpSocket writeData:requestData withTimeout:-1 tag:1];
	[tcpSocket retain];
 */
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSString *recevieMsg=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"Receive Msg: %@",recevieMsg);
	[self.delegate ReturnDataFromCommunicator:recevieMsg];
	[tcpSocket readDataWithTimeout:-1 tag:0];
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
	
}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
	
}
- (NSRunLoop *)onSocket:(AsyncSocket *)sock wantsRunLoopForNewSocket:(AsyncSocket *)newSocket
{
	
}
- (BOOL)onSocketWillConnect:(AsyncSocket *)sock
{
	return YES;
}
- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(CFIndex)partialLength tag:(long)tag
{
	 
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
//	[socket readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didWritePartialDataOfLength:(CFIndex)partialLength tag:(long)tag
{
	
}

- (NSTimeInterval)onSocket:(AsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(CFIndex)length
{
	
}
 
- (NSTimeInterval)onSocket:(AsyncSocket *)sock
 shouldTimeoutWriteWithTag:(long)tag
				   elapsed:(NSTimeInterval)elapsed
				 bytesDone:(CFIndex)length
{
	
}
- (void)onSocketDidSecure:(AsyncSocket *)sock
{
	
}
@end
