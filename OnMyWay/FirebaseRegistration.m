//
//  FirebaseRegistration.m
//  OnMyWay
//
//  Created by Taylor King on 9/15/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//

#import "FirebaseRegistration.h"

@implementation FirebaseRegistration
@synthesize firebase;
@synthesize userName, userToken;

-(FirebaseRegistration*)initWithUser:(NSString*)username token:(NSString*)token {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ConnectionInfo" ofType:@"plist"];
    NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    firebase = [[Firebase alloc] initWithUrl:(NSString*)[settingsDictionary objectForKey:@"firebaseUrl"]];
    [self setUserName:username];
    [self setUserToken:token];
    
    [firebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot){
        [self firebaseDataRecieved:snapshot];
    }];
    
    return self;
}
-(void)firebaseDataRecieved:(FDataSnapshot*)data {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationRecieved" object:data];
}
-(void)addUserToLocationShare:(NSString*)userId {
    
}
-(void)pushLocationToFirebaseWithLatitude:(float)latitude longitude:(float)longitude {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[NSNumber numberWithFloat:latitude] forKey:@"latitude"];
    [dictionary setValue:[NSNumber numberWithFloat:longitude] forKey:@"longitude"];
    [dictionary setValue:userName forKey:@"userName"];
    [dictionary setValue:userToken forKey:@"userToken"];
    NSError *error;
    NSString *jsonData = [NSJSONSerialization JSONObjectWithData:dictionary options:NSJSONWritingPrettyPrinted error:&error];
}

@end

