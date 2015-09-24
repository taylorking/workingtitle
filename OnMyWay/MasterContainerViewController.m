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
    [headerView setTapCircleDiameter:0];
    [headerView setTapCircleBurstAmount:0];
    [headerView setRippleFromTapLocation:false];
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
-(void)changeLabel:(NSNotification*)notification {
    [mainLabel setText:(NSString*)[notification object]];
}
-(void)morphHamburgerButtonToBack:(NSNotification*)notification {
    buttonIsHamburger = false;

    
    [hamburgerMenu setHidden:true];
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
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hamburgerMenuClosed" object:nil];
}
#pragma mark - Tap Gesture Delegate
- (IBAction)didTapMainView:(id)sender {
    if(hamburgerMenuIsOpen) {
        [self fadeOutHamburgerMenuToLeft];
        [(UIGestureRecognizer*)sender cancelsTouchesInView];
    }
}
@end