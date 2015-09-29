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
@synthesize userNameField, passwordField;
@synthesize dataLoadingView;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:@"didCompleteInitialContactLoad"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginWasSuccessful) name:@"fbUserDidCompleteLogin" object:nil];
    if([userDefaults objectForKey:@"password"]) {
        [passwordField setText:[userDefaults valueForKey:@"password"]];
    }
    if([userDefaults objectForKey:@"email"]) {
        [userNameField setText:[userDefaults valueForKey:@"email"]];
    }
    // Do any additional setup after loading the view.
    [userDefaults setValue:@"kingtb" forKey:@"username"];
    [[self navigationController] setNavigationBarHidden:true];
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
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];


}
-(void)loginWasSuccessful {

    [self performSegueWithIdentifier:@"segueToMasterContainerView" sender:nil];
}
- (IBAction)loginButtonPressed:(id)sender {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *randomUserName = [[NSMutableString alloc] init];
    for(int i = 0; i < 16; i++) {
        [randomUserName appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform([letters length])]];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[userNameField text] forKey:@"email"];
    [defaults setValue:[passwordField text] forKey:@"password"];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [dataLoadingView setHidden:false];
    [appDelegate loginWithFirebase:[userNameField text] password:[passwordField text] userName:@"kingtb"];
}
@end
