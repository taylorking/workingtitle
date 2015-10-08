//
//  LocationManagement.h
//  OnMyWay
//
//  Created by Taylor King on 9/23/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirebaseLocationPublishing.h"
#import "LocationManagementDaemon.h"
#import "FirebaseCore.h"
#import "Location.h"
#import "Contact.h"
@import  GoogleMaps;

@interface LocationManagement : NSObject<FirebaseLocationPublishingDelegate>
@property (strong, nonatomic) NSManagedObjectContext *tempObjectContext;
@property (strong, nonatomic) FirebaseLocationPublishing *locationPublishing;
@property (strong, nonatomic) FirebaseCore *firebaseCoreRef;
@property (strong, nonatomic) NSMutableArray *unacceptedGroups, *acceptedGroups;
@property (strong, nonatomic) NSMutableDictionary* groupDescriptions;
@property (strong, nonatomic) LocationManagementDaemon *updaterDaemon;
@property (strong, nonatomic) Location *currentLocation;
@property (strong, nonatomic) NSMutableSet *totalGroups;
-(LocationManagement*)initWithManagedObjectContext:(NSManagedObjectContext*)objectContext andFirebaseCore:(FirebaseCore*)firebaseCore;
-(void)publishLocationToActiveGroups:(Location*)location;
-(Location*)getWriteableLocation;
-(void)initiatePopulationOfShareTargets;
-(void)createAShare:(NSArray*)users;
-(void)stopSharingWithGroup:(NSString*)gid;
-(void)startSharingWithGroup:(NSString*)gid;
-(void)pauseFirebaseListeners;
-(void)resumeFirebaseListeners;
@end
