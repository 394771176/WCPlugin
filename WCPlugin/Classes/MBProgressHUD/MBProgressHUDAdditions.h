//
//  MBProgressHUDAdditions.h
//  CLChatDemo
//
//  Created by R_flava_Man on 2017/5/5.
//  Copyright © 2017年 R_style_Man. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface MBProgressHUD (VendorAdditions)

+ (MBProgressHUD *)findCurrentHUD;
+ (MBProgressHUD *)findCurrentHUDFromView:(UIView *)view;

+ (void)showHUDMessageInWindow:(NSString *)msg;
+ (void)showHUDMessageInWindow:(NSString *)msg textOffset:(CGFloat)offset;

+ (void)showHUDErrorHintInWindow:(NSString *)msg;
+ (void)showHUDSuccessHintInWindow:(NSString *)msg;
+ (void)showHUDNoNetworkHintInWindow:(NSString *)msg;

+ (void)showHUDInWindowWithImage:(NSString *)imageName andMessage:(NSString *)msg;

#pragma mark - loading时 HUD 需要手动stop

+ (void)showHUDLoadingMessageInWindow:(NSString *)text;
+ (void)stopHUDLoading;
+ (void)stopLoadingHUD:(NSTimeInterval)delay;

+ (void)stopHUDLoadingFormView:(UIView *)view;

@end
