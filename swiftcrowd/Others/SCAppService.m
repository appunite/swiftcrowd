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

- (void)enqueueOperation:(NSOperation *)op {
    [[[SCAppService sharedManager] operationQueue] addOperation:op];
}

- (void)enqueueRequest:(NSURLRequest *)request responseSerializer:(AFHTTPResponseSerializer <AFURLResponseSerialization> *)responseSerializer success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    // create operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = responseSerializer;
    
    // set onSuccess and onFailure blocks
    [operation setCompletionBlockWithSuccess:success failure:failure];
    
    // enqueue operation
    [self enqueueOperation:operation];
}

#pragma mark -
#pragma mark Private

+ (SCAppService *)httpManagerWithBaseURL:(NSURL *)baseURL {
    
    // create new http client
    SCAppService *httpManager = [[SCAppService alloc] initWithBaseURL:baseURL];
    
    // set JSON request serializer as default
    [httpManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    
    // setup default headers
    [httpManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    return httpManager;
}

@end
