//
//  FirebaseRegistration.h
//  OnMyWay
//
//  Created by Taylor King on 9/15/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//
#import <Firebase/Firebase.h>
#import "FirebaseRegistration.h"
#import <Foundation/Foundation.h>

@interface FirebaseRegistration : NSObject

@property (strong, nonatomic) Firebase *firebase;

-(FirebaseRegistration*)initWithUser:(NSString*)username token:(NSString*)token;

-(void)addUserToLocationShare:(NSString*)userId;
-(void)removeUserFromLocationShare:(NSString*)userId;

@property (strong, nonatomic) NSString *userName, *userToken;

@end
