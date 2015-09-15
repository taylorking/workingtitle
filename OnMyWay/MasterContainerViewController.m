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

@synthesize headerView, childViewController, mainButton, buttonIcon, mainLabel, hamburgerButton, hamburgerWindow, headView;
@synthesize appDelegate;
BOOL buttonIsHamburger = true;
- (void)viewDidLoad {
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [super viewDidLoad];
    [headerView setLiftedShadowRadius:4];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(morphBackToHamburgerButton:) name:@"navigationBackPressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(morphHamburgerButtonToBack:) name:@"pastRootViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fadeOutHamburgerMenuToLeft) name:@"hamburgerMenuNeedsClosing" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLabel:) name:@"viewControllerChanged" object:nil];
    [headerView setTapCircleDiameter:0];
    [headerView setTapCircleBurstAmount:0];
    [headerView setRippleFromTapLocation:false];
    [[[self view] window] makeKeyAndVisible];
    [self setupHamburgerMenu];
}
-(void)setupHamburgerMenu {
    int menuWidth = [[self view] frame].size.width;
    CGRect rect = CGRectMake(0, 0, menuWidth - 75, [[self view] frame].size.height);
    
    hamburgerWindow = [[UIWindow alloc] initWithFrame:rect];
    HamburgerViewController *hamburgerController = [[HamburgerViewController alloc] init];
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,[[self view] frame].size.width - 75, [[self view] frame].size.height)];
    hamburgerMenu = [[BFPaperView alloc] initWithFrame:CGRectMake(0, 0, [[self view] frame].size.width - 75, [[self view] frame].size.height)];
    [containerView addSubview:hamburgerMenu];
    [hamburgerMenu setBackgroundColor:[UIColor whiteColor]];
    [hamburgerController setView:containerView];
    [hamburgerWindow setWindowLevel:UIWindowLevelStatusBar + 1];
    [hamburgerWindow setRootViewController:hamburgerController];
    [hamburgerWindow setBackgroundColor:[UIColor clearColor]];

    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,[hamburgerMenu frame].size.width, 100)];
    [headerImageView setImage:[UIImage imageNamed:@"materialHeader.png"]];
    [headerImageView setContentMode:UIViewContentModeScaleAspectFill];

    [hamburgerMenu addSubview:headerImageView];
    headView = [[BFPaperView alloc] initWithFrame:CGRectMake(12, 12, 50, 50)];
    [headView setCornerRadius:25];
    [headView setIsRaised:false];
    [headView setClipsToBounds:true];
    UIImageView *personView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,50,50)];
    [personView setContentMode:UIViewContentModeScaleAspectFill];
    [personView setImage:[UIImage imageNamed:@"sampleImage.png"]];

    [headView addSubview:personView];
    [headerImageView addSubview:headView];
    
}
-(void)changeLabel:(NSNotification*)notification {
    [mainLabel setText:(NSString*)[notification object]];
}
-(void)morphHamburgerButtonToBack:(NSNotification*)notification {
    buttonIsHamburger = false;
    if([hamburgerButton showsMenu]) {
        [hamburgerButton setShowsMenu:false];
    }
    [hamburgerMenu setHidden:true];
}
-(void)morphBackToHamburgerButton:(NSNotification*)notification {
    buttonIsHamburger = true;
    if(![hamburgerButton showsMenu]) {
        [hamburgerButton setShowsMenu:true];
    }
}
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hamburgerMenuOpened" object:nil];
}
-(void)fadeOutHamburgerMenuToLeft {
    CGRect hamburgerFrame = [hamburgerWindow frame];
    float offset = [hamburgerWindow frame].origin.y - [hamburgerWindow frame].size.width;
    [UIView animateWithDuration:.3f animations:^{
        [hamburgerWindow setFrame:CGRectMake(offset, hamburgerFrame.origin.y, hamburgerFrame.size.width, hamburgerFrame.size.height)];
    } completion:^(BOOL finished) {
        [hamburgerWindow setHidden:true];
        [hamburgerWindow setFrame:hamburgerFrame];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hamburgerMenuClosed" object:nil];
}
- (IBAction)didTapMainView:(id)sender {
    [self fadeOutHamburgerMenuToLeft];
}

@end
