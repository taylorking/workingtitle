//
//  GroupViewCell.m
//  OnMyWay
//
//  Created by Taylor King on 10/18/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import "GroupViewCell.h"

@implementation GroupViewCell
@synthesize gid;
@synthesize gidLabel;
@synthesize groupContentView;
@synthesize paperContentView;
@synthesize delegate;
@synthesize leaveGroupButton, stopSharingButton,stopSharingLabel;
@synthesize indexPath;
@synthesize isSharing;
@synthesize appDelegate;
@synthesize groupInformation;
@synthesize headPopover;
- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)stopSharingButtonToggled:(id)sender {

    [delegate toggleSharing:gid];
}
-(void)reloadGroupInformation:(NSNotification*)notification {
    groupInformation = [[[appDelegate locationsManagement] groupDescriptions] valueForKey:gid];
    [groupContentView reloadData];
}
- (IBAction)leaveGroupButtonToggled:(id)sender {
    [delegate leaveGroup:gid];
}

-(void)setupWithGid:(NSString*)groupId sharing:(bool)sharing indexPath:(NSIndexPath *)path {
    [self setGid:groupId];
    appDelegate = [[UIApplication sharedApplication] delegate];

    [gidLabel setText:gid];
    [paperContentView setCornerRadius:4];
    [paperContentView setTapHandler:^(CGPoint tap){
        [delegate toggleExpandCardAtIndexPath:indexPath];
    }];
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanCard:)];
    [paperContentView addGestureRecognizer:recognizer];
    [self setIsSharing:sharing];
    [self setIndexPath:path];
    [groupContentView setDelegate:self];
    [groupContentView setDataSource:self];
    [groupContentView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadGroupInformation:) name:@"lmGroupDataChanged" object:nil];
    [stopSharingButton setBackgroundColor:MAIN_COLOR];
    [stopSharingButton setIsRaised:false];
    [stopSharingButton setTapHandler:^(CGPoint tap){
        [self stopSharingButtonToggled:nil];
    }];
    [stopSharingButton setCornerRadius:2];
    [leaveGroupButton setCornerRadius:2];
    [leaveGroupButton setBackgroundColor:MAIN_COLOR];
    [leaveGroupButton setIsRaised:false];
    [leaveGroupButton setTapHandler:^(CGPoint tap){
        [self leaveGroupButtonToggled:gid];
    }];
    if(!sharing) {
        isSharing = false;
        [stopSharingLabel setText:@"Start Sharing"];
    } else {
        isSharing = true;
    }
    groupInformation = [[[appDelegate locationsManagement] groupDescriptions] valueForKey:gid];
}
-(void)didPanCard:(UIGestureRecognizer*)recognizer {
    
}
-(void)presentDetailPopoverForUserCell:(NSDictionary*)userInfo fromCell:(UICollectionViewCell*)cell {
    if (headPopover) {
        [headPopover dismissPopoverAnimated:true];
        headPopover = nil;
    }
    UIViewController *contentController = [[UIViewController alloc] init];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,76,30)];
    [contentController setView:contentView];
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake((76/2) - 20, 5, 40, 10)];
    [usernameLabel setFont:PROXIMA_NOVA(10)];
    [usernameLabel setTextAlignment:NSTextAlignmentCenter];
    [usernameLabel setTextColor:[UIColor blackColor]];
    [usernameLabel setText:[userInfo valueForKey:@"username"]];
    UILabel *sharingLabel = [[UILabel alloc] init];
    [sharingLabel setTextAlignment:NSTextAlignmentCenter];
    if([userInfo valueForKey:@"latitude"]) {
        [sharingLabel setFrame:CGRectMake((76/2) - 10, 15, 20, 10)];
        [sharingLabel setTextColor:[UIColor greenColor]];
        [sharingLabel setText:@"Sharing"];
    } else {
        [sharingLabel setFrame:CGRectMake((76/2) - 20, 15, 40, 10)];
        [sharingLabel setTextColor:[UIColor redColor]];
        [sharingLabel setText:@"Not sharing"];
    }
    [contentView addSubview:sharingLabel];
    headPopover = [[UIPopoverController alloc] initWithContentViewController:contentController];
    [headPopover presentPopoverFromRect:[cell frame] inView:self permittedArrowDirections:UIPopoverArrowDirectionDown animated:true];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UINib *nib = [UINib nibWithNibName:@"HeadCollectionViewCell" bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"headCell"];
    HeadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headCell" forIndexPath:indexPath];
    NSString *uid = [[groupInformation allKeys] objectAtIndex:[indexPath row]];
    NSDictionary *userInfo = [groupInformation objectForKey:uid];
    [[cell roundView] setTapHandler:^(CGPoint tap){
        [self presentDetailPopoverForUserCell:userInfo fromCell:cell];
    }];
    if(![userInfo valueForKey:@"latitude"]) {
        [cell setAlpha:.5f];
    }
    if(![userInfo valueForKey:@"avatar"]) {
        [[cell roundView] setBackgroundColor:[AppDelegate colorForUsername:[userInfo valueForKey:@"username"]]];
        [[cell imageView] setHidden:true];
        [[cell roundView] setClipsToBounds:true];
        [[cell contentView] setBackgroundColor:[UIColor clearColor]];
        [[cell initialsLabel] setText:[(NSString*)[userInfo valueForKey:@"username"] substringToIndex:1]];
    }
    [[cell roundView] setCornerRadius:22];
    //NSDictionart *groupKey = [[appDelegate locationsManagement] ]
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[groupInformation allKeys] count];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)didTriggerSwipeRecognizer:(id)sender {
    [delegate leaveGroup:gid];
}
@end
