//
//  DTDebugLogControllerView.m
//  DrivingTest
//
//  Created by cheng on 2019/1/10.
//  Copyright © 2019 eclicks. All rights reserved.
//

#import "DTDebugLogInfoView.h"
#import "DTDebugManager.h"
#import "DTDebugViewController.h"

void DT_Debug_Log(int type, NSString *format, ...)
{
    if ([[DTDebugManager sharedInstance] canShowLogType:type]) {
        va_list ap;
        va_start(ap, format);
        NSString *string = [[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:ap];
        va_end(ap);
        [[DTDebugManager sharedInstance] showLogString:string type:type];
    }
}

@protocol CurrentControllerProtocol <NSObject>

@optional
- (id)currentController;

@end

@interface DTDebugLogInfoView () {
    UIWindow *_controlWindow;
    UIControl *_controlBtn;
    
    NSArray *_toolTitles;
    NSArray *_logTypes;
    NSMutableArray<UIButton *> *_typeBtns;
    
    UITextView *_textView;
}

@end

@implementation DTDebugLogInfoView

- (void)update
{
//    UILabel *label = [_controlBtn viewWithTag:888];
//    label.hidden = ![DTDebugManager sharedInstance].showLog;
    _controlWindow.hidden = ![DTDebugManager sharedInstance].showLog;
    if (![DTDebugManager sharedInstance].showLog) {
        self.hidden = YES;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    //    self = [super initWithFrame:frame];
    self = [super initWithFrame:CGRectMake(40, 64, [UIScreen mainScreen].bounds.size.width - 80, [UIScreen mainScreen].bounds.size.height - 40 - 40 - 80 - 70)];
    if (self) {
        _toolTitles = @[@"清空", @"刷新", @"穿透", @"拷贝", @"永久关闭"];
        [_toolTitles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self btnWithTitle:obj index:idx];
        }];
        
        _typeBtns = [NSMutableArray array];
        _logTypes = @[@"Txt",@"VC",@"UM",@"H5",@"API"];
        [_logTypes enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_typeBtns safeAddObject:[self btnWithType:obj index:idx]];
        }];
        
        // text view
        UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 40,self.width, self.height - 80)];
        textView.font = [UIFont systemFontOfSize:13.0f];
        textView.backgroundColor = [UIColor clearColor];
        [textView setScrollEnabled:YES];
        textView.editable = NO;
        textView.userInteractionEnabled = YES;
        textView.showsVerticalScrollIndicator = YES;
        [self addSubview:textView];
        _textView = textView;
        
        [self setupControl];
        [self updateTypeBtnStatus];
        
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    }
    return self;
}

- (void)setupControl
{
    CGFloat height = 20;
    BOOL isIPhoneX = IS_iPhoneX;
    if (isIPhoneX) {
        height = 40;
    }
    _controlWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 83, height)];
    _controlWindow.windowLevel = UIWindowLevelStatusBar + 1;
    _controlWindow.hidden = NO;// = make Visible, 但不会变成keyWindow
    //    [_controlWindow makeKeyAndVisible];
    
    if (isIPhoneX) {
        _controlWindow.origin = CGPointMake(100, 30);
    }
    
    _controlBtn = [[UIControl alloc] initWithFrame:CGRectMake(3, 0, 80, _controlWindow.height)];
    [_controlBtn addTarget:self action:@selector(controlBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:_controlBtn.bounds];
    label.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
    //    label.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:1.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Debug Log";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13];
    label.tag = 888;
    [_controlBtn addSubview:label];
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapControlAction:)];
    //    gesture.numberOfTapsRequired = 2;
    gesture.minimumPressDuration = 0.5;
    [_controlBtn addGestureRecognizer:gesture];
    //    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [_controlWindow addSubview:_controlBtn];
}

- (UIButton *)btnWithTitle:(NSString *)title index:(NSInteger)index
{
    CGFloat width = self.width / _toolTitles.count;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(width * index, 0, width, 44);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn addTarget:self action:@selector(toolBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    btn.tag = index;
    [self addSubview:btn];
    return btn;
}

- (UIButton *)btnWithType:(NSString *)type index:(NSInteger)index
{
    CGFloat width = self.width / _logTypes.count;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(width * index, self.height - 40, width, 40);
    [btn setTitle:type forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btn addTarget:self action:@selector(typeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [btn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    btn.tag = index;
    [self addSubview:btn];
    return btn;
}

- (void)toolBtnAction:(UIButton *)sender
{
    static int index = 0;
    index += sender.tag;
    switch (sender.tag) {
        case 0:
            [[DTDebugManager sharedInstance] clearLogText];
            _textView.text = nil;
            index = 0;
            break;
        case 1:
            [self refresh];
            if (index == 2) {
                [self showWindowAndView];
            } else if (index == 3) {
                [self showSubViewList:nil];
            }
            break;
        case 2:
            self.userInteractionEnabled = NO;
            break;
        case 3:
        {
            NSString *string = [DTDebugManager sharedInstance].logTxt.string;
            if (string.length) {
                [UIPasteboard generalPasteboard].string = string;
            } else {
                NSArray *array = [DTDebugManager sharedInstance].logHirtoryArray;
                if (array.count) {
                    [UIPasteboard generalPasteboard].string = [array JSONString];
                }
            }
        }
            break;
        case 4:
            [DTDebugManager sharedInstance].showLog = NO;
            break;
        default:
            break;
    }
}

- (void)typeBtnAction:(UIButton *)sender
{
    DTDebugLogType type = pow(2, sender.tag);
    [[DTDebugManager sharedInstance] changeLogType:type];
    
    [self updateTypeBtnStatus];
}

- (void)controlBtnAction
{
    if ([DTDebugManager sharedInstance].showLog) {
        if (!self.superview) {
            [[UIApplication sharedApplication].delegate.window addSubview:self];
        } else {
            if (self.hidden) {
                self.hidden = NO;
            } else if (!self.userInteractionEnabled) {
                self.userInteractionEnabled = YES;
            } else {
                [self removeFromSuperview];
            }
        }
    }
}

- (void)tapControlAction:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        DTDebugViewController *controller = [[DTDebugViewController alloc] init];
        [[DTDebugUtil topController].navigationController pushViewController:controller animated:YES];
    }
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    if (userInteractionEnabled) {
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    } else {
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3];
    }
}

- (void)updateTypeBtnStatus
{
    DTDebugLogType logType = [DTDebugManager sharedInstance].logType;
    [_typeBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull sender, NSUInteger idx, BOOL * _Nonnull stop) {
        DTDebugLogType type = pow(2, sender.tag);
        if ((logType & type) > 0) {
            sender.selected = YES;
        } else {
            sender.selected = NO;
        }
    }];
}

- (void)refresh {
    
    if (!self.isHidden) {
        UIViewController *topVC = [DTDebugUtil topController];
        UIViewController<CurrentControllerProtocol> *currentVC = (id)topVC;
        while ([currentVC respondsToSelector:@selector(currentController)]) {
            id vc = [currentVC currentController];
            if (vc && vc != currentVC) {
                currentVC = vc;
            }
        }
        [self showLogString:[NSString stringWithFormat:@"当前控制器: %@",NSStringFromClass(currentVC.class)] type:DTDebugLogTypeVC];
        
        if (topVC.navigationController) {
            for (NSInteger i = 0; i < topVC.navigationController.viewControllers.count; i ++) {
                UIViewController *vc = [topVC.navigationController.viewControllers objectAtIndex:i];
                [self showLogString:[NSString stringWithFormat:@"###nav.vcs[%ld]: %@", i, NSStringFromClass(vc.class)] type:DTDebugLogTypeVC];
            }
        }
    }
}

- (void)showWindowAndView
{
    [self showLogString:[NSString stringWithFormat:@"windows: %@ \n keyWindow: %@", [UIApplication sharedApplication].windows,  [UIApplication sharedApplication].keyWindow] type:DTDebugLogTypeVC];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:APP_DEBUG_LOG_INFO_EVENT object:nil];
}

- (void)showSubViewList:(UIView *)view
{
    if (!view) {
        view = [DTDebugUtil rootController].view;
    }
    if (view.subviews) {
        [self showLogString:[NSString stringWithFormat:@"%@ subViews: %@", view, view.subviews] type:DTDebugLogTypeVC];
    }
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self showSubViewList:obj];
    }];
}

- (void)showLogString:(NSString *)string type:(int)type
{
    [[DTDebugManager sharedInstance] showLogString:string type:type];
}

- (void)showLogAttrString:(NSAttributedString *)attrString
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(realShowLogAttrString:) object:attrString];
    [self performSelector:@selector(realShowLogAttrString:) withObject:attrString afterDelay:0.5];
}

- (void)realShowLogAttrString:(NSAttributedString *)attrString
{
    [DTDebugUtil addBlockOnMainThread:^{
        _textView.attributedText = attrString;
        
        if(attrString.length > 0) {
            [_textView scrollRangeToVisible:NSMakeRange(attrString.length - 1, 1)];
        }
    }];
}

@end

