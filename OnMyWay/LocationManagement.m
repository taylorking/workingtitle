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
@synthesize groupDescriptions;
@synthesize currentLocation;
-(LocationManagement*)initWithManagedObjectContext:(NSManagedObjectContext *)objectContext andFirebaseCore:(FirebaseCore *)firebaseCore {
    self = [super init];
    updaterDaemon = [[LocationManagementDaemon alloc] init];
    groups = [[NSMutableArray alloc] init];
    [self setTempObjectContext:objectContext];
    [self setFirebaseCoreRef:firebaseCore];
    locationPublishing = [[FirebaseLocationPublishing alloc] initWithFirebaseCore:firebaseCore];
    [locationPublishing setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initialGroupsLoaded) name:@"fbInitialGroupsAvailable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myLocationChanged:) name:@"lmdLocationUpdate" object:nil];

    return self;
}
-(void)createAShare:(NSArray*)users {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //I didn't do this with a map because I'm not a faggot like jon
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    for(Contact *contact in users) {
        NSMutableDictionary *userObject = [[NSMutableDictionary alloc] init];
        [userObject setValue:[contact userName] forKey:@"username"];
        [userDictionary setValue:userObject forKey:[contact uid]];
    }
    NSMutableDictionary *myObject = [[NSMutableDictionary alloc] init];
    [userDictionary setValue:[NSDictionary dictionaryWithObjectsAndKeys:[defaults valueForKey:@"username"], @"username",nil] forKey:[defaults valueForKey:@"uid"]];
    [myObject setValue:userDictionary forKey:@"users"];
    [myObject setValue:[defaults valueForKey:@"username"] forKey:@"creator"];
    [locationPublishing createShare:myObject];

}
-(void)myLocationChanged:(NSNotification*)notification {
    // send to all the groups and draw on the map
    CLLocation *location = (CLLocation*)[notification object];
    for(NSString *gid in groups) {
        [locationPublishing updateLocation:gid longitude:[NSNumber numberWithFloat:[location coordinate].longitude] latitude:[NSNumber numberWithFloat:[location coordinate].latitude] accuracy:[NSNumber numberWithFloat:0]];
    }
    currentLocation = [self getWriteableLocation];
    [currentLocation setLatitude:[NSNumber numberWithFloat:[location coordinate].latitude]];
    [currentLocation setLongitude:[NSNumber numberWithFloat:[location coordinate].longitude]];
    [currentLocation setTime:[NSDate date]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"lmCurrentUserLocationChange" object:nil];
    
}
-(void)initiateSearchForUserLocations {
    
}

-(void)didRecieveInitialGroupsSnapshot:(NSArray *)snapshot {
    groups = snapshot;
    [self getDescriptiveGroupInformation];
}
-(void)getDescriptiveGroupInformation {
    for(NSString *gid in groups) {
        NSMutableArray *users = [[NSMutableArray alloc] init];
        [locationPublishing initiateQueryFriendsInGroupForGid:gid];
    }
}
-(Location*)getWriteableLocation {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:tempObjectContext];
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:tempObjectContext];
    return (Location*)object;
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
