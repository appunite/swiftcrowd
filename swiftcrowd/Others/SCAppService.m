//
//  SCAppService.m
//  swiftcrowd
//
//  Created by Emil Wojtaszek on 05.07.2014.
//  Copyright (c) 2014 AppUnite.com. All rights reserved.
//

#import "SCAppService.h"

//Others
#import "AUAccount.h"
#import "SCConstants.h"

@implementation SCAppService

NSString *kAuthTokenHeaderKey = @"X-AUTH-TOKEN";

#pragma mark -
#pragma mark Class methods

+ (instancetype)sharedManager {
    static SCAppService *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // create base URL
        NSURL *url = [NSURL URLWithString:kAppServiceHost];
        
        // create default HTTP Client
        __sharedInstance = [SCAppService httpManagerWithBaseURL:url];
    });
    
    return __sharedInstance;
}

+ (void)enqueueOperation:(NSOperation *)op {
    [[[SCAppService sharedManager] operationQueue] addOperation:op];
}

+ (void)enqueueRequest:(NSURLRequest *)request responseSerializer:(AFHTTPResponseSerializer <AFURLResponseSerialization> *)responseSerializer success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    // create operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = responseSerializer;
    
    // set onSuccess and onFailure blocks
    [operation setCompletionBlockWithSuccess:success failure:failure];
    
    // enqueue operation
    [SCAppService enqueueOperation:operation];
}

#pragma mark -
#pragma mark Private

+ (SCAppService *)httpManagerWithBaseURL:(NSURL *)baseURL {
    
    // create new http client
    SCAppService *httpManager = [[SCAppService alloc] initWithBaseURL:baseURL];
    
    // update `X-AUTH-TOKEN` block
    void (^authTokenBlock)(void) = ^{
        // get auth token
        NSString *authToken = [[AUAccount account] authenticationToken:NULL];
        
        // add HTTP header
        [httpManager.requestSerializer setValue:authToken forHTTPHeaderField:kAuthTokenHeaderKey];
    };
    
    // set JSON request serializer as default
    [httpManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    
    // setup default headers
    [httpManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if ([[AUAccount account] isLoggedIn]) {
        // update `X-AUTH-TOKEN`
        authTokenBlock();
    }
    
    // we should invalidate that value on every login
    [[NSNotificationCenter defaultCenter] addObserverForName:AUAccountDidLoginUserNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // update `X-AUTH-TOKEN`
        authTokenBlock();
    }];
    
    // handle error globally
    [[NSNotificationCenter defaultCenter] addObserverForName:AFNetworkingOperationDidFinishNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *)[note object];
        
        // get response status code
        NSInteger statusCode = (NSInteger)[operation.response statusCode];
        
        // send error to Crashlytics if needed
        if (![operation.responseSerializer.acceptableStatusCodes containsIndex:statusCode] && statusCode > 99) {
            NSLog(@"HTTP Error: %li", (long)[operation.response statusCode]);
//            NSLog(@"HTTP Error: %li, %@", (long)[operation.response statusCode], [TTTURLRequestFormatter cURLCommandFromURLRequest:operation.request]);
        }
    }];
    
    return httpManager;
}

@end
