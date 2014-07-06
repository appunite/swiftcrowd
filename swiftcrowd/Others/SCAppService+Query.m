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

@implementation SCAppService (Query)

- (void)registerDeviceWithHandler:(void (^)(BOOL success, NSError *error))handler {
//    // get device uuid
//    NSString *uuid = [BCAccount deviceIdentifier];
//    
//    // prepare request
//    NSMutableURLRequest *request = [[BCAppService sharedManager] requestRegisterDeviceWithUUID:uuid];
//
//    // enqueue request
//    [BCAppService enqueueRequest:request responseSerializer:[AFJSONResponseSerializer serializer]
//                         success:^(AFHTTPRequestOperation *operation, NSDictionary *response) {
//                             // save device id
//                             [[BCAccount account] updateUser:response];
//                             
//                             // fire block if any
//                             if (handler) handler(YES, nil);
//                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                             if (handler) handler(NO, error);
//                         }];
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
