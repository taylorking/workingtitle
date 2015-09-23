//
//  FirebaseLogin.h
//  OnMyWay
//
//  Created by Taylor King on 9/22/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>
#import "FirebaseCore.h"
@interface FirebaseFriendSearch : NSObject
-(void)searchUsersForQueryString:(NSString*)queryString;
-(FirebaseFriendSearch*)initWithFirebaseCore:(FirebaseCore*)firebaseCore;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) Firebase *firebaseRootInstance;

@end
