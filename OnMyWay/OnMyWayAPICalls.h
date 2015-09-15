//
//  OnMyWayAPICalls.h
//  OnMyWay
//
//  Created by Taylor King on 9/8/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnMyWayAPICalls : NSObject

@property (strong, nonatomic) NSMutableArray *contacts;
- (void)parseJson:(NSString*)json;
- (void)goGetData;

@end
