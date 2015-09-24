//
//  ContactsManagement.m
//  OnMyWay
//
//  Created by Taylor King on 9/8/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//

#import "ContactsManagement.h"
// This layer is going to sandwich core data and firebase
// I guess this is like controller code
@implementation ContactsManagement
@synthesize friends, pendingFriendRequests, incomingFriendRequests, mainObjectContext;
@synthesize firebaseCore, firebaseFriendRequests, firebaseFriendSearch, firebaseContactManager;
@synthesize searchResults;
@synthesize tempObjectContext;
//In the future, if coredata is not ready, this will call out to an api to get the info and dump it in coredata.

-(ContactsManagement*)initWithManagedObjectContext:(NSManagedObjectContext*)context tempObjectContext:(NSManagedObjectContext *)tempContext andFirebaseCore:(FirebaseCore *)rootFirebaseCore{
    // Maintaining a runtime array of stuff
    pendingFriendRequests = [[NSMutableArray alloc] init];
    incomingFriendRequests = [[NSMutableArray alloc] init];
    friends = [[NSMutableArray alloc] init];
    //Bring the firebase stuff in
    [self setMainObjectContext:context];
    [self setTempObjectContext:tempContext];
    //For now we will simulate data
    //[self simulateData];
    
    [self setFirebaseCore:rootFirebaseCore];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"didCompleteInitialContactLoad"]) {
        [self loadContactsFromDatabase];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firebaseDidRecieveNewContactSearchData) name:@"fbSearchResultsAvailable"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firebaseDidRecieveNewFriendRequests) name:@"fbFriendRequestsAvailable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firebaseDidRecieveInitialContactData) name:@"fbContactsInitialLoad" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firebaseDidRecieveNewContactData) name:@"fbContactAdded" object:nil];
    firebaseFriendSearch = [[FirebaseFriendSearch alloc] initWithFirebaseCore:firebaseCore];
    firebaseFriendRequests = [[FirebaseFriendRequests alloc] initWithFirebaseCore:firebaseCore];
    firebaseContactManager = [[FirebaseContactManagement alloc] initWithFirebaseCore:firebaseCore];
    //Hook up observers so we can listen for firebase events.
    
    return self;
}
# pragma mark - Runtime stuff. After everything is synchronized we will alert the view controllers and they will pull stuff from here.
-(NSUInteger)numberOfContacts {
    return [friends count];
}
#pragma mark - CoreData methods, NSManagedObject Stuff.
-(Contact*)getTemporaryContact {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:tempObjectContext];
    Contact *contact = (Contact*)[[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:tempObjectContext];
    return contact;
}
-(Contact*)getSaveableContact {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:mainObjectContext];
    Contact *contact = (Contact*)[[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:mainObjectContext];
    return contact;
}
-(ContactRequest*)getTemporaryContactRequest {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"ContactRequest" inManagedObjectContext:tempObjectContext];
    ContactRequest *request = (ContactRequest*)[[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:tempObjectContext];
    return request;
}
-(void)storeFinishedContact:(Contact *)contact {
    NSError *error;
    [friends addObject:contact];
    [mainObjectContext insertObject:contact];
    [mainObjectContext save:&error];
}

-(void)loadContactsFromDatabase {
    // If we don't have them locally we need to go get them
    
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
    friends = [[mainObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
}
# pragma mark - Query Methods
-(void)initiateFriendSearch:(NSString *)searchString{
    [firebaseFriendSearch searchUsersForQueryString:searchString];
}
-(void)sendContactAFriendRequest:(Contact*)contact {
    [firebaseFriendRequests sendFriendRequestToUid:[contact uid]];
}
# pragma mark - Firebase Translation Methods

-(void)firebaseDidRecieveNewContactSearchData {
    if([firebaseFriendSearch searchResults] == [NSNull null] || [firebaseFriendSearch searchResults] == nil) {
        return;
    }
    searchResults = [[NSMutableArray alloc] init];
    for(NSString *key in [firebaseFriendSearch searchResults]) {
        Contact *contact = [self getTemporaryContact];
        [contact setUserName:key];
        [contact setUid:[[firebaseFriendSearch searchResults] valueForKey:key]];
        [searchResults addObject:contact];
    }
    // UI <=== Notification <=== me + save to CoreData <=== notification <===== firebase
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cmSearchResultsAvailable" object:nil];
}
-(void)firebaseDidRecieveNewFriendRequests {
    if(!incomingFriendRequests) {
        incomingFriendRequests = [[NSMutableArray alloc] init];
    }
    if([firebaseFriendRequests currentFriendRequests] != [NSNull null] && [firebaseFriendRequests currentFriendRequests] != nil) {
        for(NSString *key in [firebaseFriendRequests currentFriendRequests]) {
            ContactRequest *request = [self getTemporaryContactRequest];
            [request setUserName:key];
            [request setUid:[[firebaseFriendRequests currentFriendRequests] valueForKey:key]];
            [incomingFriendRequests addObject:request];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cmFriendRequestsAvailable" object:nil];
    }
}
-(void)firebaseDidRecieveInitialContactData {
    NSError *error;
    //Zero the data just in case.
    friends = [[NSMutableArray alloc] init];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Contact"];
    NSArray *results = [mainObjectContext executeFetchRequest:fetchRequest error:&error];
    for(Contact *c in results) {
        [mainObjectContext deleteObject:c];
    }
    for(NSString *key in [firebaseContactManager initialContacts]) {
        Contact *contact = [self getSaveableContact];
        [contact  setUserName:key];
        [contact setUid:[[firebaseContactManager initialContacts] valueForKey:key]];
        [self storeFinishedContact:contact];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cmContactInitialLoadComplete" object:nil];
}
                                                                              
-(void)firebaseDidRecieveNewContactData {
    if(!friends) {
        friends = [[NSMutableArray alloc] init];
    }
    [mainObjectContext performBlock:^{
        // If this contact already exists we dont want to save it
        for(NSString *key in [firebaseContactManager currentContacts]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"uid='%@'", [[firebaseContactManager currentContacts] valueForKey:key]]];
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
            [request setPredicate:predicate];
            NSError *error;
            NSArray *result = [mainObjectContext executeFetchRequest:request error:&error];
            if([result count] < 1) {
                Contact *contact = [self getSaveableContact];
                [contact setUserName:key];
                [contact setUid:[[firebaseContactManager currentContacts] valueForKey:key]];
                [self storeFinishedContact:contact];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cmContactReloadNeeded" object:nil];
    }];
}
/** We don't need this any more
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
 
    }
    [objectContext save:&error];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
    friends = [[objectContext executeFetchRequest:request error:&error] mutableCopy];
}
**/
@end
