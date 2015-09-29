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
@import GoogleMaps;
@interface MainMapShareViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDataSource>
@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) GMSMarker *userMarker;
@property (strong, nonatomic) NSMutableDictionary *friendMarkers;
@property (weak, nonatomic) IBOutlet UICollectionView *headsCollectionView;
@end
