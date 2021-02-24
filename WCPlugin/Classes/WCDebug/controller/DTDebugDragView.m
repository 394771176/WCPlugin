//
//  DTDebugDragView.m
//  DrivingTest
//
//  Created by cheng on 2020/11/17.
//  Copyright © 2020 eclicks. All rights reserved.
//

#import "DTDebugDragView.h"
#import "DTDebugUtil.h"

@interface DTDebugDragView () {
    
}

@end

@implementation DTDebugDragView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithString:@"FF1234" alpha:0.3];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:pan];
        
//        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
//        [self addGestureRecognizer:longPress];
        [self autoRemoveByLongTapSelf];
    }
    return self;
}

- (void)panAction:(UIPanGestureRecognizer *)gesture
{
    if (self.superview) {
        CGPoint point = [gesture translationInView:self.superview];
        self.center = CGPointMake(self.center.x + point.x, self.center.y + point.y);
        [gesture setTranslation:CGPointZero inView:self.superview];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (void)removeFromSuperview
{
    if (_dismissBlock) {
        _dismissBlock();
    }
    [super removeFromSuperview];
}

//- (void)longPressAction:(UILongPressGestureRecognizer *)gesture
//{
//    if (gesture.state == UIGestureRecognizerStateBegan) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"自定义视图" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
//        [[alertView textFieldAtIndex:0] setPlaceholder:@"宽 * 高 （一倍大小）"];
//        [[alertView textFieldAtIndex:0] setText:[NSString stringWithFormat:@"%.0f * %.0f", self.width , self.height]];
//        [alertView show];
//    }
//}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        [self removeFromSuperview];
//    } else {
//        NSString *str = [alertView textFieldAtIndex:0].text;
//        if (str.length &&  [str rangeOfString:@"*"].length) {
//            NSArray *array = [str componentsSeparatedByString:@"*"];
//            if (array.count == 2) {
//                CGFloat width = [array.firstObject floatValue];
//                CGFloat height = [array.lastObject floatValue];
//                self.size = CGSizeMake(width, height);
//            }
//        }
//    }
//}

@end

@interface DTDebugDragSizeView () {
    UIView *_sizeView;
    UILabel *_sizeLabel;
    
    /*
   1     2      3
      _______
     |       |
   8 |       |  4
     |       |
      -------
   7     6     5
     
     */
    NSInteger _changeSizeType;//1 ~ 8
}

@end

@implementation DTDebugDragSizeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        
        _sizeView = [[UIView alloc] initWithFrame:CGRectMake(25, 25, self.width - 50, self.height - 50)];
        _sizeView.backgroundColor = [UIColor colorWithRed:1 green:0.1 blue:0.1 alpha:0.3];
        _sizeView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_sizeView];
        
        _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 25)];
        _sizeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _sizeLabel.textAlignment = NSTextAlignmentCenter;
        _sizeLabel.numberOfLines = 0;
        _sizeLabel.adjustsFontSizeToFitWidth = YES;
        _sizeLabel.font = [UIFont systemFontOfSize:16];
        _sizeLabel.textColor = [UIColor colorWithWhite:1 alpha:0.8];
        [self addSubview:_sizeLabel];
        
        [self updateSizeLabelText];
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) {
        if (_changeSizeType > 0) {
            return NO;
        }
        CGPoint point = [gestureRecognizer locationInView:self];
        if (CGRectContainsPoint(_sizeView.frame, point)) {
            return YES;
        }
    }
    return YES;
}

- (void)panAction:(UIPanGestureRecognizer *)gesture
{
    [super panAction:gesture];
    [self updateSizeLabelText];
}

- (void)updateSizeLabelText
{
    _sizeLabel.text = [NSString stringWithFormat:@"{%.0f, %.0f; %.0f, %.0f}", self.origin.x + 25, self.origin.y + 25, self.width - 50, self.height - 50];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    CGFloat xgap = 25;
    CGFloat ygap = 25;
    if (self.width < xgap * 3) {
        xgap = self.width / 3;
    }
    if (self.height < ygap * 3) {
        ygap = self.height / 3;
    }
    
    CGRect rect1 = CGRectMake(0, 0, xgap, ygap);
    CGRect rect2 = CGRectMake(xgap, 0, self.width - xgap * 2, ygap);
    CGRect rect3 = CGRectMake(self.width - xgap, 0, xgap, ygap);
    CGRect rect4 = CGRectMake(self.width - xgap, ygap, xgap, self.height - ygap * 2);
    CGRect rect5 = CGRectMake(self.width - xgap, self.height - ygap, xgap, ygap);
    CGRect rect6 = CGRectMake(xgap, self.height - ygap, self.width - xgap * 2, ygap);
    CGRect rect7 = CGRectMake(0, self.height - ygap, xgap, ygap);
    CGRect rect8 = CGRectMake(0, ygap, xgap, self.height - ygap * 2);
    
    if (CGRectContainsPoint(rect1, point)) {
        _changeSizeType = 1;
    } else if (CGRectContainsPoint(rect2, point)) {
        _changeSizeType = 2;
    } else if (CGRectContainsPoint(rect3, point)) {
        _changeSizeType = 3;
    } else if (CGRectContainsPoint(rect4, point)) {
        _changeSizeType = 4;
    } else if (CGRectContainsPoint(rect5, point)) {
        _changeSizeType = 5;
    } else if (CGRectContainsPoint(rect6, point)) {
        _changeSizeType = 6;
    } else if (CGRectContainsPoint(rect7, point)) {
        _changeSizeType = 7;
    } else if (CGRectContainsPoint(rect8, point)) {
        _changeSizeType = 8;
    } else {
        _changeSizeType = 0;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_changeSizeType > 0) {
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        CGPoint prePoint = [[touches anyObject] previousLocationInView:window];
        CGPoint point = [[touches anyObject] locationInView:window];
        point = CGPointMake(point.x - prePoint.x, point.y - prePoint.y);
        CGRect rect = self.frame;
        switch (_changeSizeType) {
            case 1:
                rect = CGRectMake(rect.origin.x + point.x, rect.origin.y + point.y, rect.size.width - point.x, rect.size.height - point.y);
                break;
            case 2:
                rect = CGRectMake(rect.origin.x, rect.origin.y + point.y, rect.size.width, rect.size.height - point.y);
                break;
            case 3:
                rect = CGRectMake(rect.origin.x, rect.origin.y + point.y, rect.size.width + point.x, rect.size.height - point.y);
                break;
            case 4:
                rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width + point.x, rect.size.height);
                break;
            case 5:
                rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width + point.x, rect.size.height + point.y);
                break;
            case 6:
                rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height + point.y);
                break;
            case 7:
                rect = CGRectMake(rect.origin.x + point.x, rect.origin.y, rect.size.width - point.x, rect.size.height + point.y);
                break;
            case 8:
                rect = CGRectMake(rect.origin.x + point.x, rect.origin.y, rect.size.width - point.x, rect.size.height);
                break;
            default:
                break;
        }
        if (rect.size.width < 51) {
            rect.size.width = 51;
        }
        if (rect.size.height < 51) {
            rect.size.height = 51;
        }
        
        rect = CGRectMake(round(rect.origin.x), round(rect.origin.y), round(rect.size.width), round(rect.size.height));
        self.frame = rect;
        [self updateSizeLabelText];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _changeSizeType = 0;
}

@end

@interface DTDebugDragBgView () {
    UIView *_superBgView;
}

@end

@implementation DTDebugDragBgView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bgColorIndex = 0;
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap1];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction2:)];
        tap2.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap2];
        
        [tap1 shouldRequireFailureOfGestureRecognizer:tap2];
    }
    return self;
}

- (void)setBgColorIndex:(NSInteger)bgColorIndex
{
    _bgColorIndex = bgColorIndex % 3;
    if (bgColorIndex == 0) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    } else if (bgColorIndex == 1) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:1.f];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)setShowSuperBg:(BOOL)showSuperBg
{
    _showSuperBg = showSuperBg;
    if (_showSuperBg) {
        if (!_superBgView) {
            _superBgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            _superBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        }
        if (self.superview) {
            _superBgView.frame = self.superview.bounds;
            [self.superview insertSubview:_superBgView belowSubview:self];
            self.center = CGPointMake(_superBgView.width / 2, _superBgView.height / 2);
        }
        self.bgColorIndex = 2;
    } else {
        self.bgColorIndex = 0;
        [_superBgView removeFromSuperview];
    }
}

- (void)tapAction:(UIGestureRecognizer *)gesture
{
    self.bgColorIndex++;
}

- (void)tapAction2:(UIGestureRecognizer *)gesture
{
    self.showSuperBg = !_showSuperBg;
}

- (void)removeFromSuperview
{
    if (_superBgView) {
        [_superBgView removeFromSuperview];
    }
    [super removeFromSuperview];
}

@end
