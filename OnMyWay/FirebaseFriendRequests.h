//
//  FireBaseFriendRequests.h
//  OnMyWay
//
//  Created by Taylor King on 9/23/15.
//  Copyright © 2015 omwltd. All rights reserved.
//
#import <Firebase/Firebase.h>
#import <Foundation/Foundation.h>
#import "FirebaseCore.h"

@interface FirebaseFriendRequests : NSObject

@property (strong, nonatomic) NSDictionary *currentFriendRequests;
@property (strong, nonatomic) Firebase *firebaseRootInstance;
@property (strong, nonatomic) Firebase *firebaseFriendRequestInstance;

-(FirebaseFriendRequests*)initWithFirebaseCore:(FirebaseCore*)firebaseCore;
-(void)didRecieveFriendRequest:(FDataSnapshot*)snapshot;
-(void)sendFriendRequestToUid:(NSString*)uid;

@end
