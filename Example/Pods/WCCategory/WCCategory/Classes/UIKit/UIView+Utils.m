//
//  UIView+Utils.m
//  FFStory
//
//  Created by PageZhang on 14/11/18.
//  Copyright (c) 2014年 FF. All rights reserved.
//

#import "UIView+Utils.h"
#import "WCCategory+UI.h"

@implementation UIView (Frame)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}


- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
//    if (cornerRadius>0) {
//        self.layer.shouldRasterize = YES;
//        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
//    } else {
//        self.layer.shouldRasterize = NO;
//        self.layer.rasterizationScale = 1.0f;
//    }
}

- (void)setFixRightWidth:(CGFloat)width
{
    [self setFixRight:self.right width:width];
}

- (void)setFixRight:(CGFloat)right width:(CGFloat)width
{
    self.frame = CGRectMake(right - width, self.top, width, self.height);
}

- (void)setFixBottomHeight:(CGFloat)height
{
    [self setFixBottom:self.bottom height:height];
}

- (void)setFixBottom:(CGFloat)bottom height:(CGFloat)height
{
    self.frame = CGRectMake(self.left, self.bottom - height, self.width, height);
}

- (void)setFixCenterWidth:(CGFloat)width
{
    [self setFixCenterWidth:width height:self.height];
}

- (void)setFixCenterHeight:(CGFloat)height
{
    [self setFixCenterWidth:self.width height:height];
}

- (void)setFixCenterWidth:(CGFloat)width height:(CGFloat)height
{
    self.frame = CGRectMake(self.centerX - width/2, self.centerY - height/2, width, height);
}

- (void)setTop:(CGFloat)top andHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.left, top, self.width, height);
}

- (void)setTop:(CGFloat)top andWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.left, top, width, self.height);
}

- (void)setLeft:(CGFloat)left andWidth:(CGFloat)width
{
    self.frame = CGRectMake(left, self.top, width, self.height);
}

@end

@implementation UIView (Utils)

#pragma mark - actions

- (UIImage *)capturedImage {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)capturedImageWithRect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)hierarchyImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)hierarchyImageWithRect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)recursiveSubviews {
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"%@", obj);
        [obj recursiveSubviews];
    }];
}

- (void)removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (UIView *)findFirstResponderView {
    // Stop if e.g. we show a UIAlertView with a text field.
    if (UIApplication.sharedApplication.keyWindow != self.window) return nil;
    
    // Search recursively for first responder.
    for (UIView *childView in self.subviews) {
        if ([childView respondsToSelector:@selector(isFirstResponder)] && childView.isFirstResponder)
            return childView;
        UIView *result = [childView findFirstResponderView];
        if (result) return result;
    }
    return nil;
}

- (UIViewController *)findResponderViewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)addTarget:(id)target singleTapAction:(SEL)action {
    [self addTarget:target singleTapAction:action tapCount:1];
}

- (void)addTarget:(id)target singleTapAction:(SEL)action tapCount:(NSInteger)tapCount
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tap.numberOfTapsRequired = tapCount;
    [self addGestureRecognizer:tap];
}

- (void)addTarget:(id)target longPressAction:(SEL)action {
    [self addTarget:target longPressAction:action duration:0.5];
}

- (void)addTarget:(id)target longPressAction:(SEL)action duration:(CGFloat)duration
{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:action];
    longPress.minimumPressDuration = duration;
    [self addGestureRecognizer:longPress];
}

- (void)addTarget:(id)target panAction:(SEL)action {
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:action];
    [self addGestureRecognizer:pan];
}
- (void)setLayerBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    [self setLayerBorderWidth:borderWidth borderColor:borderColor cornerRadius:0.f];
}

- (void)setLayerBorderWidth:(CGFloat)borderWidth borderColorStr:(NSString *)borderColorStr
{
    [self setLayerBorderWidth:borderWidth borderColorStr:borderColorStr cornerRadius:0.f];
}

- (void)setLayerBorderWidth:(CGFloat)borderWidth borderColorStr:(NSString *)borderColorStr cornerRadius:(CGFloat)cornerRadius
{
    [self setLayerBorderWidth:borderWidth borderColor:[UIColor colorWithString:borderColorStr] cornerRadius:cornerRadius];
}

- (void)setLayerBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius
{
    self.layer.borderWidth = borderWidth;
    if (borderColor) {
        self.layer.borderColor = borderColor.CGColor;
    } else {
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
    self.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)setBackgroundColorStr:(NSString *)backgroundColorStr
{
    if (backgroundColorStr.length) {
        [self setBackgroundColor:[UIColor colorWithString:backgroundColorStr]];
    }
}

+ (UIView *)clearColorView:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIViewController *)ownerViewController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        } else if ([next isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)next;
            return nav.viewControllers.lastObject;
        }
        next = next.nextResponder;
    }while (next != nil);
    return nil;
}

- (UIView *)gaussView:(UIView *)view
{
    view.contentMode = UIViewContentModeScaleAspectFit;
    if(view.subviews.count) {
        for (NSInteger i = 0; i < view.subviews.count; i ++ ) {
            UIView *subview = view.subviews[i];
            if (subview.tag == 198765) {
                [subview removeFromSuperview];
            }
        }
    }
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = view.bounds;
    effectview.tag = 198765;
    [view addSubview:effectview];
    [view insertSubview:effectview atIndex:0];
    return view;
}

- (UIImage *)captureView {
    CGRect rect = self.frame;
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


- (void)findTextView:(NSArray *)subviews list:(NSMutableArray *)list
{
    for (UIView *view in subviews) {
        if ([view isKindOfClass:[UITextField class]]||[view isKindOfClass:[UITextView class]]) {
            [list addObject:view];
        }
        [self findTextView:view.subviews list:list];
    }
}

- (UIView *)nextTextResponder
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    [self findTextView:self.subviews list:list];
    
    [list sortUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
        CGPoint point1 = [self convertPoint:CGPointZero fromView:obj1];
        CGPoint point2 = [self convertPoint:CGPointZero fromView:obj2];
        if (point1.y>point2.y) {
            return NSOrderedDescending;
        } else if (point1.y==point2.y) {
            if (point1.x>point2.x) {
                return NSOrderedDescending;
            } else if (point1.x==point2.x) {
                return NSOrderedSame;
            } else {
                return NSOrderedAscending;
            }
        } else {
            return NSOrderedAscending;
        }
    }];
    
    BOOL findCurrentText = NO;
    
    for (UIView *view in list) {
        if ([view isFirstResponder]) {
            findCurrentText = YES;
        } else {
            if (findCurrentText) {
                return view;
                break;
            }
        }
    }
    
    return nil;
}

+ (UIView *)firstTextResponderWithRootView:(UIView *)rootView findFirstResponder:(BOOL *)findFirstResponder
{
    if ([rootView isFirstResponder]) {
        *findFirstResponder = YES;
        if ([rootView isKindOfClass:[UITextField class]]||[rootView isKindOfClass:[UITextView class]] || [rootView isKindOfClass:[UISearchBar class]]) {
            return rootView;
        } else {
            return nil;
        }
    }
    for (UIView *view in rootView.subviews) {
        UIView *result = [self firstTextResponderWithRootView:view findFirstResponder:findFirstResponder];
        if (*findFirstResponder) {
            return result;
        }
    }
    return nil;
}

- (UIView *)firstTextResponder
{
    BOOL findFirstResponder = NO;
    return [UIView firstTextResponderWithRootView:self findFirstResponder:&findFirstResponder];
}

@end

#import <objc/runtime.h>
static NSString *const FFSuppressLayoutKey = @"suppressSetNeedsLayout";

@interface FFSuppressLayoutTriggerLayer : CALayer @end
@implementation FFSuppressLayoutTriggerLayer
- (void)setNeedsLayout {
    if (![[self valueForKey:FFSuppressLayoutKey] boolValue]) {
        [super setNeedsLayout];
    }
}
@end

@implementation UIView (Hook)

- (void)performWithoutTriggeringSetNeedsLayout:(dispatch_block_t)block {
    CALayer *layer = self.layer;
    // Change layer to be our custom subclass.
    if (![layer isKindOfClass:FFSuppressLayoutTriggerLayer.class]) {
        // Check both classes to see and break if KVO is used here.
        if ([layer.class isEqual:CALayer.class] && [layer.class isEqual:object_getClass(layer)]) {
            object_setClass(self.layer, FFSuppressLayoutTriggerLayer.class);
        } else {
            // While we could use dynamic subclassing, that amount of complexity isn't needed in our case.
            // If we're a different layer type, the generic KVC store value is simply ignored, so no need to quit.
            NSLog(@"View has a custom layer - not changing.");
        }
    }
    if (![[layer valueForKey:FFSuppressLayoutKey] boolValue]) {
        [layer setValue:@YES forKey:FFSuppressLayoutKey];
        block();
        [layer setValue:@NO forKey:FFSuppressLayoutKey];
    }else {
        // No need to set flag again. Allows to be called this multiple times.
        block();
    }
}

@end
