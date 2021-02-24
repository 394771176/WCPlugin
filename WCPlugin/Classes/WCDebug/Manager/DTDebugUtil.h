//
//  WCDebugUtil.h
//  Pods-WCDebug_Example
//
//  Created by cheng on 2021/2/20.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <WCCategory/WCCategory.h>
#import <WCModel/DTFileManager.h>
#import "MBProgressHUDAdditions.h"
#import "UIView+DebugTest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DTDebugUtil : NSObject

+ (void)debugBlock:(void (^)(void))block;

//在window上展示图片或lottie
+ (void)showImageInWindow:(UIImage *)image;
//需要依赖lottie,外部自行实现
+ (void)showLottieInWindow:(NSString *)filePath;

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (void)addBlockOnMainThread:(void (^)(void))block;

+ (UIViewController *)rootController;
+ (UIViewController *)topController;

@end

NS_ASSUME_NONNULL_END
