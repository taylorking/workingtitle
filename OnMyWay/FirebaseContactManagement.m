//
//  FirebaseContactManagement.m
//  OnMyWay
//
//  Created by Taylor King on 9/23/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import "FirebaseContactManagement.h"

@implementation FirebaseContactManagement
@synthesize firebaseRootInstance;
@synthesize currentContacts, initialContacts;
@synthesize delegate;
-(FirebaseContactManagement*)initWithFirebaseCore:(FirebaseCore *)firebaseCore {
    self = [super init];
    [self setFirebaseRootInstance:[firebaseCore firebaseRootInstance]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults objectForKey:@"didCompleteInitialContactLoad"]) {
        [self performInitialContactLoad];
    }
    [[[firebaseRootInstance childByAppendingPath:@"friends"] childByAppendingPath:[defaults valueForKey:@"uid"]] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot){
        [self contactAdded:snapshot];
    }];
    return self;
}
-(void)performInitialContactLoad {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [[[firebaseRootInstance childByAppendingPath:@"friends"] childByAppendingPath:[userDefaults valueForKey:@"uid"]] observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot){
        [self initialContactLoadDidComplete:snapshot];
    }];
}
-(void)contactAdded:(FDataSnapshot*)snapshot {

    currentContacts = [NSDictionary dictionaryWithObjectsAndKeys:[snapshot key], [snapshot value], nil];
    [delegate didRecieveSingleContact:currentContacts];
}
-(void)initialContactLoadDidComplete:(FDataSnapshot*)snapshot {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    initialContacts = [snapshot value];
    [defaults setValue:[NSNumber numberWithBool:true] forKey:@"didCompleteInitialContactLoad"];
    [delegate didRecieveInitialContacts:initialContacts];
}

@end
