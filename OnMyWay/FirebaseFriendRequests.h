//
//  FireBaseFriendRequests.h
//  OnMyWay
//
//  Created by Taylor King on 9/23/15.
//  Copyright © 2015 omwltd. All rights reserved.
//
#import "macros.h"
#import <Firebase/Firebase.h>
#import <Foundation/Foundation.h>
#import "FirebaseCore.h"
@protocol FirebaseFriendRequestsDelegate
-(void)didRecieveFriendRequest:(NSDictionary*)requests;
-(void)didAcceptFriendRequestFrom:(NSString*)username uid:(NSString*)uid;
@optional -(void)didSendFriendRequests:(NSString*)uid;

@end
@interface FirebaseFriendRequests : NSObject

@property (strong, nonatomic) NSDictionary *currentFriendRequests;
@property (strong, nonatomic) Firebase *firebaseRootInstance;
@property (strong, nonatomic) Firebase *firebaseFriendRequestInstance;
@property (strong, nonatomic) id<FirebaseFriendRequestsDelegate> delegate;
-(FirebaseFriendRequests*)initWithFirebaseCore:(FirebaseCore*)firebaseCore;
-(void)didRecieveFriendRequest:(FDataSnapshot*)snapshot;
-(void)sendFriendRequestToUid:(NSString*)uid;
-(void)acceptFriendRequestFromUid:(NSString*)uid username:(NSString*)username;
@end
