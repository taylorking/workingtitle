//
//  FriendSearchViewController.h
//  OnMyWay
//
//  Created by Taylor King on 9/23/15.
//  Copyright © 2015 omwltd. All rights reserved.
//
#import "macros.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@interface FriendSearchViewController : UIViewController<UISearchResultsUpdating, UISearchDisplayDelegate, UISearchBarDelegate, UISearchControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) AppDelegate *appDelegate;
@end
