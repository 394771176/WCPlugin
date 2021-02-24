//
//  WCDefine.h
//  WCKit
//
//  Created by cheng on 2019/9/25.
//  Copyright © 2019 cheng. All rights reserved.
//

#ifndef WCDefine_h
#define WCDefine_h

// 应用
#define APP_BUNDLE_ID           ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"])
#define APP_BUNDLE_NAME         ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"])
#define APP_DISPLAY_NAME        ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]?:APP_BUNDLE_NAME)
#define APP_VERSION_BUILD       ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])
#define APP_VERSION_SHORT       ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

#define STYTEM_VERSION_ARRAY    ([[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."])
#define STYTEM_VERSION_HEADER   ([STYTEM_VERSION_ARRAY count]>0?([STYTEM_VERSION_ARRAY[0] intValue]):0)
#define iOS(n)                  (STYTEM_VERSION_HEADER>=n)
#define AvailableiOS(n)         @available(iOS n, *)

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

#define IS_iPhoneX         [UIDevice isIPhoneX]

#define SCREEN_WIDTH        (CGRectGetWidth([UIScreen mainScreen].bounds))
#define SCREEN_HEIGHT       (CGRectGetHeight([UIScreen mainScreen].bounds))
#define SCREEN_SIZE         ([[UIScreen mainScreen] currentMode].size)
#define SCREEN_SCALE        ([UIScreen mainScreen].scale)

#define STATUSBAR_HEIGHT    (IS_iPhoneX ? 44.f : 20.f)

#define NAVBAR_HEIGHT       44.f

#define SAFE_BOTTOM_VIEW_HEIGHT  (IS_iPhoneX ? 20.f : 0.f)//自定义底部安全距离
#define SAFE_IPHONEX_BOTTOM_HEIGHT  (IS_iPhoneX ? 34.f : 0.f) //iphoneX 官方给出的安全区域

#define SAFE_BOTTOM_TITLE_EDGE_TOP_HEIGHT  (IS_iPhoneX ? -15.f : 0.f)//底部按钮文案适配X后 上移的距离

#define STRING(num)         [NSString stringWithFormat:@"%zd", (num)]
#define STRING_F(num)       [NSString stringWithFormat:@"%f", (num)]
#define STRING_INTF(num)    [NSString stringWithFormat:@"%.0f", (num)]

#define CELL_ID(str)        static NSString *cellId = @#str;

#define KEY(str)        static NSString * const str = @#str;

#define URL(str)            [NSURL URLWithString:str]

#define RGB(r, g, b)        RGBA(r, g, b, 1)
#define RGBA(r, g, b, a)    [UIColor colorWithRed:(float)(r)/255.0 green:(float)(g)/255.0 blue:(float)(b)/255.0 alpha:a]
#define RGB_A_RONDOM(a)     RGBA((arc4random_uniform(256)/255.f), (arc4random_uniform(256)/255.f), (arc4random_uniform(256)/255.f), a)

#define WHITE(w)            WHITE_A(w, 1)
#define WHITE_A(w, a)       [UIColor colorWithWhite:w alpha:a]

#define COLOR_RANDOM        RGBA_RONDOM(1)
#define COLOR_A_RANDOM      RGBA_RONDOM((0.2 + arc4random_uniform(5)/10.f))

#if __has_include(<WCCategory/WCCategory+UI.h>)

#define COLOR(str)          [UIColor colorWithHexString:@#str]
#define COLORS(str)         [UIColor colorWithHexString:str]

#endif

// 系统字体
#define FONT(size)      [UIFont systemFontOfSize:size]
#define FONT_B(size)    [UIFont boldSystemFontOfSize:size]
#define FONT_I(size)    [UIFont italicSystemFontOfSize:size]

#define SCALE_SCREEN_SIZE(size)                 ceil(SCREEN_WIDTH/375*(size))
#define SCALE_SCREEN_SIZE_PHONE(size)           ceil(MIN(SCREEN_WIDTH, 414.f)/375*(size))
#define SCALE_SCREEN_SIZE_PAD(size)             ceil(MIN(SCREEN_WIDTH, 600.f)/375*(size))

#define WEAK_SELF        __weak   __typeof(&*self) weakSelf = self;
#define STRONG_SELF      __strong __typeof(&*self) self = weakSelf;

#define kWeakObj(obj)   __weak typeof(obj) weak##obj = obj;
#define kStrongObj(obj)    __strong typeof(obj) obj = weak##obj;

#define WCBarItem(view)   [[UIBarButtonItem alloc] initWithCustomView:view]

#define PATH(name)  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:name]
#define BUNDLE(name, type)  [[NSBundle mainBundle] pathForResource:name ofType:type]

#define WC_Swizzle(_method1_, _method2_) \
{ \
Method originalInitMethod = class_getInstanceMethod(self, _method1_); \
Method modifiedInitMethod = class_getInstanceMethod(self, _method2_); \
method_exchangeImplementations(originalInitMethod, modifiedInitMethod); \
}

#define WC_Swizzle_Class(_method1_, _method2_) \
{ \
Method originalInitMethod = class_getClassMethod(self, _method1_); \
Method modifiedInitMethod = class_getClassMethod(self, _method2_); \
method_exchangeImplementations(originalInitMethod, modifiedInitMethod); \
}

#define SHARED_INSTANCE_H  + (instancetype)sharedInstance;
#define SHARED_INSTANCE_M  \
+ (instancetype)sharedInstance \
{ \
static id instance = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [self.class new]; \
}); \
return instance; \
}


#endif /* WCDefine_h */
