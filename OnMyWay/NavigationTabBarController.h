//
//  CustomTabBarController.h
//  OnMyWay
//
//  Created by Taylor King on 9/8/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//
#import "macros.h"
#import <UIKit/UIKit.h>

@interface NavigationTabBarController : UITabBarController
-(void)goBack;
-(void)goToContactSearch;
-(void)goToMapView;
-(void)goToFriendRequestsView;
@end
