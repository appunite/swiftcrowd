//
//  YPSocialAuth.m
//  Yapert
//
//  Created by Emil Wojtaszek on 20/03/14.
//  Copyright (c) 2014 AppUnite.com. All rights reserved.
//

#import "YPSocialAuth.h"

#import "SCConstants.h"

NSString * const YPSocialAuthErrorDomain = @"YPSocialAuthErrorDomain";

@implementation YPSocialAuth

#pragma mark -
#pragma mark Class methods

+ (void)credentialForAccount:(NSString *)accountType handler:(AUSocialAuthCredentialCompletionHandler)handler {
    NSParameterAssert(accountType);

    BOOL twitterAccountType = [accountType isEqual:ACAccountTypeIdentifierTwitter];
    NSAssert(twitterAccountType, @"Unsupported account type.");
    
    // fetch credential for twitter account
    if (twitterAccountType) {
        [self credentialForTwitterAccountWithCompletitionBlock:handler];
    }
}

#pragma mark - 
#pragma mark Private

+ (void)credentialForTwitterAccountWithCompletitionBlock:(AUSocialAuthCredentialCompletionHandler)handler {
    // get facebook shared instance
    AUTwitterAuth *twitterAuth = [AUTwitterAuth sharedInstance];
    
    // ask for access to account
    [twitterAuth obtainAccessToAccountsWithCompletitionBlock:^(BOOL granted, NSError *error) {
        NSArray *accounts = [twitterAuth accounts];

        if (granted) {
            [twitterAuth credentialForAccount:accounts[0] consumerKey:APP_TWITTER_CONSUMER_KEY consumerSecret:APP_TWITTER_CONSUMER_SECRET withHandler:handler];
        }
        
        else if (error) {
            handler(NO, nil, error);
        }
    }];

}

@end
