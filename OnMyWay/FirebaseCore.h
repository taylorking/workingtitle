//
//  FirebaseRegistration.h
//  OnMyWay
//
//  Created by Taylor King on 9/15/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//
#import <Firebase/Firebase.h>
#import <Foundation/Foundation.h>

@interface FirebaseCore : NSObject

@property (strong, nonatomic) Firebase *firebaseRootInstance;
-(FirebaseCore*)init;
@end
