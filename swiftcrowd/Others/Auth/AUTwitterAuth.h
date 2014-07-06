//
//  AUTwitterAuth.h
//  AUKit
//
//  Created by Emil Wojtaszek on 09.09.2012.
//  Copyright (c) 2012 AppUnite.com. All rights reserved.
//

//Frameworks
#import <UIKit/UIKit.h>

// Others
#import "AUSocialAuth.h"

//Handler block
typedef void (^AUTwitterReverseAuthenticationCompletionHandler)(NSDictionary* response, NSError *error);

@interface AUTwitterAuth : AUSocialAuth

// fetch credentials for Twitter account
- (void)credentialForAccount:(ACAccount *)account
                 consumerKey:(NSString *)consumerKey
              consumerSecret:(NSString *)consumerSecret
                 withHandler:(AUSocialAuthCredentialCompletionHandler)handler;

// perform reverse authentication for Twitter account 
- (void)reverseAuthenticationWithConsumerKey:(NSString *)consumerKey
                              consumerSecret:(NSString *)consumerSecret
                                 withHandler:(AUTwitterReverseAuthenticationCompletionHandler)handler;

// call Twitter API ednpoint to verify token validity
- (void)verifyCredentialForAccount:(ACAccount *)account
                       withHandler:(AUSocialAuthCredentialsVerificationCompletionHandler)handler;
@end

// To invalidate Twitter token change account password