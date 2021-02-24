//
//  NSURL+Utils.m
//  WCKitDemo
//
//  Created by cheng on 2019/9/25.
//  Copyright © 2019 cheng. All rights reserved.
//

#import "NSURL+Utils.h"

@implementation NSURL (Utils)

+ (NSURL *)safeFileURLWithPath:(NSString *)path
{
    if (path) {
        return [self fileURLWithPath:path];
    }
    return nil;
}

@end
