//
//  LoginViewController.h
//  OnMyWay
//
//  Created by Taylor King on 9/23/15.
//  Copyright © 2015 omwltd. All rights reserved.
//
#import "macros.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h" 

@interface LoginViewController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIView *dataLoadingView;

- (IBAction)loginButtonPressed:(id)sender;


@end
