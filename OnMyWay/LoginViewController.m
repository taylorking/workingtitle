//
//  LoginViewController.m
//  OnMyWay
//
//  Created by Taylor King on 9/23/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // Do any additional setup after loading the view.
    [self performSegueWithIdentifier:@"segueToMasterContainerView" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
