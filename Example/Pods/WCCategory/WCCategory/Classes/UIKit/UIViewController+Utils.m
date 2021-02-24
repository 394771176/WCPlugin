//
//  UIViewController+Addition.m
//  DrivingSignup
//
//  Created by 成 on 14-4-10.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "UIViewController+Utils.h"
#import "WCCategory+UI.h"

@implementation UIViewController (addtions)

- (CGFloat)left {
    return self.view.left;
}

- (void)setLeft:(CGFloat)x {
    self.view.left = x;
}

- (CGFloat)top {
    return self.view.top;
}

- (void)setTop:(CGFloat)y {
    self.view.top = y;
}

- (CGFloat)right {
    return self.view.left + self.view.width;
}

- (void)setRight:(CGFloat)right {
    self.view.right = right;
}

- (CGFloat)bottom {
    return self.view.bottom;
}

- (void)setBottom:(CGFloat)bottom {
    self.view.bottom = bottom;
}

- (CGFloat)width {
    return self.view.width;
}

- (void)setWidth:(CGFloat)width {
    self.view.width = width;
}

- (CGFloat)height {
    return self.view.height;
}

- (void)setHeight:(CGFloat)height {
    self.view.height = height;
}

- (CGPoint)origin {
    return self.view.origin;
}

- (void)setOrigin:(CGPoint)origin {
    self.view.origin = origin;
}

- (CGSize)size {
    return self.view.size;
}

- (void)setSize:(CGSize)size {
    self.view.size = size;
}

- (CGRect)frame
{
    return self.view.frame;
}

- (void)setFrame:(CGRect)frame
{
    self.view.frame = frame;
}

- (CGFloat)alpha
{
    return self.view.alpha;
}

- (void)setAlpha:(CGFloat)alpha
{
    self.view.alpha = alpha;
}

- (UIColor *)backgroundColor
{
    return self.view.backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.view.backgroundColor = backgroundColor;
}

- (CGRect)bounds
{
    return self.view.bounds;
}

- (void)addSubview:(id)view
{
    [self.view addSubview:view];
}

@end
