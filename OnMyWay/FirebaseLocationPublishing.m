//
//  FirebaseLocationPublishing.m
//  OnMyWay
//
//  Created by Taylor King on 9/23/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import "FirebaseLocationPublishing.h"

@implementation FirebaseLocationPublishing
@synthesize firebaseRootInstance;
@synthesize groups;
@synthesize delegate;
-(FirebaseLocationPublishing*)initWithFirebaseCore:(FirebaseCore *)firebaseCore {
    self = [super init];
    [self setFirebaseRootInstance:[firebaseCore firebaseRootInstance]];
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    [[[firebaseRootInstance childByAppendingPath:@"user_shares"] childByAppendingPath:[defaults valueForKey:@"uid"]] observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot){
        [self initialGroupsSnapshotRecieved:snapshot];
    }];
    return self;

}
-(void)createShare:(NSDictionary*)parameters {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    Firebase *childRef = [[firebaseRootInstance childByAppendingPath:@"shares"] childByAutoId];
    [childRef setValue:parameters withCompletionBlock:^(NSError *error, Firebase *ref) {
        [[[[firebaseRootInstance childByAppendingPath:@"user_shares"] childByAppendingPath:[defaults valueForKey:@"uid"]] childByAppendingPath:[ref key]] setValue:[NSNumber numberWithBool:true] withCompletionBlock:^(NSError *error, Firebase *ref){
            if(!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"fbDidCreateNewShare" object:nil];
            }
        }];
    }];
}
-(void)deleteAllMemberShares:(NSArray*)shares {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    for(NSString *gid in shares) {
        [[[firebaseRootInstance childByAppendingPath:@"shares"] childByAppendingPath:gid] removeValueWithCompletionBlock:^(NSError *error, Firebase *snapshot){
            [[[[firebaseRootInstance childByAppendingPath:@"user_shares"] childByAppendingPath:[userDefaults valueForKey:@"uid"]] childByAppendingPath:gid] removeValueWithCompletionBlock:^(NSError *error, Firebase *ref){
                
            }];
        }];
    }
}
-(void)initiateQueryFriendsInGroupForGid:(NSString*)gid {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [[[[firebaseRootInstance childByAppendingPath:@"shares"] childByAppendingPath:gid] childByAppendingPath:@"users"] observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot){
            
        }];
}
-(void)updateLocation:(NSString *)gid longitude:(NSNumber*)longitude latitude:(NSNumber*)latitude accuracy:(NSNumber*)accuracy {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *paramsDict = [[NSDictionary alloc] initWithObjectsAndKeys:longitude,@"longitude",latitude, @"latitude",accuracy,@"accuracy", nil];
    [[[[[firebaseRootInstance childByAppendingPath:@"shares"] childByAppendingPath:gid] childByAppendingPath:@"users"] childByAppendingPath:[userDefaults valueForKey:@"uid"]] updateChildValues:paramsDict withCompletionBlock:^(NSError *error, Firebase *ref) {
        
    }];
}
-(void)leaveGroupShare:(NSString *)gid {

}
-(void)initialGroupsSnapshotRecieved:(FDataSnapshot*)snapshot {
    if([snapshot value] == [NSNull null]) {
        return;
    }
    [delegate didRecieveInitialGroupsSnapshot:[(NSDictionary*)[snapshot value] allKeys]];
    for(NSString *gid in [[snapshot value] allKeys]) {
        [self configureToListenForChangesOnGroup:gid];
    }
}

// Not used. Will be removed. Location stuff happens in the LocationManager system
-(void)addListenerForGroup:(NSString*)gid {
    
}

-(void)configureToListenForChangesOnGroup:(NSString*)gid {
    [[[firebaseRootInstance childByAppendingPath:@"shares"] childByAppendingPath:gid] observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot* snapshot){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fbLocationChanged" object:[snapshot value]];
    }];
}
@end
