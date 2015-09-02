//
//  ViewController.h
//  OnMyWay
//
//  Created by Taylor King on 8/25/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
#import "AppDelegate.h"
@import GoogleMaps;

@interface ViewController : UIViewController
@property (assign) BOOL sharing;
@property (weak, nonatomic) IBOutlet UIView *mapHolder;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
- (IBAction)shareButtonPressed:(id)sender;
@property (strong, nonatomic) GMSMapView *mapView;

@end

