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
ContactRequest *request;
-(void)viewDidLoad {
    appDelegate = [[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendRequestRecieved) name:@"cmContactReloadNeeded" object:nil];
    [[self tableView] setDelegate:self];
    [[self tableView] setDataSource:self];
    [[self tableView] reloadData];
}
-(void)friendRequestRecieved {
    [[self tableView] reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[appDelegate contactsManagement] incomingFriendRequests] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    request = [[[appDelegate contactsManagement] incomingFriendRequests] objectAtIndex:[indexPath row]];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0, W([self view]), 55)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 200, 10)];
    [label setFont:PROXIMA_NOVA(12)];
    [label setText:[request userName]];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(W([self view]) - 40, 15, 25,20)];
    [indicator setTag:5];
    [indicator setHidden:true];
    [cell addSubview:indicator];
    [cell addSubview:label];
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    request = [[[appDelegate contactsManagement] incomingFriendRequests] objectAtIndex:[indexPath row]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Accept friend request?" message:[NSString stringWithFormat:@"Accept the friend request from %@?",[request userName]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView show];
    return false;
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        [[appDelegate contactsManagement] acceptFriendRequest:request];
    }
}

@end
