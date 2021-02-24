//
//  DTDebugManager.m
//  DrivingTest
//
//  Created by cheng on 2019/1/10.
//  Copyright © 2019 eclicks. All rights reserved.
//

#import "DTDebugManager.h"
#import "JPFPSStatus.h"
#import "DTFileManager.h"

#define DTDebugManager_ShowLog   @"DTDebugManager.ShowLog"
#define DTDebugManager_ShowLogType   @"DTDebugManager.ShowLogType"
#define DTDebugManager_ShowFPS   @"DTDebugManager.ShowFps"
#define DTDebugManager_useServerTime   @"DTDebugManager.useServerTime"
#define DTDebugManager_HoldRequest   @"debug_open_proxy"
#define DTDebugManager_HoldProxy   @"DTDebugManager.HoldProxy"

#define DTDebugManager_ServerType @"DTDebugManager.ServerType"
#define DTDebugManager_APPDEBUG   @"DTDebugManager.APPDEBUG"
#define DTDebugManager_APPVerify   @"DTDebugManager.APPVerify"

#define DTDebugManager_APPPass   @"DTDebugManager.APPPass"

/*
 #ifdef DEBUG
 int APP_DEBUG = 1;
 #else
 #ifndef PRODUCTION
 int APP_DEBUG = 1;
 #else
 int APP_DEBUG = 0;
 #endif
 #endif
 */

@interface DTDebugManager ()
<UIActionSheetDelegate>
{
    DTDebugLogInfoView *_logView;
    
    BOOL _fpsInit;
}

@property (nonatomic, assign) BOOL verifyPass;//验证通过
@property (nonatomic, strong) void (^passBlock)(void);
@property (nonatomic, strong) void (^actionSheetBlock)(void);

@end

@implementation DTDebugManager

//static BOOL HAD_SETUP = NO;
static NSString *PassKey = @"WCDebug";

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self.class new];
    });
    return instance;
}

+ (void)setupWithPassKey:(NSString *)passKey delegate:(id<DTDebugManagerProtocol>)delegate
{
    if (passKey.length) {
        PassKey = passKey;
    }
    [[self sharedInstance] setDelegate:delegate];
    [[self sharedInstance] update];
}

- (DTDebugLogInfoView *)logView
{
    return _logView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupDefaultValue];
        
        NSNumber *appDebug = [[NSUserDefaults standardUserDefaults] objectForKey:DTDebugManager_APPDEBUG];
        if (appDebug) {
            _appDebug = appDebug.boolValue;
        }
        
        NSNumber *appPass = [[NSUserDefaults standardUserDefaults] objectForKey:DTDebugManager_APPPass];
        if (appPass) {
            _verifyPass = appPass.boolValue;
        }
        
        //网络库里逻辑，不受debug控制
        NSNumber *holdRequest = [[NSUserDefaults standardUserDefaults] objectForKey:DTDebugManager_HoldRequest];
        if (holdRequest) {
            _holdRequest = holdRequest.boolValue;
        } else if (_holdRequest) {
            [self setHoldRequest:_holdRequest];
        }
        
        NSString *holdProxy = [[NSUserDefaults standardUserDefaults] objectForKey:DTDebugManager_HoldProxy];
        if (holdProxy) {
            _holdProxy = holdProxy;
        }
        
        if (_verifyPass) {
            NSNumber *showLog = [[NSUserDefaults standardUserDefaults] objectForKey:DTDebugManager_ShowLog];
            NSNumber *showFps = [[NSUserDefaults standardUserDefaults] objectForKey:DTDebugManager_ShowFPS];
            NSNumber *logType = [[NSUserDefaults standardUserDefaults] objectForKey:DTDebugManager_ShowLogType];
            NSNumber *useServerTime = [[NSUserDefaults standardUserDefaults] objectForKey:DTDebugManager_useServerTime];
            NSNumber *serverType = [[NSUserDefaults standardUserDefaults] objectForKey:DTDebugManager_ServerType];
            NSNumber *appVerify = [[NSUserDefaults standardUserDefaults] objectForKey:DTDebugManager_APPVerify];
            self.appVerifyValue = appVerify;
            
            if (showLog) {
                _showLog = showLog.boolValue;
            }
            
            if (showFps) {
                _showFPS = showFps.boolValue;
            }
            
            if (logType) {
                _logType = logType.integerValue;
            }
            
            if (useServerTime) {
                _useServerTime = useServerTime.boolValue;
            }

            if (serverType) {
                _serverType = (DTDebugServerType)serverType.integerValue;
            }
            
            if (appVerify) {
                _appVerify = appVerify.boolValue;
            }
        }
    }
    return self;
}

- (void)setupDefaultValue
{
    
#ifdef PRODUCTION
   _serverType = DTDebugServerTypeProduct;
    #ifdef DEBUG
    _appDebug = YES;
    _verifyPass = YES;
    #endif
#else
   
    _appDebug = YES;
    _verifyPass = YES;
    
    #ifdef DEBUG
    _serverType = DTDebugServerTypeTest;
    #else
    _serverType = DTDebugServerTypeProduct;
    #endif
    
    #ifdef APP_SERVER_TYPE
    _serverType = APP_SERVER_TYPE;
    #endif
    
#endif
    
    if (_appDebug) {
        _showLog = YES;
        _showFPS = YES;
        _logType = DTDebugLogTypeDefault;
        
        _holdRequest = YES;
        _useServerTime = NO;
    } else {
        _useServerTime = YES;
    }
}

- (void)update
{
    if (_showLog) {
        if (!_logView) {
            _logView = [[DTDebugLogInfoView alloc] init];
        }
    }
    if (_logView) {
        [_logView update];
    }
    
    if (_showFPS) {
        _fpsInit = YES;
        [[JPFPSStatus sharedInstance] open];
    } else {
        if (_fpsInit) {
            [[JPFPSStatus sharedInstance] close];
        }
    }
}

- (void)setShowLog:(BOOL)showLog
{
    _showLog = showLog;
    [[NSUserDefaults standardUserDefaults] setBool:showLog forKey:DTDebugManager_ShowLog];
    [self update];
}

- (void)setShowFPS:(BOOL)showFPS
{
    _showFPS = showFPS;
    [[NSUserDefaults standardUserDefaults] setBool:showFPS forKey:DTDebugManager_ShowFPS];
    [self update];
}

- (void)setHoldRequest:(BOOL)holdRequest
{
    _holdRequest = holdRequest;
    [[NSUserDefaults standardUserDefaults] setBool:holdRequest forKey:DTDebugManager_HoldRequest];
}

- (void)setHoldProxy:(NSString *)holdProxy
{
    _holdProxy = holdProxy;
    [[NSUserDefaults standardUserDefaults] setObject:holdProxy forKey:DTDebugManager_HoldProxy];
}

- (void)setUseServerTime:(BOOL)useServerTime
{
    _useServerTime = useServerTime;
    [[NSUserDefaults standardUserDefaults] setBool:useServerTime forKey:DTDebugManager_useServerTime];
}

- (void)setServerType:(DTDebugServerType)serverType
{
    _serverType = serverType;
    [[NSUserDefaults standardUserDefaults] setInteger:serverType forKey:DTDebugManager_ServerType];
    
//    NSString *key = @"server_environment_config_key";
//    NSNumber *value = @233;
//    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
}

- (void)setAppDebug:(BOOL)appDebug
{
    _appDebug = appDebug;
    [[NSUserDefaults standardUserDefaults] setBool:appDebug forKey:DTDebugManager_APPDEBUG];
}

- (void)setAppVerify:(BOOL)appVerify
{
    _appVerify = appVerify;
    [[NSUserDefaults standardUserDefaults] setBool:appVerify forKey:DTDebugManager_APPVerify];
}

- (void)setVerifyPass:(BOOL)verifyPass
{
    _verifyPass = verifyPass;
    [[NSUserDefaults standardUserDefaults] setBool:verifyPass forKey:DTDebugManager_APPPass];
}

- (void)setLogType:(DTDebugLogType)logType
{
    _logType = logType;
    [[NSUserDefaults standardUserDefaults] setInteger:logType forKey:DTDebugManager_ShowLogType];
    [self update];
}

- (void)changeLogType:(DTDebugLogType)type
{
    if ((self.logType & type) > 0) {
        self.logType -= type;
    } else {
        self.logType += type;
    }
}

- (UIColor *)logColorForType:(int)type
{
    UIColor* logColor = nil;
    if (type == DTDebugLogTypeUM) {
        logColor = [UIColor greenColor];
    } else if (type == DTDebugLogTypeVC) {
        logColor = [UIColor cyanColor];
    } else if (type == DTDebugLogTypeAPI) {
        logColor = [UIColor redColor];
    } else if (type == DTDebugLogTypeURL) {
        logColor = [UIColor orangeColor];
    } else {
        logColor = [UIColor yellowColor];
    }
    return logColor;
}

- (BOOL)canShowLogType:(int)type
{
    if (self.showLog && (self.logType & type) > 0) {
        return YES;
    }
    return NO;
}

- (void)showLogString:(NSString *)string type:(int)type
{
    if (_logHirtoryArray) {
        _logHirtoryArray = [NSMutableArray array];
    }
    [_logHirtoryArray safeAddObject:string];
    
    UIColor* logColor = [self logColorForType:type];
    NSMutableAttributedString *logString = [[NSMutableAttributedString alloc] initWithString:[string stringByAppendingString:@"\n"]];
    [logString addAttribute:NSForegroundColorAttributeName value:logColor range:NSMakeRange(0, logString.length)];
    [logString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, logString.length)];
    
    if (!_logTxt) {
        _logTxt = [[NSMutableAttributedString alloc] init];
    }
    
    [_logTxt appendAttributedString:logString];
    NSLog(@"%@", logString);
    
    [_logView showLogAttrString:_logTxt];
}

- (void)clearLogText
{
    _logTxt = nil;
    [_logView showLogAttrString:nil];
}

// MARK :: 口令校验

- (BOOL)checkVerifyPassWithBlock:(void (^)(void))block
{
    if (_verifyPass) {
        if (block) {
            block();
        }
    } else {
        if (_passBlock) {
            _passBlock = nil;
        }
        _passBlock = block;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入识别码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView textFieldAtIndex:0].placeholder = @"请输入识别码";
        [alertView show];
    }
    return _verifyPass;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *string = [alertView textFieldAtIndex:0].text;
        if (string && [string isEqualToString:PassKey]) {
            self.verifyPass = YES;
            if (_passBlock) {
                _passBlock();
            }
        }
    }
    
    _passBlock = nil;
}

+ (NSString *)currentServerTitle
{
    DTDebugServerType type = [DTDebugManager sharedInstance].serverType;
    switch (type) {
        case DTDebugServerTypeTest:
            return @"测试服";
            break;
        case DTDebugServerTypePre:
            return @"预发布";
            break;
        default:
            return @"正式服";
            break;
    }
}

+ (void)showServerList:(void (^)(void))completion
{
    [[DTDebugManager sharedInstance] checkVerifyPassWithBlock:^{
        [DTDebugManager sharedInstance].actionSheetBlock = completion;
        NSString *title = [@"当前" stringByAppendingString:[self currentServerTitle]];
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title delegate:[DTDebugManager sharedInstance] cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        [sheet addButtonWithTitle:@"正式服"];
        [sheet addButtonWithTitle:@"预发布"];
        [sheet addButtonWithTitle:@"测试服"];
        [sheet showInView:[UIApplication sharedApplication].delegate.window];
    }];
}

+ (void)removeAllFilesInDocument
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSUserDefaults * defautls = [NSUserDefaults standardUserDefaults];
    [defautls removePersistentDomainForName:appDomain];
    
    NSArray *array = [DTFileManager contentsWithPath:DOC_PATH];
    for(NSString *file in array) {
        [DTFileManager deleteItemWithPath:DOC_PATH fileName:file];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *btnStr = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([btnStr isEqualToString:@"正式服"]) {
        [[DTDebugManager sharedInstance] setServerType:DTDebugServerTypeProduct];
    } else if ([btnStr isEqualToString:@"预发布"]) {
        [[DTDebugManager sharedInstance] setServerType:DTDebugServerTypePre];
    } else if ([btnStr isEqualToString:@"测试服"]) {
        [[DTDebugManager sharedInstance] setServerType:DTDebugServerTypeTest];
    }
    
    if (_actionSheetBlock && buttonIndex != actionSheet.cancelButtonIndex) {
        _actionSheetBlock();
    }
    _actionSheetBlock = nil;
}

#pragma mark - DTDebugManagerProtocol

- (NSString *)getUserId
{
    if (_delegate && [_delegate respondsToSelector:@selector(getUserId)]) {
        return [_delegate getUserId];
    }
    return nil;
}

- (NSDictionary *)getUserInfo
{
    if (_delegate && [_delegate respondsToSelector:@selector(getUserInfo)]) {
        return [_delegate getUserInfo];
    }
    return nil;
}

- (NSDictionary *)getAppInfo
{
    if (_delegate && [_delegate respondsToSelector:@selector(getAppInfo)]) {
        return [_delegate getAPPInfo];
    }
    return nil;
}

- (NSDictionary *)getSystemInfo
{
    if (_delegate && [_delegate respondsToSelector:@selector(getSystemInfo)]) {
        return [_delegate getUserInfo];
    }
    return nil;
}

- (void)QRCodeScanAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(QRCodeScanAction)]) {
        [_delegate QRCodeScanAction];
    }
}

- (UIView *)getLottieViewWithFilePath:(NSString *)filePath
{
    if (_delegate && [_delegate respondsToSelector:@selector(getLottieViewWithFilePath:)]) {
        [_delegate getLottieViewWithFilePath:filePath];
    }
    return UIView.new;
}

@end

