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
@property (strong, nonatomic) NSArray *groups;
@property (strong, nonatomic) NSDictionary* groupDescriptions;
@property (strong, nonatomic) LocationManagementDaemon *updaterDaemon;
@property (strong, nonatomic) NSString *selectedGroup;
@property (strong, nonatomic) Location *currentLocation;

-(LocationManagement*)initWithManagedObjectContext:(NSManagedObjectContext*)objectContext andFirebaseCore:(FirebaseCore*)firebaseCore;
-(void)publishLocationToActiveGroups:(Location*)location;
-(Location*)getWriteableLocation;
-(void)initiatePopulationOfShareTargets;
-(void)createAShare:(NSArray*)users;
@end
