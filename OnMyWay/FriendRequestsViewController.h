//
//  FriendRequestsViewController.h
//  OnMyWay
//
//  Created by Taylor King on 9/24/15.
//  Copyright © 2015 omwltd. All rights reserved.
//
#import "macros.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@interface FriendRequestsViewController : UITableViewController<UITableViewDataSource,UITableViewDataSource>
@property (strong, nonatomic) AppDelegate *appDelegate;
@end
