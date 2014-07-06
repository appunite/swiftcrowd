//
//  SCAppService+Query.h
//  swiftcrowd
//
//  Created by Emil Wojtaszek on 05/07/14.
//  Copyright (c) 2014 AppUnite.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//Others
#import "SCAppService.h"

@class AUAccount;

@interface SCAppService (Query)

+ (void)createUserWithTwitterCredentials:(NSDictionary *)dict handler:(void (^)(AUAccount *account, BOOL success, NSError *error))handler;
- (void)fetchUserWithIds:(NSNumber *)ids handler:(void (^)(NSArray *users, NSError *error))handler;

@end
