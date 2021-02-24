//
//  DTDebugLogInfoView.h
//  DrivingTest
//
//  Created by cheng on 2019/1/10.
//  Copyright © 2019 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DTLogTypeNormal = 0,
    DTLogTypeJiaKaoTouTiao,//驾考头条
} DTLogType;

#define DTLogTxt(...)   DT_Debug_Log(DTDebugLogTypeTxt, __VA_ARGS__)
#define DTLogVC(...)    DT_Debug_Log(DTDebugLogTypeVC, __VA_ARGS__)
#define DTLogUM(...)    DT_Debug_Log(DTDebugLogTypeUM, __VA_ARGS__)
#define DTLogAPI(...)   DT_Debug_Log(DTDebugLogTypeAPI, __VA_ARGS__)
#define DTLogURL(...)   DT_Debug_Log(DTDebugLogTypeURL, __VA_ARGS__)

#define APP_DEBUG_LOG_INFO_EVENT    @"app.debug.log.info.event"

extern void DT_Debug_Log(int type, NSString *format, ...);

@interface DTDebugLogInfoView : UIView

- (void)showLogString:(NSString *)string type:(int)type;
- (void)showLogAttrString:(NSAttributedString *)attrString;

- (void)update;

@end
