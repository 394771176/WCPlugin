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

+ (void)showHUDMessageInWindow:(NSString *)msg
{
    return [self showHUDMessageInWindow:msg textOffset:0];
}

+ (void)showHUDMessageInWindow:(NSString *)msg textOffset:(CGFloat)offset
{
    MBProgressHUD *hud = [self HUD];
    hud.mode = MBProgressHUDModeText;
    hud.userInteractionEnabled = NO;
    hud.detailsLabelText = msg;
    hud.opacity = .7f;
    hud.margin = 15.f;
    hud.minSize = CGSizeMake(100, 50);
    hud.yOffset = offset;
    [self autoHideHUD:hud];
}

+ (void)showHUDErrorHintInWindow:(NSString *)msg
{
    MBProgressHUD *hud = [self HUD];
    hud.customView = [[UIImageView alloc] initWithImage:[self bundleImageWithName:@"37x-Error"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.userInteractionEnabled = NO;
    hud.detailsLabelText = msg;
    [self autoHideHUD:hud];
}

+ (void)showHUDSuccessHintInWindow:(NSString *)msg
{
    MBProgressHUD *hud = [self HUD];
    hud.customView = [[UIImageView alloc] initWithImage:[self bundleImageWithName:@"37x-Success"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.userInteractionEnabled = NO;
    hud.detailsLabelText = msg;
    [self autoHideHUD:hud];
}

+ (void)showHUDNoNetworkHintInWindow:(NSString *)msg
{
    MBProgressHUD *hud = [self HUD];
    hud.customView = [[UIImageView alloc] initWithImage:[self bundleImageWithName:@"37x-Error"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.userInteractionEnabled = NO;
    hud.detailsLabelText = msg;
    [self autoHideHUD:hud];
}

+ (void)showHUDInWindowWithImage:(NSString *)imageName andMessage:(NSString *)msg
{
    MBProgressHUD *hud = [self HUD];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.userInteractionEnabled = NO;
    hud.detailsLabelText = msg;
    [self autoHideHUD:hud];
}

+ (void)autoHideHUD:(MBProgressHUD *)hud
{
    if (hud.detailsLabelText.length > 10) {
        [hud hide:YES afterDelay:2.4f];
    } else {
        [hud hide:YES afterDelay:1.8f];
    }
}

#pragma mark - loading时 HUD 需要手动stop

+ (void)showHUDLoadingMessageInWindow:(NSString *)text
{
    MBProgressHUD *hud = [self HUD];
    hud.detailsLabelText = text;
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

+ (void)stopHUDLoadingFormView:(UIView *)view
{
    MBProgressHUD *loadingHud = [self findCurrentHUDFromView:view];
    [loadingHud hide:YES afterDelay:0.f];
}

#pragma mark - base method

+ (MBProgressHUD *)HUD
{
    MBProgressHUD *hud = [self findCurrentHUD];
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        hud.detailsLabelFont = hud.labelFont;
    } else {
        [hud show:NO];
    }
    return hud;
}

+ (MBProgressHUD *)findCurrentHUD
{
    return [self findCurrentHUDFromView:[[UIApplication sharedApplication].delegate window]];
}

+ (MBProgressHUD *)findCurrentHUDFromView:(UIView *)view
{
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[MBProgressHUD class]]) {
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
