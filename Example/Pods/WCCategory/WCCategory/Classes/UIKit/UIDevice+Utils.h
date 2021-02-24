//
//  UIDevice+Utils.h
//  WCKitDemo
//
//  Created by cheng on 2019/9/25.
//  Copyright © 2019 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Utils)

+ (NSString *)machineModel;
+ (NSString *)machineModelName;

+ (NSString *)clientUDID;

+ (NSString *)createUUID;

+ (BOOL)isJailbroken;

+ (BOOL)isIPhoneX;

@end
