//
//  SCAppService+Request.m
//  swiftcrowd
//
//  Created by Emil Wojtaszek on 05/07/14.
//  Copyright (c) 2014 AppUnite.com. All rights reserved.
//

#import "SCAppService+Request.h"

//Others
#import "SCConstants.h"

@implementation SCAppService (Request)

- (NSMutableURLRequest *)requestRegisterUserWithTwitterTokens:(NSDictionary *)twitterTokens {
    NSParameterAssert(twitterTokens);
    
    return [self.requestSerializer requestWithMethod:@"POST"
                                           URLString:[NSString stringWithFormat:@"%@/api/v1/token", kAppServiceHost]
                                          parameters:@{@"twitter": twitterTokens}
                                               error:NULL];
    
}

- (NSMutableURLRequest *)requestFetchUserWithIds:(NSArray *)ids {
    NSParameterAssert(ids);
   
    return [self.requestSerializer requestWithMethod:@"GET"
                                           URLString:[NSString stringWithFormat:@"%@/api/v1/users", kAppServiceHost]
                                          parameters:@{@"ids": [NSSet setWithArray:ids]}
                                               error:NULL];
}

@end
