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
#define LIGHTSECONDARY_COLOR [UIColor colorWithRed:178/255.0 green:223/255.0 blue:219/255.0 alpha:1]
#define ALMOSTWHITE_COLOR [UIColor colorWithRed:224/255.0 green:242/255.0 blue:241/255.0 alpha:1]
#define PROXIMA_NOVA(sizeT) [UIFont fontWithName:@"Proxima Nova" size:sizeT]
#define W(viewT) [viewT frame].size.width
#define H(viewT) [viewT frame].size.height
#define CX(viewT) [viewT center].x
#define CY(viewT) [viewT center].y
#if DEV==1
#define CONNECTION_INFO [[NSBundle mainBundle] pathForResource:@"ConnectionInfo-dev" ofType:@"plist"]
#else
#define CONNECTION_INFO [[NSBundle mainBundle] pathForResource:@"ConnectionInfo" ofType:@"plist"]
#endif
#endif /* macros_h */
