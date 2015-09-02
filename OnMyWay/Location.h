//
//  Location.h
//  OnMyWay
//
//  Created by Taylor King on 9/2/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject

@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * name;

@end
