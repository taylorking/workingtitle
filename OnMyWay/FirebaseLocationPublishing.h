//
//  FirebaseLocationPublishing.h
//  OnMyWay
//
//  Created by Taylor King on 9/23/15.
//  Copyright © 2015 omwltd. All rights reserved.
//
#import <Firebase/Firebase.h>
#import <Foundation/Foundation.h>
#import "FirebaseCore.h"
@interface FirebaseLocationPublishing : NSObject
@property (strong, nonatomic) Firebase *firebaseRootInstance;
@property (strong, nonatomic) Firebase *firebaseLocationChildInstance;
-(FirebaseLocationPublishing*)initWithFirebaseCore:(FirebaseCore*)firebaseCore;
@end
