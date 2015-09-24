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
-(FirebaseFriendRequests*)initWithFirebaseCore:(FirebaseCore*)firebaseCore {
    self = [super init];
    [self setFirebaseRootInstance:[firebaseCore firebaseRootInstance]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    firebaseFriendRequestInstance = [firebaseRootInstance childByAppendingPath:@"friend_invites"];
    [[firebaseFriendRequestInstance childByAppendingPath:[defaults valueForKey:@"uid"]] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot* snapshot)
     {
         [self didRecieveFriendRequestData:snapshot];
     }];
     
    return self;
}
-(void)didRecieveFriendRequestData:(FDataSnapshot*)snapshot {
    currentFriendRequests = [snapshot value];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fbFriendRequestsAvailable" object:nil];
}
-(void)responseRecievedFromSendFriendRequestToUid:(FDataSnapshot*)snapshot {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"" object:nil];
}

-(void)sendFriendRequestToUid:(NSString*)uid {
    [[[firebaseRootInstance childByAppendingPath:@"friend_invites"] childByAppendingPath:uid] observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapShot) {
            
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
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"fbSuccessFullyAddedFriend" object:uid];
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
