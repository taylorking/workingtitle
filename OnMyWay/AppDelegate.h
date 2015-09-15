//
//  AppDelegate.h
//  OnMyWay
//
//  Created by Taylor King on 8/25/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "JTAlertView.h"
#import <UIKit/UIKit.h>
#import "Contact.h"
#import "ContactsManagement.h" 
#import "OAuthSystem.h"
#import "FirebaseRegistration.h"

@import GoogleMaps;

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong,nonatomic) CLLocation *firstLocation;
@property (strong, nonatomic) NSManagedObjectContext *mainObjectContext;
@property (strong,nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *shareTargets;
@property (strong, nonatomic) ContactsManagement *contactsManagement;
@property (strong, nonatomic) OAuthSystem *oauth;

@property (strong, nonatomic) UIImage *profileImage;


// Perhaps this needs to be thought about.. We really need to think about what we want to keep locally.
@property (strong, nonatomic) FirebaseRegistration *remoteDatabase;

-(void)startSharingLocation;
-(void)stopSharingLocation;
-(void)setTimeoutMinutes:(int)minutes;
-(void)userCompletedLoginWithUsername:(NSString*)userName userToken:(NSString*)userToken;

@property (strong,nonatomic) NSTimer *timer;


@end

