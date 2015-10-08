//
//  LocationManagementDaemon.m
//  OnMyWay
//
//  Created by Taylor King on 9/23/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import "LocationManagementDaemon.h"

@implementation LocationManagementDaemon
@synthesize locationManager, locationTimer;
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
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    locationTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(locationManagerTimerTicked) userInfo:nil repeats:true];
}
-(void)stopPolling {
    [locationTimer invalidate];
    [locationManager stopMonitoringSignificantLocationChanges];
}
-(void)locationManagerTimerTicked {
    [locationManager startUpdatingLocation];
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
