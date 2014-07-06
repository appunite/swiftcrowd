//
//  YPSocialAuth.h
//  Yapert
//
//  Created by Emil Wojtaszek on 20/03/14.
//  Copyright (c) 2014 AppUnite.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//SocialAuth
#import "AUTwitterAuth.h"

@interface YPSocialAuth : NSObject

// fetch credentials for given account type
+ (void)credentialForAccount:(NSString *)accountType
                     handler:(AUSocialAuthCredentialCompletionHandler)handler;
@end

// Errors
extern NSString * const YPSocialAuthErrorDomain;
typedef NS_ENUM(NSUInteger, YPSocialAuthError) {
    AUSocialAuthUserCancelledError
};

