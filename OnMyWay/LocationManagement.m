//
//  LocationManagement.m
//  OnMyWay
//
//  Created by Taylor King on 9/23/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import "LocationManagement.h"

@implementation LocationManagement

@synthesize tempObjectContext, firebaseCoreRef;
@synthesize locationPublishing;
@synthesize groups;
@synthesize updaterDaemon;
@synthesize selectedGroup;
-(LocationManagement*)initWithManagedObjectContext:(NSManagedObjectContext *)objectContext andFirebaseCore:(FirebaseCore *)firebaseCore {
    self = [super init];
    updaterDaemon = [[LocationManagementDaemon alloc] init];
    groups = [[NSMutableArray alloc] init];
    [self setTempObjectContext:objectContext];
    [self setFirebaseCoreRef:firebaseCore];
    locationPublishing = [[FirebaseLocationPublishing alloc] initWithFirebaseCore:firebaseCore];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initialGroupsLoaded) name:@"fbInitialGroupsAvailable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myLocationChanged:) name:@"lmdLocationUpdate" object:nil];

    return self;
}
-(void)createAShare:(NSArray*)users {
    //I didn't do this with a map because I'm not a faggot like jon
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    for(Contact *contact in users) {
        NSMutableDictionary *userObject = [[NSMutableDictionary alloc] init];
        [userObject setValue:[contact userName] forKey:@"username"];
        [userDictionary setValue:userObject forKey:[contact uid]];
    }
    NSMutableDictionary *myObject = [[NSMutableDictionary alloc] init];
    [locationPublishing createShare:userDictionary];
}
-(void)myLocationChanged:(NSNotification*)notification {
    // send to all the groups and draw on the map
    CLLocation *location = (CLLocation*)[notification object];
    for(NSString *gid in groups) {
        [locationPublishing updateLocation:gid longitude:[NSNumber numberWithFloat:[location coordinate].longitude] latitude:[NSNumber numberWithFloat:[location coordinate].latitude] accuracy:[NSNumber numberWithFloat:0]];
    }
    
}
-(void)initiatePopulationOfShareTargets {
    
}
-(void)initialGroupsLoaded {
    if([locationPublishing groups] != [NSNull null]) {
         groups = [[locationPublishing groups] allKeys];
    }
    for(NSString *key in groups) {
        [locationPublishing configureToListenForChangesOnGroup:key];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"lmInitialGroupsRecieved" object:nil];
}


@end
