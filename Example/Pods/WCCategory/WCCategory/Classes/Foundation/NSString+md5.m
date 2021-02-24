//
//  NSString+md5.m
//  WCKitDemo
//
//  Created by cheng on 2019/9/26.
//  Copyright © 2019 cheng. All rights reserved.
//

#import "NSString+md5.h"

@implementation NSString (md5)

- (NSString*)md5Hash
{
    if (self.length > 0) {
        return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
    }
    return nil;
}

- (NSString*)sha1Hash
{
    if (self.length > 0) {
        return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1Hash];
    }
    return nil;
}

@end
