//
//  UIView+DebugTest.m
//  DrivingTest
//
//  Created by cheng on 2020/11/12.
//  Copyright © 2020 eclicks. All rights reserved.
//

#import "UIView+DebugTest.h"
#import "DTDebugUtil.h"
#import <objc/runtime.h>

UIColor * RandomColor(void)
{
    return [UIView randomColor];
}

UIColor * RandomAlphaColor(void)
{
    return [UIView randomAlphaColor];
}

@implementation UIView (DebugTest)

- (void)setMarkBgColor:(UIColor *)markBgColor
{
    objc_setAssociatedObject(self, @selector(markBgColor), markBgColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)markBgColor
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)showSubView
{
#ifdef DEBUG
    [self randomBgColor];
    for (UIView *view in self.subviews) {
        [view showSubView];
    }
#endif
}

- (void)showSubViewLayerborder
{
#ifdef DEBUG
    self.layer.borderWidth = 1.5f;
    self.layer.borderColor = [UIView randomColor].CGColor;
    for (UIView *view in self.subviews) {
        [view showSubViewLayerborder];
    }
#endif
}

- (void)showSubViewWithMark
{
    if (self.markBgColor) {
        [self showSubViewWithMarkType:YES];
    } else {
        [self showSubViewWithMarkType:NO];
    }
}

- (void)showSubViewWithMarkType:(BOOL)isBackup
{
    if (isBackup) {
        if (self.markBgColor) {
            self.backgroundColor = self.markBgColor;
            self.markBgColor = nil;
        } else {
            self.backgroundColor = [UIColor clearColor];
        }
    } else {
        self.markBgColor = self.backgroundColor;
        [self randomBgColor];
    }
    for (UIView *view in self.subviews) {
        [view showSubViewWithMarkType:isBackup];
    }
}

+ (UIColor *) randomColor {
    return [UIColor colorWithRed:arc4random()%256/255.f green:arc4random()%256/255.f blue:arc4random()%256/255.f alpha:1.0];
}

+ (UIColor *) randomAlphaColor {
    return [UIColor colorWithRed:arc4random()%256/255.f green:arc4random()%256/255.f blue:arc4random()%256/255.f alpha:0.2 + arc4random()%50/100.f];
}

- (void)randomBgColor
{
    [DTDebugUtil debugBlock:^{
        self.backgroundColor = [UIView randomColor];
    }];
}

- (void)autoRemoveByTapSelf
{
    [self addTarget:self singleTapAction:@selector(removeFromSuperview)];
}

- (void)autoRemoveByLongTapSelf
{
    [self addTarget:self longPressAction:@selector(removeFromSuperview)];
}

- (UIView *)isExistSubViewForClass:(Class)subViewClass
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:subViewClass]) {
            return view;
            break;
        }
    }
    return nil;
}

@end
