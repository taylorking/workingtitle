//
//  GroupTableViewCell.h
//  OnMyWay
//
//  Created by Taylor King on 10/7/15.
//  Copyright © 2015 omwltd. All rights reserved.
//
#import "BFPaperCheckbox.h"
#import "BFPaperView.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "macros.h"
#import "HeadCollectionViewCell.h"
@protocol GroupFilterDelegate
-(void)deselectGroup:(NSString*)gid;
-(void)selectGroup:(NSString*)gid;
@end
@interface GroupTableViewCell : UITableViewCell
-(GroupTableViewCell*)initWithFrame:(CGRect)frame group:(NSString*)gid;
@property (strong,nonatomic) NSString *cellGid;
@property (strong,nonatomic) AppDelegate *appDelegate;
@property (strong,nonatomic) BFPaperView *paperContentView;
@property (strong, nonatomic) BFPaperCheckbox *selectedCheckbox;
@property (strong,nonatomic) id<GroupFilterDelegate> filterDelegate;
@property (strong, nonatomic) UIScrollView *usersScrollView;
@property (assign) BOOL cellNibLoaded;
@end
