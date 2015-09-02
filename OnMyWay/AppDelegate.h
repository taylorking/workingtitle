//
//  AppDelegate.h
//  OnMyWay
//
//  Created by Taylor King on 8/25/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//
#import <Google/CloudMessaging.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@import GoogleMaps;

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong,nonatomic) CLLocation *firstLocation;
@property (strong, nonatomic) NSManagedObjectContext *mainObjectContext;
@property (strong,nonatomic) UIWindow *window;
-(void)startSharingLocation;
-(void)stopSharingLocation;
@property (strong,nonatomic) NSTimer *timer;
@end

