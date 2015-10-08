//
//  FirebaseLocationPublishing.h
//  OnMyWay
//
//  Created by Taylor King on 9/23/15.
//  Copyright © 2015 omwltd. All rights reserved.
//
#import "macros.h"
#import <Firebase/Firebase.h>
#import <Foundation/Foundation.h>
#import "FirebaseCore.h"
@protocol FirebaseLocationPublishingDelegate
-(void)didRecieveMemberGroupSnapshot:(NSDictionary*)snapshot;
-(void)didRecieveGroupInformation:(NSDictionary*)info forGroup:(NSString*)gid;
@end
@interface FirebaseLocationPublishing : NSObject
@property (strong, nonatomic) Firebase *firebaseRootInstance;
@property (strong, nonatomic) NSDictionary *groups;
@property (strong, nonatomic) id<FirebaseLocationPublishingDelegate> delegate;
-(FirebaseLocationPublishing*)initWithFirebaseCore:(FirebaseCore*)firebaseCore;
-(void)startSharingWithGroup:(NSString*)gid;
-(void)stopSharingWithGroup:(NSString*)gid;
-(void)deleteShare:(NSString*)gid;
-(void)leaveGroupShare:(NSString*)gid;

-(void)updateLocation:(NSString*)gid longitude:(NSNumber*)longitude latitude:(NSNumber*)latitude accuracy:(NSNumber*)accuracy;
-(void)createShare:(NSDictionary*)parameters;
-(void)configureToListenForChangesOnGroup:(NSString*)gid;
-(void)initiateQueryFriendsInGroupForGid:(NSString*)gid;
-(void)deleteAllMemberShares:(NSArray*)shares;
@end
