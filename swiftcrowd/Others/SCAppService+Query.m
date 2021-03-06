//
//  SCAppService+Query.m
//  swiftcrowd
//
//  Created by Emil Wojtaszek on 05/07/14.
//  Copyright (c) 2014 AppUnite.com. All rights reserved.
//

#import "SCAppService+Query.h"

//Requests
#import "SCAppService+Request.h"

//Serializers
#import "SCUserResponseSerializer.h"
#import "SCAppUserResponseSerializer.h"

// models
#import <AUAccount.h>

@implementation SCAppService (Query)

+ (void)createUserWithTwitterCredentials:(NSDictionary *)dict handler:(void (^)(NSDictionary *userResponse, BOOL success, NSError *error))handler {
    NSMutableURLRequest *request = [[SCAppService sharedManager] requestRegisterUserWithTwitterTokens:dict];
    
    [[SCAppService sharedManager] enqueueRequest:request responseSerializer:[SCAppUserResponseSerializer serializer] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        handler(responseObject, YES, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, NO, error);
    }];
    
}

- (void)fetchUserWithIds:(NSArray *)ids handler:(void (^)(NSArray *users, NSError *error))handler {
    // prepare request
    NSMutableURLRequest *request = [[SCAppService sharedManager] requestFetchUserWithIds:ids];

    // enqueue request
    [self enqueueRequest:request responseSerializer:[SCUserResponseSerializer serializer]
                 success:^(AFHTTPRequestOperation *operation, NSDictionary *response) {
                     handler(response[@"users"], nil);
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     handler(nil, error);
                 }];
}

@end
