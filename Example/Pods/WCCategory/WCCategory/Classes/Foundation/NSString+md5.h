//
//  NSString+md5.h
//  WCKitDemo
//
//  Created by cheng on 2019/9/26.
//  Copyright © 2019 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+md5.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (md5)

@property (nonatomic, readonly) NSString *md5Hash;

@property (nonatomic, readonly) NSString *sha1Hash;

@end

NS_ASSUME_NONNULL_END
