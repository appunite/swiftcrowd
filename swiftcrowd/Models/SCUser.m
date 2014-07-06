//
//  SCUser.m
//  swiftcrowd
//
//  Created by Emil Wojtaszek on 05/07/14.
//  Copyright (c) 2014 AppUnite.com. All rights reserved.
//

#import "SCUser.h"

//Others
#import "SCConstants.h"

@implementation SCUser

#pragma mark -
#pragma mark Mappings

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"uid": @"id",
        @"displayName": @"name",
        @"twitterAccount": @"twitter",
        @"asset": @"asset"
    };
}

#pragma mark -
#pragma mark Value transformers

+ (NSValueTransformer *)assetURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

- (NSURL *)assetURL {
    if (!self.asset) {
        return nil;
    }
    
    NSString *host = kAppServiceHost;
    NSString *assetURLString = [host stringByAppendingPathComponent:self.asset];
    
    return [NSURL URLWithString:assetURLString];
}

@end
