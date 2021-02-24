//
//  NSURL+Utils.h
//  WCKitDemo
//
//  Created by cheng on 2019/9/25.
//  Copyright © 2019 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Utils)

+ (NSURL *)safeFileURLWithPath:(NSString *)path;

@end
