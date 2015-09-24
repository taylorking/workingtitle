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
int selectedIndexPath;
- (void)viewDidLoad {
    [super viewDidLoad];
    [searchDisplayController setDelegate:self];
    [searchBar setDelegate:self];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactManagerHasSearchResults) name:@"cmSearchResultsAvailable" object:nil];
    // Do any additional setup after loading the view.
}
#pragma mark - Search Bar Delegates
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // Start Querying
    [[appDelegate contactsManagement] initiateFriendSearch:searchText];
    
}

#pragma mark - NSNotificationCenter delegates
-(void)contactManagerHasSearchResults {
    searchResults = [[appDelegate contactsManagement] searchResults];
}
#pragma mark - Search Display Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(searchResults != nil && searchResults != [NSNull null]) {
        return [searchResults count];
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Contact *contact = [searchResults objectAtIndex:[indexPath row]];
    selectedIndexPath = [indexPath row];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add a friend?" message:[NSString stringWithFormat:@"Send %@ a friend request?", [contact userName]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",@"OK and Don't show me this dialog again.", nil];
    [alertView show];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(searchResults != nil && searchResults != [NSNull null]) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,[[self view] frame].size.width, 40)];
        Contact *contact = [searchResults objectAtIndex:[indexPath row]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15,10,200,20)];
        [label setTag:4];
        [cell addSubview:label];
        [label setFont:[UIFont fontWithName:@"Proxima Nova" size:14]];
        [label setText:[contact userName]];
        return cell;
    }
    return nil;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        Contact *c = [searchResults objectAtIndex:selectedIndexPath];
        [[appDelegate contactsManagement] sendContactAFriendRequest:c];
    }
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
