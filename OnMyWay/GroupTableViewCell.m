//
//  GroupTableViewCell.m
//  OnMyWay
//
//  Created by Taylor King on 10/7/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import "GroupTableViewCell.h"

@implementation GroupTableViewCell
@synthesize appDelegate;

@synthesize filterDelegate;
@synthesize paperContentView;
@synthesize cellGid;
@synthesize usersScrollView;
@synthesize cellNibLoaded;
@synthesize selectedCheckbox;
int padding = 8;
NSMutableDictionary *cells;
-(GroupTableViewCell*)initWithFrame:(CGRect)frame group:(NSString*)gid {
    cellNibLoaded = false;
    self = [super initWithFrame:frame];
    appDelegate = [[UIApplication sharedApplication] delegate];
    [self setCellGid:gid];
    paperContentView = [[BFPaperView alloc] initWithFrame:CGRectMake(padding,padding,frame.size.width - (2 * padding), frame.size.height - (2*padding))];
    cells = [[NSMutableDictionary alloc] init];
    [paperContentView setBackgroundColor:ALMOSTWHITE_COLOR];
    [paperContentView setCornerRadius:4];
    selectedCheckbox = [[BFPaperCheckbox alloc] initWithFrame:CGRectMake(W(paperContentView) - 32, 8, 24, 24)];
    [self addSubview:paperContentView];
    [paperContentView addSubview:selectedCheckbox];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setItemSize:CGSizeMake(45,45)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveGroupChangedNotification:) name:@"lmGroupDataChanged" object:nil];
    
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setupUsersView];
    return self;
}
-(void)setupUsersView {
    NSDictionary *users = [[[appDelegate locationsManagement] groupDescriptions] valueForKey:cellGid];
    usersScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,[paperContentView frame].size.height - 70,W(paperContentView), 55)];
    [usersScrollView setContentSize:CGSizeMake(50 * ([[users allKeys] count] + 1), 55)];
    for(int i = 0; i < [[users allKeys] count];i++) {
        NSDictionary *user = [users valueForKey:[[users allKeys] objectAtIndex:i]];
        BFPaperView *userIcon = [[BFPaperView alloc] initWithFrame:CGRectMake((50 * i) + 10, 10, 45, 45)];
        [userIcon setCornerRadius:45/2.0];
        [userIcon setClipsToBounds:true];
        [userIcon setBackgroundColor:[AppDelegate colorForUsername:[user valueForKey:@"username"]]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,45,45)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:PROXIMA_NOVA(24)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor whiteColor]];
        [label setText:[(NSString*)[user valueForKey:@"username"] substringToIndex:1]];
        [userIcon addSubview:label];
        [userIcon setTapHandler:^(CGPoint tap){
            
        }];
        [usersScrollView addSubview:userIcon];
    }
    [paperContentView addSubview:usersScrollView];
}
-(void)didRecieveGroupChangedNotification:(NSNotification*)notification {
    if([cellGid isEqualToString:[notification object]]) {
 //       [self reloadCollectionView];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
