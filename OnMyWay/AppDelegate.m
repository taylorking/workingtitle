//
//  AppDelegate.m
//  OnMyWay
//
//  Created by Taylor King on 8/25/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize timer;
@synthesize locationManager, currentLocation;
@synthesize mainObjectContext;

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ConnectionInfo" ofType:@"plist"];
    NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    [GMSServices provideAPIKey:[settingsDictionary objectForKey:@"mapsApiKey"]];
    //Setup location services
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [locationManager setDelegate:self];
    ;
    
    //Setup core data
    NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:@"OMDataModel" withExtension:@"xcdatamodel"];
    NSManagedObjectModel *objectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    
    mainObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:objectModel];
    [mainObjectContext setPersistentStoreCoordinator:coordinator];
    
    return TRUE;
}
- (void)stopSharingLocation {
    [locationManager stopUpdatingLocation];
    [timer invalidate];
}
-(void)startSharingLocation {
    [locationManager startUpdatingLocation];
    timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(sendLocationTimerTicked:) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}
#pragma mark - UIAlertView Delegates 
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [locationManager requestAlwaysAuthorization];
}
#pragma mark - Location Manager Delegates
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status != kCLAuthorizationStatusAuthorizedAlways) {
        UIAlertView *permissionsAlert = [[UIAlertView alloc] initWithTitle:@"This app requires your location" message:@"Please authorize OnMyWay to use your location" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [permissionsAlert show];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationManagerRecievedNewLocation" object:locations userInfo:nil];
    currentLocation = [locations lastObject];
}

#pragma mark - Timer Delegates
-(void)sendLocationTimerTicked:(NSNotification*)notification {
    if(currentLocation) {
    NSLog([NSString stringWithFormat:@"location:\nlatitude:%f\tlongitude:%f", [currentLocation coordinate].latitude, [currentLocation coordinate].longitude]);
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
