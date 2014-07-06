//
//  AUSocialAuth.h
//  AUKit
//
//  Created by Emil Wojtaszek on 26.04.2013.
//  Copyright (c) 2013 AppUnite.com. All rights reserved.
//

//Frameworks
#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

typedef void(^AUSocialAuthAccountsAccessCompletionHandler)(BOOL granted, NSError *error);
typedef void(^AUSocialAuthCredentialCompletionHandler)(BOOL success, NSDictionary *tokens, NSError *error);
typedef void(^AUSocialAuthCredentialsVerificationCompletionHandler)(BOOL verified, NSError *error);

@interface AUSocialAuth : NSObject

@property (nonatomic, strong, readonly) ACAccountStore *accountStore;
@property (nonatomic, strong, readonly) NSArray *accounts;
@property (nonatomic, strong) NSDictionary *accountOptions;

// shared instance
+ (instancetype)sharedInstance;

// return account type, you need to override it in subclasses
+ (NSString *)accountTypeIdentifier;

// returns true if there are local accounts available and it use accountTypeIdentifier methodsto define account type
+ (BOOL)isLocalAccountAvailable;

// send access request to account store (base on accountTypeIdentifier)
- (void)obtainAccessToAccountsWithCompletitionBlock:(AUSocialAuthAccountsAccessCompletionHandler)block;
@end

extern NSDictionary *AUQueryParameters (NSString *queryStr);

// Token keys
extern NSString * const AUSocialAuthOAuthTokenKey;
extern NSString * const AUSocialAuthOAuthTokenSecretKey;

// Errors
extern NSString * const AUSocialAuthErrorDomain;
typedef NS_ENUM(NSUInteger, AUSocialAuthError) {
    AUSocialAuthNoGrantError,
    AUSocialAuthNoAccountsError
};

