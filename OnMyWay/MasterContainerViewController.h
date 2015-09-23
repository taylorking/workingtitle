//
//  MasterContainerViewController.h
//  OnMyWay
//
//  Created by Taylor King on 9/8/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//
#import "BFPaperView.h"
#import "NavigationTabBarController.h"

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface MasterContainerViewController : UIViewController<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet BFPaperView *headerView;
@property (weak, nonatomic) NavigationTabBarController *childViewController;


@property (strong, nonatomic) BFPaperView *hamburgerMenu;
@property (strong, nonatomic) BFPaperView *paperView;
@property (strong, nonatomic) BFPaperView *headView;

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet BFPaperView *mainButton;
@property (weak, nonatomic) IBOutlet UIImageView *buttonIcon;
@property (strong, nonatomic) UIWindow *hamburgerWindow;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIView *dataLoadingView;
- (IBAction)mainButtonPressed:(id)sender;
- (IBAction)didTapMainView:(id)sender;
@end
