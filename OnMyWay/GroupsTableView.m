//
//  GroupsTableView.m
//  OnMyWay
//
//  Created by Taylor King on 10/7/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import "GroupsTableView.h"

@implementation GroupsTableView
@synthesize appDelegate;
NSDictionary *tableViewCells;
-(GroupsTableView*)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setDelegate:self];
    [self setBackgroundColor:LIGHTSECONDARY_COLOR];
    [self setDataSource:self];
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setRowHeight:250];
    appDelegate = [[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"lmInitialGroupsRecieved" object:nil];
    return self;
}
-(void)reloadTableView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[[appDelegate locationsManagement] groupDescriptions] allKeys] count];
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return false;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *gid = [[[[appDelegate locationsManagement] groupDescriptions] allKeys] objectAtIndex:[indexPath row]];
    if([tableViewCells valueForKey:gid]) {
        return [tableViewCells valueForKey:gid];
    } else {
        GroupTableViewCell *cell = [[GroupTableViewCell alloc] initWithFrame:CGRectMake(0,0,W(self),250) group:gid];

        [tableViewCells setValue:cell forKey:gid];
        return cell;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *gid = [(GroupTableViewCell*)[[collectionView superview] superview] cellGid];
    NSDictionary *group = [[[appDelegate locationsManagement] groupDescriptions]valueForKey:gid];
    
    NSDictionary *user = [group valueForKey:[[group allKeys] objectAtIndex:[indexPath row]]];
    NSString *uid = [[group allKeys] objectAtIndex:[indexPath row]];
    NSString *identifier = @"headCell";

        UINib *nib = [UINib nibWithNibName:@"HeadCollectionViewCell" bundle:nil];
        [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
      HeadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if(![user valueForKey:@"avatar"]) {
        [[cell roundView] setCornerRadius:45/2.0];
        [[cell roundView] setBackgroundColor:[AppDelegate colorForUsername:[user valueForKey:@"username"]]];
        [[cell imageView] setHidden:true];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];

        [label setText:[(NSString*)[user valueForKey:@"username"] substringToIndex:1]];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:PROXIMA_NOVA(24)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [[cell roundView] addSubview:label];
    }

    return cell;
}
@end
