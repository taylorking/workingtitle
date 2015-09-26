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

-(FirebaseLocationPublishing*)initWithFirebaseCore:(FirebaseCore *)firebaseCore {
    self = [super init];
    [self setFirebaseRootInstance:[firebaseCore firebaseRootInstance]];
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    [[[firebaseRootInstance childByAppendingPath:@"user_shares"] childByAppendingPath:[defaults valueForKey:@"uid"]] observeSingleEventOfType:  FEventTypeValue withBlock:^(FDataSnapshot *snapshot){
        [self initialGroupsSnapshotRecieved:snapshot];
    }];
    return self;

}
-(void)createShare:(NSDictionary*)parameters {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    Firebase *childRef = [[firebaseRootInstance childByAppendingPath:@"shares"] childByAutoId];
    [childRef setValue:[[NSDictionary alloc] initWithObjectsAndKeys:[defaults  valueForKey:@"username"], @"creator", nil] withCompletionBlock:^(NSError *error, Firebase *ref) {
        [[[[firebaseRootInstance childByAppendingPath:@"user_shares"] childByAppendingPath:[defaults valueForKey:@"uid"]] childByAppendingPath:[ref key]] setValue:[NSNumber numberWithBool:true] withCompletionBlock:^(NSError *error, Firebase *ref){
            if(!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"fbDidCreateNewShare" object:nil];
            }
        }];
    }];
}
-(void)initiateQueryFriendsInGroupForGid:(NSString*)gid {
    
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
    groups = [snapshot value];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fbInitialGroupsAvailable" object:nil];
}
-(void)addListenerForGroup:(NSString*)gid {
    
}
-(void)configureToListenForChangesOnGroup:(NSString*)gid {
    [[[firebaseRootInstance childByAppendingPath:@"shares"] childByAppendingPath:gid] observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot* snapshot){
    }];
}
@end
