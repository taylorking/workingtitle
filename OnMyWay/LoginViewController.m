//
//  LoginViewController.m
//  OnMyWay
//
//  Created by Taylor King on 9/7/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize loginButton, registerButton,loginPanel;
@synthesize appDelegate;
@synthesize authenticationMethods, authenticationIcons, authenticationCollectionView;
- (void)viewDidLoad {
    [super viewDidLoad];
    authenticationIcons = [[NSArray alloc] initWithObjects:@"google.png", @"facebook.png", @"microsoft.png", nil];
    authenticationMethods = [[NSArray alloc] initWithObjects:@"google", @"facebook", @"microsoft", nil];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [authenticationCollectionView setDataSource:self];
    [authenticationCollectionView setDelegate:self];
    [authenticationCollectionView reloadData];
    // Do any additional setup after loading the view.
    [registerButton setCornerRadius:4];
    [loginPanel setRippleFromTapLocation:false];
    [loginPanel setTapCircleDiameter:0];
    [loginPanel setTapCircleBurstAmount:0];
    [loginButton setRippleBeyondBounds:true];
    [loginButton setCornerRadius:4];
    [loginButton setTapHandler:^(CGPoint tap){
    [loginPanel setNeedsLayout];
    [self performSegueWithIdentifier:@"segueToMasterContainerView" sender:self];
    }];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *authenticationCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"authenticationCell" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,[authenticationCell frame].size.width, [authenticationCell frame].size.height)];
    [authenticationCell setClipsToBounds:true];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [[authenticationCell contentView] addSubview:imageView];
    [imageView setImage:[UIImage imageNamed:(NSString*)[authenticationIcons objectAtIndex:[indexPath row]]]];
    return authenticationCell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[appDelegate oauth] popMessageForProvider:(NSString*)[authenticationMethods objectAtIndex:[indexPath row]]];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [authenticationMethods count];
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
