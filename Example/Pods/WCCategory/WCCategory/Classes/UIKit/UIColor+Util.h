//
//  UIColor+Util.h
//  DrivingTest
//
//  Created by cheng on 16/9/21.
//  Copyright © 2016年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Util)

@property (nonatomic, readonly) CGFloat alpha;

+ (UIColor *)colorWithHexString: (NSString*) hexStr;
+ (UIColor *)colorWithHexString: (NSString*) hexStr alpha: (float) alpha;

+ (UIColor *)colorWithString:(NSString *)hexStr;
+ (UIColor *)colorWithAlphaString:(NSString *)hexStr;//支持alphpa FFFFFF-95 (95为不透明度的百分比)
+ (UIColor *)colorWithString:(NSString *)hexStr alpha:(float)alpha;

- (NSString *)hexString;

@end
