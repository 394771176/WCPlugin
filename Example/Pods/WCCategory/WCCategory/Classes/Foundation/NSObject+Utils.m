//
//  NSObject+Utils.m
//  WCKitDemo
//
//  Created by cheng on 2019/9/26.
//  Copyright © 2019 cheng. All rights reserved.
//

#import "NSObject+Utils.h"

BOOL IsEmpty(id value)
{
    return [NSObject checkIsEmpty:value];
}

@implementation NSObject (Utils)

+ (BOOL)checkIsEmpty:(id)value
{
    if (!value || value == [NSNull null]) {
        return YES;
    } else if ([value isKindOfClass:[NSString class]]) {
        NSString *tempStr = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([tempStr length] == 0 || [value isEqualToString:@"NULL"] || [value isEqualToString:@"null"] || [value isEqualToString:@"(null)"]) {
            return YES;
        }
    } else if ([value isKindOfClass:[NSData class]]) {
        return ([value respondsToSelector:@selector(length)] && [(NSData *)value length] == 0);
    } else if ([value isKindOfClass:[NSArray class]]) {
        return ([value respondsToSelector:@selector(count)] && [(NSArray *)value count] == 0);
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        return ([value respondsToSelector:@selector(count)] && [(NSDictionary *)value count] == 0);
    }
    return NO;
}

@end
