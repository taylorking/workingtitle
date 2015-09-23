//
//  FirebaseLogin.m
//  OnMyWay
//
//  Created by Taylor King on 9/22/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import "FirebaseFriendSearch.h"

@implementation FirebaseFriendSearch
@synthesize firebaseRootInstance;
@synthesize searchResults;
-(FirebaseFriendSearch*)initWithFirebaseCore:(FirebaseCore*)firebaseCore {
    self = [super init];
    [self setFirebaseRootInstance:[firebaseCore firebaseRootInstance]];
    return self;
}
-(void)searchUsersForQueryString:(NSString*)queryString
{
    //Launch the async search
    Firebase *usernameSearchChild = [firebaseRootInstance childByAppendingPath:@"/usernames"];
    FQuery *query = [[[[usernameSearchChild queryOrderedByKey] queryStartingAtValue:queryString] queryEndingAtValue:[NSString stringWithFormat:@"%@~", queryString]] queryLimitedToFirst:100];
    [query observeSingleEventOfType:FEventTypeValue  andPreviousSiblingKeyWithBlock:^(FDataSnapshot *snapshot, NSString *prevKey) {
        [self asyncSearchResultReceived:snapshot];
    }];
}
-(void)asyncSearchResultReceived:(FDataSnapshot*)snapshot {
        //Fire a notification telling the observer that the data is available
    searchResults = [[snapshot value] copy];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"friendSearchResultsAvailable" object:nil];
    
}
@end
