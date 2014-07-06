//
//  AUSocialAuth.m
//  AUKit
//
//  Created by Emil Wojtaszek on 26.04.2013.
//  Copyright (c) 2013 AppUnite.com. All rights reserved.
//

#import "AUSocialAuth.h"

NSString * const AUSocialAuthErrorDomain = @"AUSocialAuthErrorDomain";
NSString * const AUSocialAuthOAuthTokenKey = @"oauth_token";
NSString * const AUSocialAuthOAuthTokenSecretKey = @"oauth_token_secret";

@implementation AUSocialAuth

#pragma mark -
#pragma mark Init

- (instancetype)init {
    self = [super init];
    if (self) {
        // create enw account
        _accountStore = [ACAccountStore new];        
//        // add observer
//        [[NSNotificationCenter defaultCenter] addObserverForName:ACAccountStoreDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
//            [self accountStoreDidChangeNotification:note];
//        }];
    }
    return self;
}

#pragma mark -
#pragma mark Class methods

+ (instancetype)sharedInstance {
    return nil;
}

+ (NSString *)accountTypeIdentifier {
    @throw([NSException exceptionWithName:NSGenericException reason:@"You need to override accountTypeIdentifier method." userInfo:nil]);
}

+ (BOOL)isLocalAccountAvailable {
    // get indentifier
    NSString *accountTypeIdentifier = [self accountTypeIdentifier];
    
    if ([SLComposeViewController class]) {
        NSDictionary *services = @{
            ACAccountTypeIdentifierFacebook: SLServiceTypeFacebook,
            ACAccountTypeIdentifierTwitter: SLServiceTypeTwitter
        };

        return [SLComposeViewController isAvailableForServiceType:services[accountTypeIdentifier]];
    }
    
    return NO;
}

#pragma mark -
#pragma mark Instance methods

- (void)obtainAccessToAccountsWithCompletitionBlock:(AUSocialAuthAccountsAccessCompletionHandler)block {
    // clear previous accounts
    _accounts = nil;
    
    // get indentifier
    NSString *accountTypeIdentifier = [[self class] accountTypeIdentifier];
    
    // create account typr
    ACAccountType *type = [_accountStore accountTypeWithAccountTypeIdentifier:accountTypeIdentifier];
    
    // prepare request handler
    ACAccountStoreRequestAccessCompletionHandler handler = ^(BOOL granted, NSError *error) {
        NSArray *accounts;
        
        if (granted) {
            accounts = [_accountStore accountsWithAccountType:type];

            // fix Apple bug
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                [accounts enumerateObjectsUsingBlock:^(ACAccount *account, NSUInteger idx, BOOL *stop) {
                    [account setAccountType:type];
                }];
            }
            
            if ([accounts count] == 0) {
                error = [NSError errorWithDomain:AUSocialAuthErrorDomain code:AUSocialAuthNoAccountsError
                                        userInfo:@{NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"No Account detected. Please go into your device's settings menu to add new account.", nil)}];
            }
            
            // save accounts list
            _accounts = accounts;
        }
        
        else if (!error) {
            error = [NSError errorWithDomain:AUSocialAuthErrorDomain code:AUSocialAuthNoGrantError
                                    userInfo:@{NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"User has denied access to the account.", nil)}];
        }

        // fire completition block
        block(granted, error);
    };
    
    // request access to account
    [_accountStore requestAccessToAccountsWithType:type options:self.accountOptions completion:handler];
}

#pragma mark - 
#pragma mark Notifications

- (void)accountStoreDidChangeNotification:(NSNotification *)note {
//    [self obtainAccessToAccountsWithOptions:_accountsOptions block:^(BOOL granted, NSError *error) {
//
//    }];
}

@end

NSDictionary *AUQueryParameters(NSString *queryStr) {
    NSArray *query = [queryStr componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:[query count]];
    
    for(NSString *parameter in query)
    {
        NSArray *kv = [parameter componentsSeparatedByString:@"="];
        [parameters setObject:[kv count] > 1 ? [[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding] : [NSNull null]
                       forKey:[[kv objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding]];
    }
    
    return parameters;
}
