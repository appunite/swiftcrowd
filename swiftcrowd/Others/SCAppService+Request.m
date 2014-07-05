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

- (NSMutableURLRequest *)requestRegisterUserWithTwitterAccount:(NSString *)twitter {
    NSParameterAssert(twitter);
    
    return [self.requestSerializer requestWithMethod:@"POST"
                                           URLString:[NSString stringWithFormat:@"%@/api/v1/signup", kAppServiceHost]
                                          parameters:nil
                                               error:NULL];
}

- (NSMutableURLRequest *)fetchUserWithIds:(NSNumber *)ids {
    NSParameterAssert(ids);
   
    return [self.requestSerializer requestWithMethod:@"GET"
                                           URLString:[NSString stringWithFormat:@"%@/api/v1/users", kAppServiceHost]
                                          parameters:@{@"ids": ids}
                                               error:NULL];
}

@end
