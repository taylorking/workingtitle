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
@synthesize acceptedGroups, unacceptedGroups;
@synthesize updaterDaemon;
@synthesize totalGroups;
@synthesize groupDescriptions;
@synthesize currentLocation;
-(LocationManagement*)initWithManagedObjectContext:(NSManagedObjectContext *)objectContext andFirebaseCore:(FirebaseCore *)firebaseCore {
    self = [super init];
    updaterDaemon = [[LocationManagementDaemon alloc] init];
    unacceptedGroups = [[NSMutableArray alloc] init];
    acceptedGroups = [[NSMutableArray alloc] init];
    [self setTempObjectContext:objectContext];
    [self setFirebaseCoreRef:firebaseCore];
    locationPublishing = [[FirebaseLocationPublishing alloc] initWithFirebaseCore:firebaseCore];
    [locationPublishing setDelegate:self];
    groupDescriptions = [[NSMutableDictionary alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initialGroupsLoaded) name:@"fbInitialGroupsAvailable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myLocationChanged:) name:@"lmdLocationUpdate" object:nil];
    totalGroups = [[NSMutableSet alloc] init];
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
    for(NSString *gid in acceptedGroups) {
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

-(void)pauseFirebaseListeners {
   
}

-(void)startSharingWithGroup:(NSString*)gid {
    [locationPublishing stopSharingWithGroup:gid];
}
-(void)stopSharingWithGroup:(NSString*)gid {
    [locationPublishing startSharingWithGroup:gid];
}
-(void)addUserToShare:(NSString*)gid uid:(NSString*)uid {
    
}
-(void)getDescriptiveGroupInformation {
    groupDescriptions = [[NSMutableDictionary alloc] init];
    for (NSString *gid in acceptedGroups) {
        [locationPublishing initiateQueryFriendsInGroupForGid:gid];
    }
    for (NSString *gid in unacceptedGroups) {
        [locationPublishing initiateQueryFriendsInGroupForGid:gid];
    }
}
-(void)didRecieveGroupInformation:(NSDictionary *)info forGroup:(NSString *)gid {
    NSDictionary *users = [info valueForKey:@"users"];
    [groupDescriptions setValue:users forKey:gid];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"lmGroupDataChanged" object:gid];
}

-(Location*)getWriteableLocation {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:tempObjectContext];
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:tempObjectContext];
    return (Location*)object;
}

-(void)didRecieveMemberGroupSnapshot:(NSDictionary*)groupsSnapshot {
    acceptedGroups = [[NSMutableArray alloc] init];
    unacceptedGroups = [[NSMutableArray alloc] init];
    totalGroups = [[NSMutableSet alloc] init];
    for (NSString *gid in [groupsSnapshot allKeys]) {
        if ([groupsSnapshot valueForKey:gid] == [NSNumber numberWithBool:false]) {
            [unacceptedGroups addObject:gid];
        }
        else {
            [acceptedGroups addObject:gid];
        }
        [totalGroups addObject:gid];
    }
    [self getDescriptiveGroupInformation];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"lmInitialGroupsRecieved" object:nil];
}


@end
