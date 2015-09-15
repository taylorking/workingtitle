//
//  OAuthSystem.h
//  OnMyWay
//
//  Created by Taylor King on 9/14/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//
#import "OAuthiOS/OAuthiOS.h"
#import <Foundation/Foundation.h>

@interface OAuthSystem : NSObject <OAuthIODelegate>

-(void)popMessageForProvider:(NSString*)provider;

@end
