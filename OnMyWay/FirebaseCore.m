//
//  FirebaseCore.m
//  OnMyWay
//
//  Created by Taylor King on 9/15/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//

#import "FirebaseCore.h"

@implementation FirebaseCore
@synthesize firebaseRootInstance;
-(FirebaseCore*)init {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ConnectionInfo" ofType:@"plist"];
    NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    firebaseRootInstance = [[Firebase alloc] initWithUrl:(NSString*)[settingsDictionary valueForKey:@"firebaseUrl"]];
    [firebaseRootInstance authUser:@"kingtb@appstate.edu" password:@"password" withCompletionBlock:^(NSError *error, FAuthData *authData) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:[authData uid] forKey:@"uid"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fbUserDidCompleteLogin" object:nil];
    }];
    return self;
}

@end

