//
//  UIButton+Utils.m
//  DrivingTest
//
//  Created by cheng on 16/9/13.
//  Copyright © 2016年 eclicks. All rights reserved.
//

#import "UIButton+Utils.h"
#import "WCCategory+UI.h"

@implementation UIButton (Utils)

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void)setEnlargeEdge:(CGFloat) size
{
    objc_setAssociatedObject(self, &topNameKey,   [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey,  [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey,[NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setEnlargeEdgeWithTop:(CGFloat) top left:(CGFloat) left bottom:(CGFloat) bottom right:(CGFloat) right
{
    objc_setAssociatedObject(self, &topNameKey,   [NSNumber numberWithFloat:top],   OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey,  [NSNumber numberWithFloat:left],  OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey,[NSNumber numberWithFloat:bottom],OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect
{
    NSNumber* topEdge    = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge  = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge   = objc_getAssociatedObject(self, &leftNameKey);
    
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x    - leftEdge.floatValue,
                          self.bounds.origin.y    - topEdge.floatValue,
                          self.bounds.size.width  + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
        
    } else
    {
        return self.bounds;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.hidden || self.alpha < 0.05) {
        return NO;
    }
    
    CGRect rect = [self enlargedRect];
    
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? YES : NO;
}


- (NSTimeInterval)timeInterval
{
    return [objc_getAssociatedObject(self,_cmd) doubleValue];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    objc_setAssociatedObject(self,@selector(timeInterval),@(timeInterval),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//runtime动态绑定属性

- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent
{
    objc_setAssociatedObject(self,@selector(isIgnoreEvent),@(isIgnoreEvent),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isIgnoreEvent
{
    return [objc_getAssociatedObject(self,_cmd) boolValue];
}

- (void)resetState
{
    [self setIsIgnoreEvent:NO];
}

- (void)setPreventViolenceClick:(BOOL)preventViolenceClick
{
    objc_setAssociatedObject(self,@selector(preventViolenceClick),@(preventViolenceClick),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)preventViolenceClick
{
    return [objc_getAssociatedObject(self,_cmd) boolValue];
}

+ (void)load{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        SEL selA =@selector(sendAction:to:forEvent:);
        
        SEL selB =@selector(mySendAction:to:forEvent:);
        
        Method methodA =class_getInstanceMethod(self, selA);
        
        Method methodB =class_getInstanceMethod(self, selB);
        
        //将methodB的实现添加到系统方法中也就是说将methodA方法指针添加成方法methodB的返回值表示是否添加成功
        
        BOOL isAdd =class_addMethod(self, selA,method_getImplementation(methodB),method_getTypeEncoding(methodB));
        
        //添加成功了说明本类中不存在methodB所以此时必须将方法b的实现指针换成方法A的，否则b方法将没有实现。
        
        if(isAdd) {
            
            class_replaceMethod(self, selB,method_getImplementation(methodA),method_getTypeEncoding(methodA));
            
        }else{
            
            //添加失败了说明本类中有methodB的实现，此时只需要将methodA和methodB的IMP互换一下即可。
            
            method_exchangeImplementations(methodA, methodB);
            
        }
        
    });
    
}

- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent*)event

{
    if (self.preventViolenceClick) {
        self.timeInterval=self.timeInterval==0?defaultInterval:self.timeInterval;
        
        if (self.isIgnoreEvent) {
            
            return;
            
        } else if(self.timeInterval>0) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resetState) object:nil];
            [self performSelector:@selector(resetState)withObject:nil afterDelay:self.timeInterval];
        }
        
        //此处methodA和methodB方法IMP互换了，实际上执行sendAction；所以不会死循环
        
        self.isIgnoreEvent=YES;
    }
    
    [self mySendAction:action to:target forEvent:event];
}

- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setTitleFont:(UIFont *)font
{
    self.titleLabel.font = font;
}

- (void)setTitleFontSize:(CGFloat)fontSize
{
    [self setTitleFont:[UIFont systemFontOfSize:fontSize]];
}

- (void)setTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateNormal];
}

- (void)setTitleColorString:(NSString *)colorString
{
    [self setTitleColor:[UIColor colorWithHexString:colorString]];
}

- (void)setTitleFont:(UIFont *)font color:(UIColor *)color
{
    [self setTitleFont:font];
    [self setTitleColor:color forState:UIControlStateNormal];
}

- (void)setTitleFontSize:(CGFloat)fontSize color:(UIColor *)color
{
    [self setTitleFont:[UIFont systemFontOfSize:fontSize] color:color];
}

- (void)setTitleFontSize:(CGFloat)fontSize colorString:(NSString *)colorString
{
    [self setTitleFontSize:fontSize color:[UIColor colorWithHexString:colorString]];
}

- (void)setTitle:(NSString *)title fontSize:(CGFloat)fontSize colorString:(NSString *)colorString
{
    [self setTitle:title font:[UIFont systemFontOfSize:fontSize] colorString:colorString];
}

- (void)setTitle:(NSString *)title font:(UIFont *)font colorString:(NSString *)colorString
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleFont:font color:[UIColor colorWithString:colorString]];
}

- (void)setTitle:(NSString *)title image:(UIImage *)image
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title image:(UIImage *)image selImage:(UIImage *)selImage
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:selImage forState:UIControlStateSelected];
}

- (void)setTitle:(NSString *)title imageName:(NSString *)imageName
{
    [self setTitle:title image:(imageName.length>0?[UIImage imageNamed:imageName]:nil)];
}

- (void)setTitle:(NSString *)title imageName:(NSString *)imageName selImageName:(NSString *)selImageName
{
    [self setTitle:title image:(imageName.length>0?[UIImage imageNamed:imageName]:nil) selImage:(selImageName.length>0?[UIImage imageNamed:selImageName]:nil)];
}

- (void)setImageWithImageName:(NSString *)imageName
{
    if (imageName) {
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    } else {
        [self setImage:nil forState:UIControlStateNormal];
    }
}

- (void)setSelectedImageWithImageName:(NSString *)imageName
{
    if (imageName) {
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
    } else {
        [self setImage:nil forState:UIControlStateSelected];
    }
}

- (void)setHighlightedImageWithImageName:(NSString *)imageName
{
    if (imageName) {
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    } else {
        [self setImage:nil forState:UIControlStateHighlighted];
    }
}

- (void)setImageWithImageName:(NSString *)imageName selImageName:(NSString *)selImgName
{
    [self setImageWithImageName:imageName];
    [self setSelectedImageWithImageName:selImgName];
}

- (void)setBackgroundImageWithImageName:(NSString *)imageName
{
    if (imageName) {
        [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    } else {
        [self setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

- (void)setBackgroundImageAndHightlightWithColorHex:(NSString *)colorHex
{
    [self setBackgroundImage:[UIImage imageWithColorString:colorHex] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColorString:FFHighlightColorStr(colorHex)] forState:UIControlStateHighlighted];
}

- (void)setBackgroundImageAndHightlightWithColorHex:(NSString *)colorHex cornerRadius:(CGFloat)cornerRadius
{
    if (cornerRadius <= 0) {
        [self setBackgroundImageAndHightlightWithColorHex:colorHex];
        return;
    }
    [self setBackgroundImage:[UIImage imageWithColorString:colorHex cornerRadius:cornerRadius] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColorString:FFHighlightColorStr(colorHex) cornerRadius:cornerRadius] forState:UIControlStateHighlighted];
}

- (void)addTarget:(id)target action:(SEL)action
{
    if (target && action && [target respondsToSelector:action]) {
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setTitleEdgeInsetsForIphoneX
{
    if (IS_iPhoneX) {
        UIEdgeInsets inset = UIEdgeInsetsMake(SAFE_BOTTOM_TITLE_EDGE_TOP_HEIGHT, 0, 0, 0);
        [self setTitleEdgeInsets:inset];
    }
}

- (void)setTitleEdgeInsetsForIphoneXWithEdgeInset:(UIEdgeInsets)fixEdgeInset
{
    if (IS_iPhoneX) {
        [self setTitleEdgeInsets:fixEdgeInset];
    }
}

@end
