//
//  MasterContainerViewController.h
//  OnMyWay
//
//  Created by Taylor King on 9/8/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//
#import "BFPaperView.h"
#import "NavigationTabBarController.h"
#import "OnMyWay-Swift.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HamburgerViewController.h" 

@interface MasterContainerViewController : UIViewController
@property (weak, nonatomic) IBOutlet BFPaperView *headerView;
@property (weak, nonatomic) NavigationTabBarController *childViewController;

@property (weak, nonatomic) IBOutlet HamburgerButton *hamburgerButton;
@property (strong, nonatomic) BFPaperView *hamburgerMenu;
@property (strong, nonatomic) BFPaperView *paperView;
@property (strong, nonatomic) BFPaperView *headView;

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet BFPaperView *mainButton;
@property (weak, nonatomic) IBOutlet UIImageView *buttonIcon;
@property (strong, nonatomic) UIWindow *hamburgerWindow;
@property (strong, nonatomic) AppDelegate *appDelegate;
- (IBAction)mainButtonPressed:(id)sender;
- (IBAction)didTapMainView:(id)sender;
@end
