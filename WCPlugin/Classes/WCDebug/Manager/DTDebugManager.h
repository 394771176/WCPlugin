//
//  DTDebugManager.h
//  DrivingTest
//
//  Created by cheng on 2019/1/10.
//  Copyright © 2019 eclicks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTDebugUtil.h"
#import "DTDebugLogInfoView.h"

typedef NS_ENUM(NSInteger, DTDebugLogType) {
    DTDebugLogTypeNone = 0,
    DTDebugLogTypeTxt = 1 << 0,
    DTDebugLogTypeVC = 1 << 1,
    DTDebugLogTypeUM = 1 << 2,
    DTDebugLogTypeURL = 1 << 3,
    DTDebugLogTypeAPI = 1 << 4,
    
    DTDebugLogTypeDefault = DTDebugLogTypeTxt| DTDebugLogTypeVC,
    DTDebugLogTypeALL = DTDebugLogTypeTxt| DTDebugLogTypeVC|DTDebugLogTypeUM|DTDebugLogTypeURL|DTDebugLogTypeAPI,
};

//0 测试服， 1 预发布， 2 正式服 , 枚举值不可改变
typedef NS_ENUM(NSInteger, DTDebugServerType) {
    DTDebugServerTypeTest = 0,
    DTDebugServerTypePre,
    DTDebugServerTypeProduct,
};

@class DTDebugLogInfoView;

@protocol DTDebugManagerProtocol <NSObject>

@optional

- (NSString *)getUserId;
- (NSDictionary *)getUserInfo;
- (NSDictionary *)getAPPInfo;
- (NSDictionary *)getSystemInfo;
- (void)QRCodeScanAction;
- (UIView *)getLottieViewWithFilePath:(NSString *)filePath;

@end

@interface DTDebugManager : NSObject <DTDebugManagerProtocol>

@property (nonatomic, assign) BOOL appDebug;//debug 开关

@property (nonatomic, assign) BOOL showFPS;//帧监控
@property (nonatomic, assign) BOOL showLog;//日志开关
@property (nonatomic, assign) BOOL holdRequest;//zhua包开关
@property (nonatomic, strong) NSString *holdProxy;//zhua包IP，开关开启后才有效， flutter使用;

@property (nonatomic, assign) BOOL useServerTime;//使用本地时间

@property (nonatomic, assign) DTDebugLogType logType;//日志类型

@property (nonatomic, assign) DTDebugServerType serverType;//服务器

@property (nonatomic, assign) BOOL appVerify;//审核
@property (nonatomic, strong) NSNumber *appVerifyValue;//审核

//=======日志=======
@property (nonatomic, strong) NSMutableAttributedString *logTxt;//这个可以清空，但可以在logHirtoryArray中找到
@property (nonatomic, strong) NSMutableArray *logHirtoryArray;

@property (nonatomic, weak) id<DTDebugManagerProtocol> delegate;

+ (instancetype)sharedInstance;

//default is WCDebug
+ (void)setupWithPassKey:(NSString *)passKey delegate:(id<DTDebugManagerProtocol>)delegate;

- (void)update;

- (void)changeLogType:(DTDebugLogType)type;
- (DTDebugLogInfoView *)logView;

- (BOOL)canShowLogType:(int)type;
- (void)showLogString:(NSString *)string type:(int)type;
- (void)clearLogText;

//口令： kjz + build版本号， 如：kjz7.8.4.1
- (BOOL)checkVerifyPassWithBlock:(void (^)(void))block;

+ (NSString *)currentServerTitle;
+ (void)showServerList:(void (^)(void))completion;

+ (void)removeAllFilesInDocument;

@end

