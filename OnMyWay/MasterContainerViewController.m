//
//  MasterContainerViewController.m
//  OnMyWay
//
//  Created by Taylor King on 9/8/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//

#import "MasterContainerViewController.h"

@interface MasterContainerViewController ()

@end

@implementation MasterContainerViewController
@synthesize hamburgerMenu;

@synthesize headerView, childViewController, mainButton, buttonIcon, mainLabel, hamburgerWindow, headView, dataLoadingView;
@synthesize appDelegate, tapGestureRecognizer;
@synthesize hamburgerContents;
@synthesize hamburgerButton, hamburgerButtonBadge;
BOOL buttonIsHamburger = true;
BOOL hamburgerMenuIsOpen;
- (void)viewDidLoad {
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [super viewDidLoad];

    [headerView setLiftedShadowRadius:4];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(morphBackToHamburgerButton:) name:@"navigationBackPressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(morphHamburgerButtonToBack:) name:@"pastRootViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fadeOutHamburgerMenuToLeft) name:@"hamburgerMenuNeedsClosing" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLabel:) name:@"viewControllerChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidFinishLoading) name:@"cmContactReloadNeeded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidFinishLoading) name:@"cmContactsAreEmpty" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupsAreAvailable) name:@"lmInitialGroupsRecieved" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendRequestDataAvailable) name:@"cmFriendRequestsAvailable" object:nil];
    [headerView setTapCircleDiameter:0];
    [headerView setTapCircleBurstAmount:0];
    [headerView setRippleFromTapLocation:false];
    [headerView setBackgroundColor:MAIN_COLOR];
    
    [[[self view] window] makeKeyAndVisible];
    [self setupHamburgerMenu];
}
#pragma mark - View setup methods
-(void)setupHamburgerMenu {
    int menuWidth = [[self view] frame].size.width;
    if(menuWidth > 375) {
        menuWidth = 375;
    }
    CGRect rect = CGRectMake(0, 0, menuWidth - 75, [[self view] frame].size.height);
    hamburgerWindow = [[UIWindow alloc] initWithFrame:rect];
    UIView *containerView = [[UIView alloc] initWithFrame:rect];
    hamburgerMenu = [[BFPaperView alloc] initWithFrame:rect];
    [containerView addSubview:hamburgerMenu];
    [hamburgerMenu setBackgroundColor:[UIColor whiteColor]];
    
    [hamburgerWindow setWindowLevel:UIWindowLevelStatusBar + 1];

    [hamburgerWindow setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,[hamburgerMenu frame].size.width, 100)];
    [headerImageView setImage:[UIImage imageNamed:@"materialHeader.png"]];
    [headerImageView setContentMode:UIViewContentModeScaleAspectFill];

    [hamburgerMenu setRippleFromTapLocation:false];
    [hamburgerMenu setTapCircleDiameter:0];
    [hamburgerMenu setTapCircleBurstAmount:0];
    [hamburgerMenu addSubview:headerImageView];
    hamburgerContents = [[HamburgerMenuContents alloc] initWithFrame:CGRectMake(0,[headerImageView frame].size.height,[hamburgerMenu frame].size.width,[hamburgerMenu frame].size.height - [headerImageView frame].size.height)];
    [hamburgerContents setControllerDelegate:self];
    [hamburgerMenu addSubview:hamburgerContents];
    [hamburgerWindow addSubview:containerView];
    headView = [[BFPaperView alloc] initWithFrame:CGRectMake(12, 12, 50, 50)];
    [headView setCornerRadius:25];
    [headView setIsRaised:false];
    [headView setClipsToBounds:true];
    UIImageView *personView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,50,50)];
    [personView setContentMode:UIViewContentModeScaleAspectFill];
    [personView setImage:[UIImage imageNamed:@"sampleImage.png"]];

    [headView addSubview:personView];
    [headerImageView addSubview:headView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidFinishLoading) name:@"contactDataReady" object:nil];
    if([appDelegate contactDataReady]) {
        [self dataDidFinishLoading];
    }
}
-(void)groupsAreAvailable {
    if(hamburgerContents) {
        [hamburgerContents reloadData];
    }
}
-(void)changeLabel:(NSNotification*)notification {
    [mainLabel setText:(NSString*)[notification object]];
}
-(void)morphHamburgerButtonToBack:(NSNotification*)notification {
    buttonIsHamburger = false;
}
-(void)morphBackToHamburgerButton:(NSNotification*)notification {
    buttonIsHamburger = true;
    
    
}

-(void)dataDidFinishLoading {
    [dataLoadingView setHidden:true];
}



#pragma mark - UIViewController Delegates
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    childViewController = [segue destinationViewController];
}

/*


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Hamburger Menu Methods
- (IBAction)mainButtonPressed:(id)sender {
    if(!buttonIsHamburger) {
        if(childViewController) {
            [childViewController goBack];
        }
    } else {
        [self fadeInHamburgerMenuFromLeft];
    }
}

-(void)fadeInHamburgerMenuFromLeft {
    [self setupHamburgerMenu];

    CGRect hamburgerFrame = [hamburgerWindow frame];
    float offset = [hamburgerWindow frame].origin.y - [hamburgerWindow frame].size.width;
    [hamburgerWindow setFrame:CGRectMake(offset, hamburgerFrame.origin.y, hamburgerFrame.size.width, hamburgerFrame.size.height)];
    [hamburgerWindow setHidden:false];
    [UIView animateWithDuration:.3f animations:^{
        [hamburgerWindow setFrame:hamburgerFrame];
    } completion:^(BOOL finished){
        if(finished) {
            hamburgerMenuIsOpen = true;
        }
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hamburgerMenuOpened" object:nil];
}
-(BOOL)shouldAutorotate {
    return true;
}
-(void)fadeOutHamburgerMenuToLeft {
    hamburgerMenuIsOpen = false;
    CGRect hamburgerFrame = [hamburgerWindow frame];
    float offset = [hamburgerWindow frame].origin.y - [hamburgerWindow frame].size.width;
    [UIView animateWithDuration:.3f animations:^{
        [hamburgerWindow setFrame:CGRectMake(offset, hamburgerFrame.origin.y, hamburgerFrame.size.width, hamburgerFrame.size.height)];
    } completion:^(BOOL finished) {
        [hamburgerWindow setHidden:true];
        [hamburgerWindow setFrame:hamburgerFrame];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hamburgerMenuClosed" object:nil];
    }];
}
-(void)fadeOutHamburgerMenuToLeft:(void(^)(void))extraBlock {
    hamburgerMenuIsOpen = false;
    CGRect hamburgerFrame = [hamburgerWindow frame];
    float offset = [hamburgerWindow frame].origin.y - [hamburgerWindow frame].size.width;
    [UIView animateWithDuration:.3f animations:^{
        [hamburgerWindow setFrame:CGRectMake(offset, hamburgerFrame.origin.y, hamburgerFrame.size.width, hamburgerFrame.size.height)];
    } completion:^(BOOL finished) {
        [hamburgerWindow setHidden:true];
        [hamburgerWindow setFrame:hamburgerFrame];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hamburgerMenuClosed" object:nil];
        extraBlock();
    }];
}
#pragma mark - HamburgerMenuDelegates
-(void)didPromptForSegueToFriendRequests {
    [self fadeOutHamburgerMenuToLeft:^{[childViewController goToFriendRequestsView];
    }];
}
-(void)didPromptForSegueToMapViewWithGroupId:(NSString *)gid {
    
}
-(void)didPromptForSegueToSettings {
    
}
-(void)friendRequestDataAvailable {
    [appDelegate setNumberOfFriendRequests:[[[appDelegate contactsManagement] incomingFriendRequests] count]];
    CustomBadge *friendRequestsBadge = [hamburgerContents friendRequestsBadge];
    if(friendRequestsBadge) {
        [friendRequestsBadge removeFromSuperview];
    }
    friendRequestsBadge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%lu", [appDelegate numberOfFriendRequests] + [appDelegate numberOfShareRequests]]];
    [friendRequestsBadge setUserInteractionEnabled:false];
    [hamburgerContents setFriendRequestsBadge:friendRequestsBadge];
    if([hamburgerContents friendRequestsLabel]) {
        [[hamburgerContents friendRequestsLabel] addSubview:friendRequestsBadge];
        [hamburgerContents reloadData];
    }
    if(hamburgerButtonBadge) {
        [hamburgerButtonBadge removeFromSuperview];
    }
    hamburgerButtonBadge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%lu", [appDelegate numberOfFriendRequests] + [appDelegate numberOfShareRequests]]];
    [hamburgerButtonBadge setUserInteractionEnabled:false];
    [hamburgerButton addSubview:hamburgerButtonBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[appDelegate numberOfFriendRequests] + [appDelegate numberOfShareRequests]];
}
#pragma mark - Tap Gesture Delegate
- (IBAction)didTapMainView:(id)sender {
    if(hamburgerMenuIsOpen) {
        [self fadeOutHamburgerMenuToLeft];
        [(UIGestureRecognizer*)sender cancelsTouchesInView];
    }
}
@end
@implementation HamburgerMenuContents
@synthesize appDelegate;
@synthesize friendRequestsLabel, friendRequestsBadge;
-(HamburgerMenuContents*)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setDataSource:self];
    [self setDelegate:self];
    [self setAllowsSelection:false];
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    appDelegate = [[UIApplication sharedApplication] delegate];
    return self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if([indexPath section] == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,[self frame].size.width, 40)];
        BFPaperView *paperView = [[BFPaperView alloc] initWithFrame:[cell frame]];
        [paperView setBackgroundColor:[UIColor whiteColor]];
        [paperView setIsRaised:false];
        friendRequestsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
        [friendRequestsLabel setText:@"Friend requests"];
        if(friendRequestsBadge) {
            [friendRequestsLabel addSubview:friendRequestsBadge];
        }
        [paperView addSubview:friendRequestsLabel];
        [cell addSubview:paperView];
        [friendRequestsLabel setFont:PROXIMA_NOVA(13)];
        [paperView setTapHandler:^(CGPoint point){
            [[self controllerDelegate] didPromptForSegueToFriendRequests];
        }];
        return cell;
    }
    else if([indexPath section] == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,[self frame].size.width,40)];
        UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,10,200,20)];
        [cellLabel setFont:PROXIMA_NOVA(13)];
        [cellLabel setText:[[[appDelegate locationsManagement] groups] objectAtIndex:[indexPath row]]];
        [cell addSubview:cellLabel];
        return cell;
  ;
    }
    else if([indexPath section] == 2) {
        UITableViewCell *cell =[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [self frame].size.width,40)];
        UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,10,200,20)];
        [cellLabel setFont:PROXIMA_NOVA(13)];
        [cellLabel setText:@"Settings"];
        [cell addSubview:cellLabel];
        return cell;
    }
    return nil;
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {

    return false;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section) {
        case 0:
            return 1;
        case 1:
            if([[appDelegate locationsManagement] groups]) {
                return [[[appDelegate locationsManagement] groups] count];
            }
            else {
                return 0;
            }
        case 2:
            return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;

    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [tableView frame].size.width, 10)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    return footerView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
@end