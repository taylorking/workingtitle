//
//  ContactRequest+CoreDataProperties.h
//  OnMyWay
//
//  Created by Taylor King on 9/23/15.
//  Copyright © 2015 omwltd. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ContactRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContactRequest (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSString *uid;
@property (nullable, nonatomic, retain) NSDate *dateSent;

@end

NS_ASSUME_NONNULL_END
