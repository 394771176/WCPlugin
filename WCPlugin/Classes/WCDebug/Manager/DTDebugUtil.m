//
//  WCDebugUtil.m
//  Pods-WCDebug_Example
//
//  Created by cheng on 2021/2/20.
//

#import "DTDebugUtil.h"
#import "UIView+DebugTest.h"
#import "DTDebugDragView.h"
#import "DTDebugManager.h"

@implementation DTDebugUtil

+ (void)debugBlock:(void (^)(void))block
{
#ifdef DEBUG
    if (block) {
        block();
    }
#endif
}

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    return item;
}

+ (void)addBlockOnMainThread:(void (^)(void))block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}

+ (UIViewController *)rootController
{
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

+ (UIViewController *)topController
{
    UINavigationController *nav = (id)[self rootController];
    while (nav.presentedViewController) {
        if ([nav.presentedViewController isKindOfClass:[UIAlertController class]]) {
            break;
        }
        nav = (id)nav.presentedViewController;
    }
    if ([nav isKindOfClass:UINavigationController.class]) {
        return nav.topViewController;
    } else {
        return nav;
    }
}

+ (void)showImageInWindow:(UIImage *)image
{
    [self debugBlock:^{
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        imgV.image = image;
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        imgV.backgroundColor = [UIColor colorWithString:@"000000" alpha:0.4];
        [[UIApplication sharedApplication].delegate.window addSubview:imgV];
        
        [imgV autoRemoveByTapSelf];
    }];
}

+ (void)showLottieInWindow:(NSString *)filePath
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    DTDebugDragBgView *bgview = [[DTDebugDragBgView alloc] initWithFrame:window.bounds];
    bgview.dismissBlock = ^{
        [DTFileManager deleteItemWithPath:filePath];
    };
    [window addSubview:bgview];
    //测试代码，方便设计看效果
//    DTLottieView *lottieView = [[DTLottieView alloc] initWithFrame:bgview.bounds];
//    lottieView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    lottieView.userInteractionEnabled = NO;
    UIView *lottieView = [[DTDebugManager sharedInstance] getLottieViewWithFilePath:filePath];
    [bgview addSubview:lottieView];
    
//    lottieView.loadContentCompletionBlock = ^(DTLottieView *view, NSInteger type, CGSize size) {
//        if (!CGSizeEqualToSize(size, CGSizeZero)) {
//            [bgview setFixCenterWidth:size.width height:size.height];
//        }
//    };
//
//    if ([filePath rangeOfString:@"/"].length) {
//        [lottieView setLocalJsonPath:filePath];
//    } else {
//        [lottieView setLocalJsonName:filePath];
//    }

}

@end
