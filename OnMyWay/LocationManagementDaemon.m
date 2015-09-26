//
//  LocationManagementDaemon.m
//  OnMyWay
//
//  Created by Taylor King on 9/23/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import "LocationManagementDaemon.h"

@implementation LocationManagementDaemon
@synthesize locationManager;
-(LocationManagementDaemon*)init {
    self = [super init];
    NSString *plistPath = CONNECTION_INFO;
    NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    [GMSServices provideAPIKey:[settingsDictionary valueForKey:@"mapsApiKey"]];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    return self;
    
}
-(void)startPolling {
    [locationManager requestAlwaysAuthorization];
    [locationManager startMonitoringSignificantLocationChanges];
}
-(void)stopPolling {
    [locationManager stopMonitoringSignificantLocationChanges];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"lmdLocationUpdate" object:location];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}
-(CLLocation*)getCurrentLocationOneTime {
    return nil;
}
@end
