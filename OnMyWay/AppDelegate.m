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
@synthesize shareTargets;
@synthesize contactsManagement, oauth;
@synthesize remoteDatabase;

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

    NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:@"OMDataModel" withExtension:@"momd"];
    NSManagedObjectModel *objectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    mainObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];

    NSString *databaseName = (NSString*)[settingsDictionary valueForKey:@"databaseName"];
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *databaseUrl = [NSURL fileURLWithPath:[documentPath stringByAppendingPathComponent: databaseName]];
    NSError *error;
    [mainObjectContext setPersistentStoreCoordinator:[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:objectModel]];
    [[mainObjectContext persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:databaseUrl options:nil error:&error];
    
    //Setup OAuth
    oauth = [[OAuthSystem alloc] init];
    
    //Setup contacts management
    contactsManagement = [[ContactsManagement alloc] initWithManagedObjectContext:mainObjectContext];
    
    return true;
}
- (void)initializeShareTarget {
    
}

#pragma mark - Database interaction

-(void)userCompletedLoginWithUsername:(NSString*)userName userToken:(NSString*)userToken {
    remoteDatabase = [[FirebaseRegistration alloc] initWithUser:userName token:userToken];
}

#pragma mark - Location sharing control
- (void)stopSharingLocation {
    [locationManager stopUpdatingLocation];
    [timer invalidate];
}
-(void)startSharingLocation {
    if([shareTargets count] < 1) {
        return;
    }
    [locationManager startUpdatingLocation];
    timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(sendLocationTimerTicked:) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

-(void)setTimeoutMinutes:(int)minutes {
    
}
#pragma mark - Location Manager Delegates
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status != kCLAuthorizationStatusAuthorizedAlways) {
        JTAlertView *alertView = [[JTAlertView alloc] init];
        [alertView addButtonWithTitle:@"OK" font:[UIFont fontWithName:@"Proxima Nova" size:11] style:JTAlertViewStyleDefault forControlEvents:UIControlEventTouchUpInside action:^(JTAlertView *alertView){
            [alertView hide];
            [locationManager requestAlwaysAuthorization];
        }];
        [alertView show];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationManagerRecievedNewLocation" object:locations userInfo:nil];
    currentLocation = [locations lastObject];
}

#pragma mark - Timer Delegates
-(void)sendLocationTimerTicked:(NSNotification*)notification {

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
    NSError *error;
    [[self mainObjectContext] save:&error];
    
}

@end
