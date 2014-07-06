//
//  SCAppService+Request.h
//  swiftcrowd
//
//  Created by Emil Wojtaszek on 05/07/14.
//  Copyright (c) 2014 AppUnite.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//Others
#import "SCAppService.h"

@interface SCAppService (Request)

/**
 *  Prepare POST request to register user's device
 *
 *  @param twitter Twitter account name
 *
 *  @return `NSMutableURLRequest` object
 */
- (NSMutableURLRequest *)requestRegisterUserWithTwitterAccount:(NSString *)twitter;

/**
 *  Prepare GET request to fetch users
 *
 *  @param ids unique identifiers of users
 *
 *  @return `NSMutableURLRequest` object
 */
- (NSMutableURLRequest *)requestFetchUserWithIds:(NSNumber *)ids;

@end
