//
//  UIButton+Utils.h
//  DrivingTest
//
//  Created by cheng on 16/9/13.
//  Copyright © 2016年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#define defaultInterval 0.5//默认时间间隔

@interface UIButton (Utils)

@property(nonatomic,assign)NSTimeInterval timeInterval;//用这个给重复点击加间隔

@property(nonatomic,assign) BOOL isIgnoreEvent;//YES不允许点击NO允许点击

@property (nonatomic, assign) IBInspectable BOOL preventViolenceClick;//暴力点击

/**
 *
 *  同时向按钮的四个方向延伸响应面积
 *
 *  @param size 间距
 */
- (void)setEnlargeEdge:(CGFloat) size;

/**扩大按钮响应区域**/
- (void)setEnlargeEdgeWithTop:(CGFloat) top left:(CGFloat) left bottom:(CGFloat) bottom right:(CGFloat) right;


- (void)setTitle:(NSString *)title;

- (void)setTitleFont:(UIFont *)font;
- (void)setTitleFontSize:(CGFloat)fontSize;

- (void)setTitleColor:(UIColor *)color;
- (void)setTitleColorString:(NSString *)colorString;

- (void)setTitleFont:(UIFont *)font color:(UIColor *)color;
- (void)setTitleFontSize:(CGFloat)fontSize color:(UIColor *)color;
- (void)setTitleFontSize:(CGFloat)fontSize colorString:(NSString *)colorString;

- (void)setTitle:(NSString *)title fontSize:(CGFloat)fontSize colorString:(NSString *)colorString;
- (void)setTitle:(NSString *)title font:(UIFont *)font colorString:(NSString *)colorString;

- (void)setTitle:(NSString *)title image:(UIImage *)image;
- (void)setTitle:(NSString *)title image:(UIImage *)image selImage:(UIImage *)selImage;
- (void)setTitle:(NSString *)title imageName:(NSString *)imageName;
- (void)setTitle:(NSString *)title imageName:(NSString *)imageName selImageName:(NSString *)selImageName;

- (void)setImageWithImageName:(NSString *)imageName;
- (void)setSelectedImageWithImageName:(NSString *)imageName;
- (void)setHighlightedImageWithImageName:(NSString *)imageName;
- (void)setImageWithImageName:(NSString *)imageName selImageName:(NSString *)selImgName;
- (void)setBackgroundImageWithImageName:(NSString *)imageName;

- (void)setBackgroundImageAndHightlightWithColorHex:(NSString *)colorHex;
- (void)setBackgroundImageAndHightlightWithColorHex:(NSString *)colorHex cornerRadius:(CGFloat)cornerRadius;

- (void)addTarget:(id)target action:(SEL)action;

- (void)setTitleEdgeInsetsForIphoneX;
- (void)setTitleEdgeInsetsForIphoneXWithEdgeInset:(UIEdgeInsets)fixEdgeInset;

@end
