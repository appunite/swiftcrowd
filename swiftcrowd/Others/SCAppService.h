//
//  SCAppService.h
//  swiftcrowd
//
//  Created by Emil Wojtaszek on 05.07.2014.
//  Copyright (c) 2014 AppUnite.com. All rights reserved.
//

// Frameworks
#import <Foundation/Foundation.h>

// AFNetworking
#import "AFNetworking.h"

@interface SCAppService : AFHTTPRequestOperationManager
// Return shared instance of `BCAppService`
+ (instancetype)sharedManager;

// enqueue operation in default NSOperation queue of `AFHTTPRequestOperationManager`
- (void)enqueueOperation:(NSOperation *)op;

// enqueue operation in default NSOperation queue of `AFHTTPRequestOperationManager`
- (void)enqueueRequest:(NSURLRequest *)request responseSerializer:(AFHTTPResponseSerializer <AFURLResponseSerialization> *)responseSerializer success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
