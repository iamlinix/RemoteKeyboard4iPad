

#import <Foundation/Foundation.h>  
#import <CFNetwork/CFNetwork.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import "AsyncSocket.h"
#import "AsyncUdpSocket.h"
#import "GlobalApi.h"

#define CLIENT_VERSION     @"V:i0.1"

@class Communicator;
@protocol CommunicatorDelegate <NSObject>
-(void)ReturnDataFromCommunicator:(NSString*)data;
@end


@interface Communicator : NSObject {
	AsyncSocket *tcpSocket;
	AsyncUdpSocket *udpSocket;
	BOOL isConnected;
	NSString *key;
	

@private
	id _delegate;
}

+ (Communicator *)sharedCommunicator;

@property(assign) id<CommunicatorDelegate> delegate;

-(void)StartCommunication;
-(void)SendR;
-(void)SendH;
-(void)SendV;
-(void)SendMsg:(NSString *)requestString;

@end
