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

@synthesize mainObjectContext;
@synthesize shareTargets;
@synthesize contactsManagement;
@synthesize fbCore;
@synthesize temporaryObjectContext;
@synthesize contactDataReady;
@synthesize locationsManagement;
@synthesize numberOfFriendRequests;
@synthesize numberOfShareRequests;
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    numberOfShareRequests = 0, numberOfFriendRequests = 0;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ConnectionInfo" ofType:@"plist"];
    NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
   
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
    
    temporaryObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    databaseName = (NSString*)[settingsDictionary valueForKey:@"tempDatabaseName"];
    databaseUrl = [NSURL fileURLWithPath:[documentPath stringByAppendingPathComponent:databaseName]];
    [temporaryObjectContext setPersistentStoreCoordinator:[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:objectModel]];
    [[temporaryObjectContext persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:databaseUrl options:nil error:&error];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fireBaseSuccessfullyRetrievedUid) name:@"fbUserDidCompleteLogin" object:nil];

    //Setup OAuth


    
    //Setup contacts management
        //Setup firebase
    
    return true;
}
-(void)loginWithFirebase:(NSString*)email password:(NSString*)password userName:(NSString*)userName {
    fbCore = [[FirebaseCore alloc] initWithEmail:email password:password username:userName];
}

#pragma mark - Firebase auth delegates
-(void)fireBaseSuccessfullyRetrievedUid {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userCompletedLogin) name:@"contactDataReady" object:nil];
    contactsManagement = [[ContactsManagement alloc] initWithManagedObjectContext:mainObjectContext tempObjectContext:temporaryObjectContext andFirebaseCore:fbCore];
    locationsManagement = [[LocationManagement alloc] initWithManagedObjectContext:temporaryObjectContext andFirebaseCore:fbCore];
}
#pragma mark - Database interaction

-(void)userCompletedLogin {
    contactDataReady  = true;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // Throttle Down location updates
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
