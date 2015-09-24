//
//  LocationManagementDaemon.h
//  OnMyWay
//
//  Created by Taylor King on 9/23/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GoogleMaps;
@interface LocationManagementDaemon : NSObject<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSManagedObjectContext *mainObjectContext;
-(void)startSharingLocationWithTimeOutInterval:(float)timeOutInterval;
-(void)stopSharingLocation;
-(LocationManagementDaemon*)initWithManagedObjectContext:(NSManagedObjectContext*)objectContext;
@end
