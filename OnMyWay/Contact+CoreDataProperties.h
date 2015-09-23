//
//  Contact+CoreDataProperties.h
//  OnMyWay
//
//  Created by Taylor King on 9/23/15.
//  Copyright © 2015 omwltd. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Contact.h"

NS_ASSUME_NONNULL_BEGIN

@interface Contact (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *accepted;
@property (nullable, nonatomic, retain) NSString *displayName;
@property (nullable, nonatomic, retain) NSString *phoneNumber;
@property (nullable, nonatomic, retain) NSNumber *selected;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *uid;
@property (nullable, nonatomic, retain) NSDate *dateAdded;

@end

NS_ASSUME_NONNULL_END
