//
//  SCUser.h
//  swiftcrowd
//
//  Created by Emil Wojtaszek on 05/07/14.
//  Copyright (c) 2014 AppUnite.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface SCUser : MTLModel <MTLJSONSerializing>
// map id
@property (nonatomic, copy, readonly) NSNumber *uid;

// map name
@property (nonatomic, copy, readonly) NSString *displayName;
@property (nonatomic, copy, readonly) NSString *twitterAccount;

// image
@property (nonatomic, copy, readonly) NSString *asset;

- (NSURL *)assetURL;
@end
