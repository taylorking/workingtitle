//
//  MasterContainerViewController.h
//  OnMyWay
//
//  Created by Taylor King on 9/8/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//
#import "BFPaperView.h"
#import "NavigationTabBarController.h"
#import "macros.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CustomBadge/CustomBadge.h"
@protocol HamburgerMenuDelegate
-(void)didPromptForSegueToFriendRequests;
-(void)didPromptForSegueToMapViewWithGroupId:(NSString*)gid;
-(void)didPromptForSegueToSettings;
@end

@interface HamburgerMenuContents:UITableView<UITableViewDataSource, UITableViewDelegate>
-(HamburgerMenuContents*)initWithFrame:(CGRect)frame;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) id<HamburgerMenuDelegate> controllerDelegate;
@property (strong, nonatomic) UILabel *friendRequestsLabel;
@property (strong, nonatomic) CustomBadge *friendRequestsBadge;
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface MasterContainerViewController : UIViewController<UIGestureRecognizerDelegate, HamburgerMenuDelegate>
@property (weak, nonatomic) IBOutlet BFPaperView *headerView;
@property (weak, nonatomic) NavigationTabBarController *childViewController;
@property (weak, nonatomic) IBOutlet UIButton *hamburgerButton;

@property (strong, nonatomic) CustomBadge *hamburgerButtonBadge;
@property (strong, nonatomic) BFPaperView *hamburgerMenu;
@property (strong, nonatomic) BFPaperView *paperView;
@property (strong, nonatomic) BFPaperView *headView;
@property (strong, nonatomic) HamburgerMenuContents *hamburgerContents;
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
