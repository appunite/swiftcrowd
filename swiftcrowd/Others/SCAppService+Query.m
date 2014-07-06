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

+ (void)createUserWithTwitterCredentials:(NSDictionary *)dict handler:(void (^)(AUAccount *account, BOOL success, NSError *error))handler {
    NSMutableURLRequest *request = [[SCAppService sharedManager] requestRegisterUserWithTwitterTokens:dict];
    
    [[SCAppService sharedManager] enqueueRequest:request responseSerializer:[SCAppUserResponseSerializer serializer] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        AUAccount *sharedAccount = [AUAccount account];
        [sharedAccount setAuthenticationToken:responseObject[@"authentication_token"] error:nil];
        [sharedAccount updateUser:responseObject[@"user"]];
        
        handler(sharedAccount, YES, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, NO, error);
    }];
    
}

- (void)fetchUserWithIds:(NSNumber *)ids handler:(void (^)(NSArray *users, NSError *error))handler {
    // prepare request
    NSMutableURLRequest *request = [[SCAppService sharedManager] requestFetchUserWithIds:ids];

    // enqueue request
    [self enqueueRequest:request responseSerializer:[SCUserResponseSerializer serializer]
                 success:^(AFHTTPRequestOperation *operation, NSDictionary *response) {
                     
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     
                 }];
}

@end
