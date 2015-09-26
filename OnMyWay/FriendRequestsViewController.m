//
//  FriendRequestsViewController.m
//  OnMyWay
//
//  Created by Taylor King on 9/24/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import "FriendRequestsViewController.h"

@implementation FriendRequestsViewController
@synthesize appDelegate;
-(void)viewDidLoad {
    [[self tableView] setDelegate:self];
    [[self tableView] setDataSource:self];
    
}
-(void)friendRequestRecieved {
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[appDelegate contactsManagement] incomingFriendRequests] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactRequest *request = [[[appDelegate contactsManagement] incomingFriendRequests] objectAtIndex:[indexPath row]];
    return nil;
}

@end
