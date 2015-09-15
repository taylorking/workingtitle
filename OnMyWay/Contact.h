//
//  Contact.h
//  OnMyWay
//
//  Created by Taylor King on 9/10/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Contact : NSManagedObject

@property (nonatomic, retain) NSNumber * accepted;
@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * selected;

@end
