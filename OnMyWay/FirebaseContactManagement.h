//
//  FirebaseContactManagement.h
//  OnMyWay
//
//  Created by Taylor King on 9/23/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirebaseCore.h"
#import <Firebase/Firebase.h>
@interface FirebaseContactManagement : NSObject
@property (strong, nonatomic) Firebase *firebaseRootInstance;
@property (strong, nonatomic) NSDictionary *currentContacts, *initialContacts;

-(FirebaseContactManagement*)initWithFirebaseCore:(FirebaseCore*)firebaseCore;
@end
