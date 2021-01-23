#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "WCPlugin.h"
#import "CKFLAnimatedImageAdditions.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView+WebCache.h"
#import "FLAnimatedImageView.h"
#import "MBProgressHUD.h"
#import "MBProgressHUDAdditions.h"

FOUNDATION_EXPORT double WCPluginVersionNumber;
FOUNDATION_EXPORT const unsigned char WCPluginVersionString[];

