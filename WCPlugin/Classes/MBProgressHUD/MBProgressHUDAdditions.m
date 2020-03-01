//
//  MBProgressHUDAdditions.m
//  CLChatDemo
//
//  Created by R_flava_Man on 2017/5/5.
//  Copyright © 2017年 R_style_Man. All rights reserved.
//

#import "MBProgressHUDAdditions.h"

@interface MBProgressHUDAdditions: NSObject

@end

@implementation MBProgressHUDAdditions

@end

@implementation MBProgressHUD (VendorAdditions)

+ (MBProgressHUD *)showHUDMessageInWindow:(NSString *)msg
{
    return [self showHUDMessageInWindow:msg textOffset:0];
}

+ (MBProgressHUD *)showHUDMessageInWindow:(NSString *)msg textOffset:(CGFloat)offset
{
    MBProgressHUD *hud = [self HUD];
    hud.mode = MBProgressHUDModeText;
    hud.userInteractionEnabled = NO;
    hud.labelText = msg;
    hud.opacity = .7f;
    hud.margin = 10.f;
    hud.yOffset = offset;
    [hud show:YES];
    [hud hide:YES afterDelay:2];
    return hud;
}

+ (MBProgressHUD *)showHUDErrorHintInWindow:(NSString *)msg
{
    MBProgressHUD *hud = [self HUD];
    hud.customView = [[UIImageView alloc] initWithImage:[self bundleImageWithName:@"37x-Error"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.userInteractionEnabled = NO;
    hud.labelText = msg;
    [hud show:YES];
    [hud hide:YES afterDelay:1.5f];
    return hud;
}

+ (MBProgressHUD *)showHUDSuccessHintInWindow:(NSString *)msg
{
    MBProgressHUD *hud = [self HUD];
    hud.customView = [[UIImageView alloc] initWithImage:[self bundleImageWithName:@"37x-Success"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.userInteractionEnabled = NO;
    hud.labelText = msg;
    [hud show:YES];
    [hud hide:YES afterDelay:1.5f];
    return hud;
}

+ (MBProgressHUD *)showHUDNetworkHintInWindow:(NSString *)msg
{
    MBProgressHUD *hud = [self HUD];
    hud.customView = [[UIImageView alloc] initWithImage:[self bundleImageWithName:@"37x-Error"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.userInteractionEnabled = NO;
    hud.labelText = msg;
    [hud show:YES];
    [hud hide:YES afterDelay:1.5f];
    return hud;
}

+ (MBProgressHUD *)showHUDInWindowWithImage:(NSString *)imageName andMessage:(NSString *)msg
{
    MBProgressHUD *hud = [self HUD];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.userInteractionEnabled = NO;
    hud.labelText = msg;
    [hud show:YES];
    [hud hide:YES afterDelay:1.5f];
    return hud;
}

#pragma mark - loading时 HUD 需要手动stop

+ (void)showHUDLoadingMessageInWindow:(NSString *)text
{
    MBProgressHUD *hud = [self HUD];
    hud.labelText = text;
    hud.labelFont = [UIFont systemFontOfSize:16.f];
    hud.userInteractionEnabled = YES;
    hud.mode = MBProgressHUDModeIndeterminate;
}

+ (void)stopHUDLoading
{
    MBProgressHUD *loadingHud = [self findCurrentHUD];
    [loadingHud hide:YES];
}

+ (void)stopLoadingHUD:(NSTimeInterval)delay
{
    MBProgressHUD *loadingHud = [self findCurrentHUD];
    [loadingHud hide:YES afterDelay:delay];
}

+ (MBProgressHUD *)HUD
{
    MBProgressHUD *hud = [self findCurrentHUD];
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    } else {
        [hud show:NO];
    }
    return hud;
}

+ (MBProgressHUD *)findCurrentHUD
{
    NSArray *subviews = [[[UIApplication sharedApplication].delegate window] subviews];
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[MBProgressHUD class]] && subview.tag != DEBUG_ANALYTICS_TAG && subview.tag != DEBUG_REFER_ANALYTICS_TAG) {
            MBProgressHUD *hud = (MBProgressHUD *)subview;
            return hud;
        }
    }
    return nil;
}

+ (UIImage *)bundleImageWithName:(NSString *)name
{
    NSString *bundlePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"WCPluginResource" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
}

@end
