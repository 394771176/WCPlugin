//
//  NSAttributedString+Utils.h
//  DrivingTest
//
//  Created by cheng on 17/2/15.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (Utils)

+ (instancetype)stringWithString:(NSString *)string;

/**
 NS_FORMAT_FUNCTION 展开为一个方法 __attribute__，它会告诉编译器在索引1处的参数是一个格式化字符串，而实际参数从索引2开始。
 这将允许编译器检查格式化字符串而且会像 NSLog() 和 -[NSString stringWithFormat:] 一样输出警告信息。
 */
+ (instancetype)stringWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

+ (NSAttributedString *)string:(NSString *)string rangeText:(NSString *)text font:(UIFont *)font;
+ (NSAttributedString *)string:(NSString *)string rangeText:(NSString *)text fontSize:(CGFloat)fontSize;

#if __has_include(<WCCategory/WCCategory+UI.h>)

+ (NSAttributedString *)string:(NSString *)string rangeText:(NSString *)text colorString:(NSString *)colorString;
+ (NSAttributedString *)string:(NSString *)string rangeText:(NSString *)text fontSize:(CGFloat)fontSize colorString:(NSString *)colorString;

#endif

+ (NSAttributedString *)string:(NSString *)string rangeText:(NSString *)text font:(UIFont *)font color:(UIColor *)color;

/*
 NS_REQUIRES_NIL_TERMINATION
 顾名思义，这个宏的作用就是在结束位置加上我们需要的nil。
 */
//+ (NSAttributedString *)string:(NSString *)string colorString:(UIColor *)colorString rangeTexts:(NSString *)text,...NS_REQUIRES_NIL_TERMINATION;

+ (NSAttributedString *)string:(NSString *)string range:(NSRange)range font:(UIFont *)font color:(UIColor *)color;

@end

@interface NSMutableAttributedString (Utils)

- (void)addAttributeFont:(UIFont *)font range:(NSRange)range;

- (void)addAttributeColor:(UIColor *)color range:(NSRange)range;

- (void)addAttributeBackgroundColor:(UIColor *)color range:(NSRange)range;

- (void)addAttributeUnderlineColor:(UIColor *)color range:(NSRange)range;

- (void)addAttributeStrikethroughColor:(UIColor *)color range:(NSRange)range;

- (void)addAttributeLineSpace:(CGFloat)lineSpace range:(NSRange)range;

- (void)setAttributeLineSpace:(CGFloat)lineSpace;

@end
