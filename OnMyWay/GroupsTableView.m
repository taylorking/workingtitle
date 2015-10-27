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
NSIndexPath *selectedCell;
-(GroupsTableView*)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setDelegate:self];
    [self setBackgroundColor:CARDVIEW_BGCOLOR];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(selectedCell != nil && [selectedCell row] == [indexPath row]) {
        return 500;
    } else {
        return 305;
    }
}
-(void)toggleSharing:(NSString *)gid {
    
}
-(void)expandCardAtIndexPath:(NSIndexPath *)path {
    selectedCell = path;
    [self beginUpdates];
    [self endUpdates];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *gid = [[[[appDelegate locationsManagement] groupDescriptions] allKeys] objectAtIndex:[indexPath row]];
    
    UINib *nib = [UINib nibWithNibName:@"GroupViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:@"groupCell"];
    GroupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell"];
    [cell setupWithGid:gid sharing:false indexPath:indexPath];
    [cell setBackgroundColor:CARDVIEW_BGCOLOR];
    [cell setDelegate:self];
    return cell;

}

-(void)leaveGroup:(NSString*)gid {
    
}
@end
