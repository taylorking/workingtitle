//
//  GroupsTableView.h
//  OnMyWay
//
//  Created by Taylor King on 10/7/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import "AppDelegate.h"
#import "GroupTableViewCell.h"
#import <UIKit/UIKit.h>

@interface GroupsTableView : UITableView<UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong,nonatomic) AppDelegate *appDelegate;
@property (strong,nonatomic) id<GroupFilterDelegate> filterDelegate;

-(GroupsTableView*)initWithFrame:(CGRect)frame;
@end
