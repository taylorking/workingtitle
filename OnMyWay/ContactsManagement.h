//
//  ContactsManagement.h
//  OnMyWay
//
//  Created by Taylor King on 9/8/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//
#import "ContactRequest+CoreDataProperties.h"
#import "Contact+CoreDataProperties.h"
#import "Location.h"
#import <Foundation/Foundation.h>
#import "FirebaseFriendSearch.h"
#import "FirebaseFriendRequests.h"
#import "FirebaseContactManagement.h"
#import "FirebaseCore.h"

@interface ContactsManagement : NSObject

@property (strong, nonatomic) NSMutableArray *pendingFriendRequests;
@property (strong, nonatomic) NSMutableArray *friends, *searchResults;
@property (strong, nonatomic) NSMutableArray *incomingFriendRequests;
@property (strong, nonatomic) NSManagedObjectContext *mainObjectContext, *tempObjectContext;
@property (strong, nonatomic) FirebaseCore *firebaseCore;
@property (strong, nonatomic) FirebaseContactManagement *firebaseContactManager;
@property (strong, nonatomic) FirebaseFriendRequests *firebaseFriendRequests;
@property (strong, nonatomic) FirebaseFriendSearch *firebaseFriendSearch;
@property (strong, nonatomic) NSMutableArray *friendSearchResults;
-(ContactsManagement*)initWithManagedObjectContext:(NSManagedObjectContext*)context tempObjectContext:(NSManagedObjectContext*)tempContext andFirebaseCore:(FirebaseCore*)rootFirebaseCore;
-(void)initiateFriendSearch:(NSString*)searchString;
-(Contact*)getSaveableContact;
-(Contact*)getTemporaryContact;
-(void)storeFinishedContact:(Contact*)contact;
-(void)sendContactAFriendRequest:(Contact*)contact;
-(void)loadContactsFromDatabase;
-(NSUInteger)numberOfContacts;
@end
