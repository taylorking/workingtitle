//
//  ContactsManagement.m
//  OnMyWay
//
//  Created by Taylor King on 9/8/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//

#import "ContactsManagement.h"

@implementation ContactsManagement
@synthesize friends, pendingFriendRequests, incomingFriendRequests, objectContext;
//In the future, if coredata is not ready, this will call out to an api to get the info and dump it in coredata.
-(ContactsManagement*)initWithManagedObjectContext:(NSManagedObjectContext*)context {
    pendingFriendRequests = [[NSMutableArray alloc] init];
    incomingFriendRequests = [[NSMutableArray alloc] init];
    friends = [[NSMutableArray alloc] init];
    [self setObjectContext:context];
    //For now we will simulate data
    [self simulateData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"contactDataReady" object:nil userInfo:nil];
    return self;
}

// This will just simulate contacts in memory.
-(void)simulateData {
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Contact"];
    friends = [[objectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if([friends count] > 0) {
        for(NSManagedObject *object in friends) {
            [objectContext deleteObject:object];
        }
        [objectContext save:&error];
    }
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSString *numbers = @"0123456789";
    for(int i = 0; i < 100; i++) {
        
        NSMutableString *pendingPhoneNumber = [[NSMutableString alloc] init];
        NSMutableString *incomingPhoneNumber = [[NSMutableString alloc] init];
        NSMutableString *friendPhoneNumber = [[NSMutableString alloc] init];
        for(int i = 0; i < 10; i++) {
            [pendingPhoneNumber appendFormat:@"%C", [numbers characterAtIndex:arc4random_uniform(10)]];
            [incomingPhoneNumber appendFormat:@"%C", [numbers characterAtIndex:arc4random_uniform(10)]];
            [friendPhoneNumber appendFormat:@"%C", [numbers characterAtIndex:arc4random_uniform(10)]];
        }
        NSMutableString *pendingUserName = [[NSMutableString alloc] init];
        NSMutableString *friendUserName = [[NSMutableString alloc] init];
        NSMutableString *incomingUserName = [[NSMutableString alloc] init];
        for(int i = 0; i < 32; i++) {
            [pendingUserName appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform([letters length])]];
            [friendUserName appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform([letters length])]];
            [incomingUserName appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform([letters length])]];
        }
        NSMutableString *pendingDisplayName = [[NSMutableString alloc] init];
        NSMutableString *incomingDisplayName = [[NSMutableString alloc] init];
        NSMutableString *friendDisplayName = [[NSMutableString alloc] init];
        for(int i = 0; i < 16; i++) {
            [pendingDisplayName appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform([letters length])]];
            [incomingDisplayName appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform([letters length])]];
            [friendDisplayName appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform([letters length])]];
        }
        [pendingDisplayName appendString:@" "];
        [incomingDisplayName appendString:@" "];
        [friendDisplayName appendString:@" "];
        for(int i = 0; i < 16; i++) {
            [pendingDisplayName appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform([letters length])]];
            [incomingDisplayName appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform([letters length])]];
            [friendDisplayName appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform([letters length])]];
        }
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:objectContext];
        Contact *contact = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:objectContext];
        
        @try {
            [contact setDisplayName:friendDisplayName];
            [contact setPhoneNumber:friendPhoneNumber];
            [contact setUserName:friendUserName];
            [contact setAccepted:false];
        }
        @catch (NSException *ex) {
            
        }
        //        [contact setAccepted:[NSNumber numberWithBool:true]];
        /**
        [incomingContact setDisplayName:incomingDisplayName];
        [incomingContact setUserName:incomingUserName];
        [incomingContact setPhoneNumber:incomingPhoneNumber];
        [incomingContact setAccepted:[NSNumber numberWithBool:true]];
        
        [incomingFriendRequests addObject:incomingContact];
        
        [pendingContact setUserName:pendingUserName];
        [pendingContact setDisplayName:pendingDisplayName];
        [pendingContact setPhoneNumber:pendingPhoneNumber];
        [pendingContact setAccepted:[NSNumber numberWithBool:false]];
        
        [pendingFriendRequests addObject:pendingContact];
         **/
    }
    [objectContext save:&error];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
    friends = [[objectContext executeFetchRequest:request error:&error] mutableCopy];
}

@end
