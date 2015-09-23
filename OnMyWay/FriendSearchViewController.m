//
//  FriendSearchViewController.m
//  OnMyWay
//
//  Created by Taylor King on 9/23/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import "FriendSearchViewController.h"

@interface FriendSearchViewController ()

@end

@implementation FriendSearchViewController
@synthesize searchDisplayController, searchBar, searchResults;
@synthesize appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [searchDisplayController setDelegate:self];
    [searchBar setDelegate:self];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchResultsAvailableAtAppDelegate) name:@"friendSearchResultsAvailable" object:nil];
    // Do any additional setup after loading the view.
}
#pragma mark - Search Bar Delegates
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // Start Querying

}

#pragma mark - NSNotificationCenter delegates
-(void)searchResultsAvailableAtAppDelegate {

}
#pragma mark - Search Display Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(searchResults != nil && searchResults != [NSNull null]) {
        return [[searchResults allKeys] count];
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add a friend?" message:[NSString stringWithFormat:@"Send %@ a friend request?", [[searchResults allKeys] objectAtIndex:[indexPath row]]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",@"OK and Don't show me this dialog again.", nil];
    [alertView show];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(searchResults != nil && searchResults != [NSNull null]) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,[[self view] frame].size.width, 40)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15,10,200,20)];
        [label setTag:4];
        [cell addSubview:label];
        [label setFont:[UIFont fontWithName:@"Proxima Nova" size:14]];
        [label setText:(NSString*)[[searchResults allKeys] objectAtIndex:[indexPath row]]];
        return cell;
    }
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
