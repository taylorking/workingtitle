//
//  MainMapShareViewController.h
//  OnMyWay
//
//  Created by Taylor King on 9/28/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macros.h"
#import "AppDelegate.h"
#import "BFPaperView.h"
#import "GroupsTableView.h"
#import "HeadsCollectionViewCellLarge.h"
@import GoogleMaps;


@interface MainMapShareViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate, GroupFilterDelegate>
@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) GMSMarker *userMarker;
@property (strong, nonatomic) NSMutableDictionary *friendMarkers;
@property (weak, nonatomic) IBOutlet UIScrollView *containerView;
@property (strong, nonatomic) UIView *headsPaperView;
@property (strong, nonatomic) GroupsTableView *groupsTableView;

- (IBAction)didSwipeUp:(id)sender;
- (IBAction)didSwipeDown:(id)sender;
@property (strong, nonatomic) UICollectionView *headsCollectionView;


@end
