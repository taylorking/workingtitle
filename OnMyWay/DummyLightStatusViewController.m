//
//  DummyLightStatusViewController.m
//  OnMyWay
//
//  Created by Taylor King on 9/26/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import "DummyLightStatusViewController.h"

@interface DummyLightStatusViewController ()

@end

@implementation DummyLightStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
