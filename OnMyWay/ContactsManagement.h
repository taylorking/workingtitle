//
//  ContactsManagement.h
//  OnMyWay
//
//  Created by Taylor King on 9/8/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//
#import "Contact.h" 
#import "Location.h"
#import <Foundation/Foundation.h>

@interface ContactsManagement : NSObject
@property (strong, nonatomic) NSMutableArray *pendingFriendRequests;
@property (strong, nonatomic) NSMutableArray *friends;
@property (strong, nonatomic) NSMutableArray *incomingFriendRequests;
@property (strong, nonatomic) NSManagedObjectContext *objectContext;
-(ContactsManagement*)initWithManagedObjectContext:(NSManagedObjectContext*)context;
@end
