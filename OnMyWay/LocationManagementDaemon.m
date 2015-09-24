//
//  LocationManagementDaemon.m
//  OnMyWay
//
//  Created by Taylor King on 9/23/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import "LocationManagementDaemon.h"

@implementation LocationManagementDaemon
static float dummyLatitude = 36.216710;
static float dummyLongitude =-81.679128;
-(LocationManagementDaemon*)initWithManagedObjectContext:(NSManagedObjectContext*)objectContext {
    self = [super init];
    [self setMainObjectContext:objectContext];
    return self;
}
-(CLLocation*)getCurrentLocationOneTime {
    return nil;
}
@end
