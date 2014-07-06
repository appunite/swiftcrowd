//
//  AUTwitterAuth.m
//  AUKit
//
//  Created by Emil Wojtaszek on 09.09.2012.
//  Copyright (c) 2012 AppUnite.com. All rights reserved.
//

#import "AUTwitterAuth.h"

//Others
#import "OAuthCore.h"
#import "AFNetworking.h"

#define TW_API_ROOT                  @"https://api.twitter.com"
#define TW_X_AUTH_REVERSE_PARMS      @"x_reverse_auth_parameters"
#define TW_X_AUTH_REVERSE_TARGET     @"x_reverse_auth_target"
#define TW_OAUTH_URL_REQUEST_TOKEN   @"/oauth/request_token"
#define TW_OAUTH_URL_AUTH_TOKEN      @"/oauth/access_token"
#define TW_OAUTH_URL_AUTH_VERITY     @"/1/account/verify_credentials.json"

@implementation AUTwitterAuth

#pragma mark -
#pragma mark Class methods

+ (instancetype)sharedInstance {
    static id __sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[[self class] alloc] init];
    });
    
    return __sharedInstance;
}

+ (NSString *)accountTypeIdentifier {
    return ACAccountTypeIdentifierTwitter;
}

#pragma mark -
#pragma mark Class methods

- (void)credentialForAccount:(ACAccount *)account consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret withHandler:(AUSocialAuthCredentialCompletionHandler)handler {
    NSParameterAssert(account);
    NSParameterAssert(consumerKey);
    NSParameterAssert(consumerSecret);
    
    AUTwitterReverseAuthenticationCompletionHandler reverseAuthenticationCompletionHandler = ^(NSDictionary* response, NSError *error) {
        // create access token URL
        NSURL *accessURL = [[NSURL alloc] initWithString:TW_OAUTH_URL_AUTH_TOKEN relativeToURL:[NSURL URLWithString:TW_API_ROOT]];
        // create twitter request with params
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:accessURL parameters:response];
        // assing account
        [request setAccount:account];
        
        // execute the request
        [request performRequestWithHandler: ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if (!error) {
                // get resosponce body as string
                NSString* bodyAsString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                // create dict of params
                NSDictionary *params = AUQueryParameters(bodyAsString);
                // fire handler with params
                handler(YES, @{AUSocialAuthOAuthTokenKey: params[@"oauth_token"], AUSocialAuthOAuthTokenSecretKey: params[@"oauth_token_secret"]}, nil);
            }
            
            else {
                handler(NO, nil, error);
            }
        }];
    };
    
    [self verifyCredentialForAccount:account withHandler:^(BOOL verified, NSError *error) {
        if (verified) {
            // perform reverse authentication
            [self reverseAuthenticationWithConsumerKey:consumerKey consumerSecret:consumerSecret withHandler:reverseAuthenticationCompletionHandler];
        }
        
        else {
            // renew credentials
            [self.accountStore renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                if (error) {
                    // fire completition block
                    handler(NO, nil, error); return;
                }

                // check if credential was renewed
                BOOL renewed = (renewResult == ACAccountCredentialRenewResultRenewed);
                if (renewed) {
                    // perform reverse authentication
                    [self reverseAuthenticationWithConsumerKey:consumerKey consumerSecret:consumerSecret withHandler:reverseAuthenticationCompletionHandler];
                }
                
                else {
                    handler(NO, nil, error);
                }
            }];
        }
    }];
}

- (void)reverseAuthenticationWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret withHandler:(AUTwitterReverseAuthenticationCompletionHandler)handler {
    NSParameterAssert(consumerKey);
    NSParameterAssert(consumerSecret);
    
    // create access token URL
    NSURL *accessURL = [[NSURL alloc] initWithString:TW_OAUTH_URL_REQUEST_TOKEN relativeToURL:[NSURL URLWithString:TW_API_ROOT]];

    // prepare token request
    NSMutableURLRequest *tokenRequest = [NSMutableURLRequest requestWithURL:accessURL];
    [tokenRequest setHTTPMethod:@"POST"];
    [tokenRequest setHTTPBody:[@"x_auth_mode=reverse_auth&" dataUsingEncoding:NSUTF8StringEncoding]];
    [tokenRequest setValue:OAuthorizationHeader(tokenRequest.URL, tokenRequest.HTTPMethod, tokenRequest.HTTPBody, consumerKey, consumerSecret, nil, nil) forHTTPHeaderField:@"Authorization"];
    [tokenRequest setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    [tokenRequest setHTTPShouldHandleCookies:NO];
    
    // create request operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:tokenRequest];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // get resosponce body as string
        NSString *bodyAsString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        // create new params dict
        NSDictionary* params = @{ TW_X_AUTH_REVERSE_TARGET : consumerKey, TW_X_AUTH_REVERSE_PARMS: bodyAsString };

        // fire completition block with success
        handler(params, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // fire completition block with failure
        handler(nil, error);
    }];
    
    // fire operation
    [operation start];
}

- (void)verifyCredentialForAccount:(ACAccount *)account withHandler:(void (^)(BOOL verified, NSError *error))handler {
    NSParameterAssert(account);

    // create access token URL
    NSURL *accessURL = [[NSURL alloc] initWithString:TW_OAUTH_URL_AUTH_VERITY relativeToURL:[NSURL URLWithString:TW_API_ROOT]];
    
    // create twitter request with params
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:accessURL parameters:nil];
    [request setAccount:account];

    // execute the request
    [request performRequestWithHandler: ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {

        dispatch_async(dispatch_get_main_queue(), ^{
            // call completition block
            handler(urlResponse.statusCode == 200, error);
        });
    }];
}

@end
