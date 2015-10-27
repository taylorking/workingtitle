//
//  GroupViewCell.h
//  OnMyWay
//
//  Created by Taylor King on 10/18/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BFPaperView/BFPaperView.h> 
#import "AppDelegate.h"
#import "macros.h"
#import "HeadCollectionViewCell.h"
@protocol GroupViewCellDelegate
-(void)leaveGroup:(NSString*)gid;
-(void)toggleSharing:(NSString*)gid;
-(void)expandCardAtIndexPath:(NSIndexPath*)path;
 @end
@interface GroupViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet BFPaperView *paperContentView;
@property (weak, nonatomic) IBOutlet UICollectionView *groupContentView;
@property (strong, nonatomic) NSString *gid;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UILabel *gidLabel;

- (IBAction)didTriggerSwipeRecognizer:(id)sender;
@property (strong, nonatomic) id<GroupViewCellDelegate> delegate;
@property (assign) BOOL isSharing;
@property (strong, nonatomic) NSDictionary *groupInformation;

@property (weak, nonatomic) IBOutlet BFPaperView *leaveGroupButton;
@property (weak, nonatomic) IBOutlet BFPaperView *stopSharingButton;
@property (weak, nonatomic) IBOutlet UILabel *stopSharingLabel;
@property (weak, nonatomic) NSIndexPath *indexPath;
-(void)setupWithGid:(NSString*)groupId sharing:(bool)sharing indexPath:(NSIndexPath*)path;
@end
