//
//  SCAppUserResponseSerializer.m
//  swiftcrowd
//
//  Created by Karol Wojtaszek on 06.07.2014.
//  Copyright (c) 2014 AppUnite.com. All rights reserved.
//

#import "SCAppUserResponseSerializer.h"

//Models
#import "SCUser.h"

@implementation SCAppUserResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error {
    
    // get parsed JSON response
    NSDictionary *json = [super responseObjectForResponse:response data:data error:error];
    
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:NULL]) {
        // if exit method
        return json;
    }
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    NSDictionary *userJSON = json[@"user"];
    
    // serialize new map
    SCUser *userObject;
    
    // serialize paging object
    if (userJSON) {
        userObject = [MTLJSONAdapter modelOfClass:SCUser.class
                               fromJSONDictionary:userJSON
                                            error:error];
        
        result[@"user"] = userObject;
    }

    NSString *authToken = userJSON[@"authentication_token"];
    
    result[@"authentication_token"] = authToken;
    
    return result;
}

#pragma mark -
#pragma mark Class methods

+ (NSArray *)serializeUsersWithJSON:(NSArray *)usersJSON {
    // new collection array
    NSMutableArray *result = [NSMutableArray new];
    
    // enumerate all users
    [usersJSON enumerateObjectsUsingBlock:^(NSDictionary *userJSON, NSUInteger idx, BOOL *stop) {
        NSError *error = nil;
        
        // serialize new map
        SCUser *userObject;
        
        // serialize paging object
        if (usersJSON) {
            userObject = [MTLJSONAdapter modelOfClass:SCUser.class
                                   fromJSONDictionary:userJSON
                                                error:&error];
        }
        
        if (userObject) {
            [result addObject:userObject];
        }
        
        if (error) {
            NSLog(@"%@", error);
        }
    }];
    
    return [result copy];
}

@end

