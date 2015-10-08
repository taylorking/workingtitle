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
    [[[firebaseRootInstance childByAppendingPath:@"user_shares"] childByAppendingPath:[defaults valueForKey:@"uid"]] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot){
        [self memberGroupSnapshotRecieved:snapshot];
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
        for(NSString *user in (NSDictionary*)[parameters valueForKey:@"users"]) {
            if(![user isEqualToString:[defaults valueForKey:@"uid"]]) {
                [[[[firebaseRootInstance childByAppendingPath:@"user_shares"] childByAppendingPath:user] childByAppendingPath:[ref key]] setValue:[NSNumber numberWithBool:false] withCompletionBlock:^(NSError *err, Firebase *ref) {
                    if (!error) {
                        
                    }
                }];
            }
        }
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
        [[[firebaseRootInstance childByAppendingPath:@"shares"] childByAppendingPath:gid] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot* snapshot){
            [delegate didRecieveGroupInformation:[snapshot value] forGroup:[snapshot key]];
        }];
}
-(void)updateLocation:(NSString *)gid longitude:(NSNumber*)longitude latitude:(NSNumber*)latitude accuracy:(NSNumber*)accuracy {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *paramsDict = [[NSDictionary alloc] initWithObjectsAndKeys:longitude,@"longitude",latitude, @"latitude",accuracy,@"accuracy",[userDefaults valueForKey:@"username"],@"username",nil];
    [[[[[firebaseRootInstance childByAppendingPath:@"shares"] childByAppendingPath:gid] childByAppendingPath:@"users"] childByAppendingPath:[userDefaults valueForKey:@"uid"]] updateChildValues:paramsDict withCompletionBlock:^(NSError *error, Firebase *ref) {
        
    }];
}
-(void)leaveGroupShare:(NSString *)gid {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [[[[firebaseRootInstance childByAppendingPath:@"user_shares"] childByAppendingPath:[userDefaults valueForKey:@"uid"]] childByAppendingPath:gid] removeValueWithCompletionBlock:^(NSError *error, Firebase *ref) {
        [[[[[firebaseRootInstance childByAppendingPath:@"shares"] childByAppendingPath:gid] childByAppendingPath:@"users"] childByAppendingPath:[userDefaults valueForKey:@"uid"]] removeValueWithCompletionBlock:^(NSError *error, Firebase *ref) {
            
        }];
    }];
}
-(void)startSharingWithGroup:(NSString *)gid {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[[firebaseRootInstance childByAppendingPath:@"user_shares"] childByAppendingPath:[defaults valueForKey:@"uid"]] setValue:[NSNumber numberWithBool:true] forKey:gid];
}
-(void)stopSharingWithGroup:(NSString *)gid {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[[firebaseRootInstance childByAppendingPath:@"user_shares"] childByAppendingPath:[defaults valueForKey:@"uid"]] setValue:[NSNumber numberWithBool:false] forKey:gid];
}
-(void)memberGroupSnapshotRecieved:(FDataSnapshot*)snapshot {
    if([snapshot value] == [NSNull null]) {
        return;
    }
    [delegate didRecieveMemberGroupSnapshot:[snapshot value]];
    for(NSString *gid in [[snapshot value] allKeys]) {
        if([[snapshot value] valueForKey:gid] == [NSNumber numberWithBool:false]) {
            
        } else {
            [self configureToListenForChangesOnGroup:gid];
        }
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
