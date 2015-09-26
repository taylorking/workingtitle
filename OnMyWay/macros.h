//
//  macros.h
//  OnMyWay
//
//  Created by Taylor King on 9/26/15.
//  Copyright © 2015 omwltd. All rights reserved.
//
// Import this file for macros b/c they deprecated prefix.pch files 
#ifndef macros_h
#define macros_h
#define MAIN_COLOR [UIColor colorWithRed:0 green:77/255.0 blue:64/255.0 alpha:1]
#define SECONDARY_COLOR [UIColor colorWithRed:128/255.0 green:203/255.0 blue:196/255.0 alpha:1]
#define PROXIMA_NOVA(sizeT) [UIFont fontWithName:@"Proxima Nova" size:sizeT]
#if DEV==1
#define CONNECTION_INFO [[NSBundle mainBundle] pathForResource:@"ConnectionInfo-dev" ofType:@"plist"]
#else
#define CONNECTION_INFO [[NSBundle mainBundle] pathForResource:@"ConnectionInfo" ofType:@"plist"]
#endif
#endif /* macros_h */
