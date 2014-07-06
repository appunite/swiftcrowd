//
//  SCUserRequestSerializer.m
//  swiftcrowd
//
//  Created by Emil Wojtaszek on 06/07/14.
//  Copyright (c) 2014 AppUnite.com. All rights reserved.
//

#import "SCUserResponseSerializer.h"

//Models
#import "SCUser.h"

@implementation SCUserResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error {
    
    // get parsed JSON response
    NSDictionary *json = [super responseObjectForResponse:response data:data error:error];
    
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:NULL]) {
        // if exit method
        return json;
    }
    
    // decompose JSON response
    NSArray *mapsJSON = json[@"users"];
    
    // serialize maps to mantle object
    NSArray *maps = [SCUserResponseSerializer serializeUsersWithJSON:mapsJSON];
    
    // create response object
    if (maps) {
        return @{@"users": maps};
    }
    
    return nil;
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
