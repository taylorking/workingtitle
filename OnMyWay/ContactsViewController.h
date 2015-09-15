//
//  ContactsViewController.h
//  OnMyWay
//
//  Created by Taylor King on 9/4/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "BFPaperView.h"
#import "math.h"
#import "NavigationTabBarController.h"
#import "AppDelegate.h"
#import "BFPaperCheckBox.h"
@interface ContactsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>



@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet BFPaperView *bottomBar;
@property (weak, nonatomic) IBOutlet BFPaperView *clockIcon;
@property (weak, nonatomic) IBOutlet UIView *clockHider;
@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;
@property (weak, nonatomic) NavigationTabBarController *parentController;
@property (weak, nonatomic) IBOutlet BFPaperView *addAContactButton;
- (IBAction)plusButtonPressed:(id)sender;
- (IBAction)viewTapped:(id)sender;

@end
