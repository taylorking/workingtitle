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
-(FirebaseCore*)initWithEmail:(NSString*)email password:(NSString*)password username:(NSString*)userName {
    
    NSString *plistPath = CONNECTION_INFO;
    
    NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    firebaseRootInstance = [[Firebase alloc] initWithUrl:(NSString*)[settingsDictionary valueForKey:@"firebaseUrl"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [firebaseRootInstance authUser:email password:password withCompletionBlock:^(NSError *error, FAuthData *authData) {
        if(!error) {
            [defaults setValue:email forKey:@"email"];
            [defaults setValue:[authData uid] forKey:@"uid"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"fbUserDidCompleteLogin" object:nil];
        }
        
        else if([[error localizedDescription] containsString:@"INVALID_PASSWORD"]){
            
        }
        else if([[error localizedDescription] containsString:@"INVALID_EMAIL"]) {
            
        }
        else if([[error localizedDescription] containsString:@"INVALID_USER"]) {
                [firebaseRootInstance createUser:email password:password withCompletionBlock:^(NSError* error){
                    if(!error) {
                        [defaults setValue:[authData uid] forKey:@"uid"];
                        [firebaseRootInstance authUser:email password:password withCompletionBlock:^(NSError *error, FAuthData *authData) {
                            if(!error) {
                                [defaults setValue:email forKey:@"email"];
                                [defaults setValue:[authData uid] forKey:@"uid"];
                                NSDictionary *userData = [[NSDictionary alloc] initWithObjectsAndKeys:email, @"email", @"password", @"provider", nil];
                                [[[firebaseRootInstance childByAppendingPath:@"users"] childByAppendingPath:[authData uid]] setValue:userData withCompletionBlock:^(NSError *error, Firebase *ref) {
                                    if(![defaults objectForKey:@"username"]) {
                                        [self setUserName:userName];
                                    }
                                    else {
                                            [[[firebaseRootInstance childByAppendingPath:@"users"] childByAppendingPath:[authData uid]] setValue:[defaults valueForKey:@"username"] forKey:@"username"];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"fbUserDidCompleteLogin" object:nil];
                                    }
                                }];
                            }
                        }];
                    }
                }];
            }
    }];
    return self;
}
-(void)setUserName:(NSString*)userName {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[[firebaseRootInstance childByAppendingPath:@"usernames"] childByAppendingPath:userName] setValue:[defaults valueForKey:@"uid"] withCompletionBlock:^(NSError *error, Firebase *ref) {
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:userName, @"username", [defaults valueForKey:@"email"], @"email", @"password", @"provider", nil];
        [[[firebaseRootInstance childByAppendingPath:@"users"] childByAppendingPath:[defaults valueForKey:@"uid"]] setValue:dictionary withCompletionBlock:^(NSError *error, Firebase *base){
            [defaults setValue:userName forKey:@"username"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"fbUserDidCompleteLogin" object:nil];
        }];
    }];
}

@end

