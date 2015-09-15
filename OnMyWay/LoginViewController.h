//
//  LoginViewController.h
//  OnMyWay
//
//  Created by Taylor King on 9/7/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFPaperView.h"
#import "AppDelegate.h"
@interface LoginViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>;

@property (weak, nonatomic) IBOutlet UICollectionView *authenticationCollectionView;
@property (weak, nonatomic) IBOutlet BFPaperView *loginButton;
@property (weak, nonatomic) IBOutlet BFPaperView *registerButton;
@property (weak, nonatomic) IBOutlet BFPaperView *loginPanel;
@property (strong,nonatomic) NSArray *authenticationMethods, *authenticationIcons;

@property (strong, nonatomic) AppDelegate *appDelegate;
@end
