
//
//  OAuthSystem.m
//  OnMyWay
//
//  Created by Taylor King on 9/14/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//

#import "OAuthSystem.h"

@implementation OAuthSystem

-(void)popMessageForProvider:(NSString*)provider {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ConnectionInfo" ofType:@"plist"];
    NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSString *oauthIoPubKey, *oauthIoPrivKey;
    oauthIoPubKey = (NSString*)[settingsDictionary valueForKey:@"oauthIoPublicKey"];
    oauthIoPrivKey = (NSString*)[settingsDictionary valueForKey:@"oauthIoPrivateKey"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];

    

    OAuthIOModal *modalDialog = [[OAuthIOModal alloc] initWithKey:oauthIoPubKey delegate:self andOptions:parameters];
    [modalDialog showWithProvider:provider];
}
-(void)didAuthenticateServerSide:(NSString *)body andResponse:(NSURLResponse *)response {
    
}
-(void)didReceiveOAuthIOCode:(NSString *)code {
    
}
-(void)didFailWithOAuthIOError:(NSError *)error {
    
}
-(void)didFailAuthenticationServerSide:(NSString *)body andResponse:(NSURLResponse *)response andError:(NSError *)error {
    
}
-(void)didReceiveOAuthIOResponse:(OAuthIORequest *)request {

}
@end
