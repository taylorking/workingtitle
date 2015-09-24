//
//  FirebaseLocationPublishing.m
//  OnMyWay
//
//  Created by Taylor King on 9/23/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import "FirebaseLocationPublishing.h"

@implementation FirebaseLocationPublishing
@synthesize firebaseRootInstance;
@synthesize firebaseLocationChildInstance;
-(FirebaseLocationPublishing*)initWithFirebaseRootInstance:(Firebase*)rootInstance {
    self = [super init];
    [self setFirebaseRootInstance:rootInstance];
    [self setFirebaseLocationChildInstance:[rootInstance childByAppendingPath:@"location"]];
    return self;
}

@end
