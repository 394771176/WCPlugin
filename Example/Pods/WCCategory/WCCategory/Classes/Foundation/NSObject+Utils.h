//
//  NSObject+Utils.h
//  WCKitDemo
//
//  Created by cheng on 2019/9/26.
//  Copyright © 2019 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+DTFix.h"

NS_ASSUME_NONNULL_BEGIN

extern BOOL IsEmpty(id value);

@interface NSObject (Utils)

+ (BOOL)checkIsEmpty:(id)value;

@end

NS_ASSUME_NONNULL_END
