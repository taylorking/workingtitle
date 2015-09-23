//
//  ViewController.h
//  OnMyWay
//
//  Created by Taylor King on 8/25/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "Location.h"
#import "BFPaperView.h"
#import <CoreData/CoreData.h>
#import "NavigationTabBarController.h"
@import GoogleMaps;

@interface MainMapShareViewController : UIViewController<UIAlertViewDelegate>

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet BFPaperView *navigationHeaderView;

@property (weak, nonatomic) IBOutlet BFPaperView *contentCard;
@property (strong, nonatomic) UIScrollView *sharingWith;
@property (strong, nonatomic) GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet BFPaperView *pinpointButton;
@property (weak, nonatomic) IBOutlet UIImageView *pinpointIcon;
- (IBAction)swipeMapUp:(id)sender;
- (IBAction)swipeMapDown:(id)sender;

@end

