//
//  CustomTabBarController.m
//  OnMyWay
//
//  Created by Taylor King on 9/8/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//

#import "NavigationTabBarController.h"

@interface NavigationTabBarController ()

@end

@implementation NavigationTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack {
    // Segue back to the contacts list
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"navigationBackPressed" object:nil];
    [self animateBackwardsTransitionFromViewController:[self selectedViewController] toViewController:(UIViewController*)[[self viewControllers] objectAtIndex:0]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"viewControllerChanged" object:@"Contacts"];

}
#pragma mark - Animations
-(void)animateBackwardsTransitionFromViewController:(UIViewController*)currentViewController toViewController:(UIViewController*)destinationViewController {
    
    UIView *currentView = [currentViewController view];
    
    UIView *destinationView = [destinationViewController view];
    CGRect destFrame = [currentView frame];
    float offset = -destFrame.size.width;
    [[currentView superview] addSubview:destinationView];
    [destinationView setFrame:CGRectMake(offset, destFrame.origin.y, destFrame.size.width, destFrame.size.height)];
    [UIView animateWithDuration:.2f animations:^{
        [destinationView setFrame:CGRectMake(0,destFrame.origin.y, destFrame.size.width, destFrame.size.height)];
        //[currentView setFrame:CGRectMake(offset, destFrame.origin.y, destFrame.size.width, destFrame.size.height)];
    } completion:^(BOOL finished) {
        [currentView removeFromSuperview];
        [self setSelectedViewController:destinationViewController];
        
    }];
    
}
-(void)animateForwardTransitionFromViewController:(UIViewController*)currentViewController toViewController:(UIViewController*)destinationViewController {
    
    UIView *currentView = [currentViewController view];
    UIView *destinationView = [destinationViewController view];
    CGRect destFrame = [currentView frame];
    float offset = destFrame.size.width;

    [[currentView superview] addSubview:destinationView];
    [destinationView setFrame:CGRectMake(offset, destFrame.origin.y, destFrame.size.width, destFrame.size.height)];
    [UIView animateWithDuration:.2f animations:^{
        [destinationView setFrame:CGRectMake(0,destFrame.origin.y, destFrame.size.width, destFrame.size.height)];
        //[currentView setFrame:CGRectMake(offset, destFrame.origin.y, destFrame.size.width, destFrame.size.height)];
    } completion:^(BOOL finished) {
        [currentView removeFromSuperview];
        [self setSelectedViewController:destinationViewController];
    }];
}
- (void)goToContactSearch {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hamburgerMenuNeedsClosing" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pastRootViewController" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"viewControllerChanged" object:@"Search"];
    [self animateForwardTransitionFromViewController:[self selectedViewController] toViewController:(UIViewController*)[[self viewControllers] objectAtIndex:1]];

}
- (void)goToMapView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hamburgerMenuNeedsClosing" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pastRootViewController" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"viewControllerChanged" object:@"Map"];
    [self animateForwardTransitionFromViewController:[self selectedViewController] toViewController:(UIViewController*)[[self viewControllers] objectAtIndex:3]];
}
-(void)goToFriendRequestsView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hamburgerMenuNeedsClosing" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pastRootViewController" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"viewControllerChanged" object:@"Friend Requests"];
    [self animateForwardTransitionFromViewController:[self selectedViewController] toViewController:(UIViewController*)[[self viewControllers] objectAtIndex:2]];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
