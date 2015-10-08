//
//  FireBaseFriendRequests.m
//  OnMyWay
//
//  Created by Taylor King on 9/23/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import "FirebaseFriendRequests.h"

@implementation FirebaseFriendRequests
@synthesize firebaseRootInstance, firebaseFriendRequestInstance;
@synthesize currentFriendRequests;
@synthesize delegate;
-(FirebaseFriendRequests*)initWithFirebaseCore:(FirebaseCore*)firebaseCore {
    self = [super init];
    [self setFirebaseRootInstance:[firebaseCore firebaseRootInstance]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 
    [[[firebaseRootInstance childByAppendingPath:@"friend_invites"] childByAppendingPath:[defaults valueForKey:@"uid"]] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
     {
         
         [self didRecieveFriendRequestData:snapshot];
     }];
     
    return self;
}
-(void)didRecieveFriendRequestData:(FDataSnapshot*)snapshot {
    [delegate didRecieveFriendRequest:[snapshot value]];

}
-(void)responseRecievedFromSendFriendRequestToUid:(FDataSnapshot*)snapshot {

}

-(void)sendFriendRequestToUid:(NSString*)uid { 
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [[[[firebaseRootInstance childByAppendingPath:@"friend_invites"] childByAppendingPath:uid ]childByAppendingPath:[userDefaults valueForKey:@"uid"]] setValue:[userDefaults valueForKey:@"username"] withCompletionBlock:^(NSError *error, Firebase *ref){
        
    }];
}
-(void)acceptFriendRequestFromUid:(NSString*)uid username:(NSString*)username {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[[[firebaseRootInstance childByAppendingPath:@"friends"] childByAppendingPath:[defaults valueForKey:@"uid"]] childByAppendingPath:uid] setValue:username withCompletionBlock:^(NSError *err, Firebase *snapshot) {
        if(!err) {
            [[[[firebaseRootInstance childByAppendingPath:@"friends"] childByAppendingPath:uid] childByAppendingPath:[defaults valueForKey:@"uid"]] setValue:username withCompletionBlock:^(NSError *err, Firebase *snapshot) {
                if(!err) {
                    [[[[firebaseRootInstance childByAppendingPath:@"friend_invites"] childByAppendingPath:[defaults valueForKey:@"uid"]] childByAppendingPath:uid] removeValueWithCompletionBlock:^(NSError *err, Firebase *base){
                        if(!err)
                        {
                            [delegate didAcceptFriendRequestFrom:username uid:uid];
                        }
                    }];
                }
            }];
        }
    }];
    
    // Firebase
   // [[[firebaseRootInstance childByAppendingPath:@"friend_invites/"] childByAppendingPath:[NSString stringWithFormat:@"%@/",[defaults valueForKey:@"uid"]]] removeValueWithCompletionBlock:^(NSError *error, Firebase *ref) {
        
//    }];
}
-(void)declineFriendRequestFromUid:(NSString*)uid{
    
}
@end
