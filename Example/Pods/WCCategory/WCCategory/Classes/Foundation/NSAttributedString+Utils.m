//
//  NSAttributedString+Utils.m
//  DrivingTest
//
//  Created by cheng on 17/2/15.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "NSAttributedString+Utils.h"
#import <CoreText/CoreText.h>
//#import "WCCategory.h"
#import "WCCategory+NS.h"

#if __has_include(<WCCategory/WCCategory+UI.h>)

#import "WCCategory+UI.h"

#endif

#define SetParagraphStyle(_attr_) \
[self enumerateAttribute:NSParagraphStyleAttributeName \
inRange:range \
options:kNilOptions \
usingBlock: ^(NSParagraphStyle *value, NSRange subRange, BOOL *stop) { \
NSMutableParagraphStyle *style = nil; \
if (value) { \
if (CFGetTypeID((__bridge CFTypeRef)(value)) == CTParagraphStyleGetTypeID()) { \
value = [NSParagraphStyle yy_styleWithCTStyle:(__bridge CTParagraphStyleRef)(value)]; \
} \
if (value. _attr_ == _attr_) return; \
if ([value isKindOfClass:[NSMutableParagraphStyle class]]) { \
style = (id)value; \
} else { \
style = value.mutableCopy; \
} \
} else { \
if ([NSParagraphStyle defaultParagraphStyle]. _attr_ == _attr_) return; \
style = [NSParagraphStyle defaultParagraphStyle].mutableCopy; \
} \
style. _attr_ = _attr_; \
[self addAttributeParagraphStyle:style range:subRange]; \
}];

@implementation NSAttributedString (Utils)

+ (instancetype)stringWithString:(NSString *)string
{
    return [[self alloc] initWithString:string];
}

+ (instancetype)stringWithFormat:(NSString *)format, ...
{
    va_list ap;
    va_start(ap, format);
    NSString *string = [[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:ap];
    va_end(ap);
    return [self stringWithString:string];
}

+ (NSAttributedString *)string:(NSString *)string rangeText:(NSString *)text font:(UIFont *)font
{
    return [self string:string rangeText:text font:font color:nil];
}

+ (NSAttributedString *)string:(NSString *)string rangeText:(NSString *)text fontSize:(CGFloat)fontSize
{
    return [self string:string rangeText:text font:[UIFont systemFontOfSize:fontSize]];
}

#if __has_include(<WCCategory/WCCategory+UI.h>)

+ (NSAttributedString *)string:(NSString *)string rangeText:(NSString *)text colorString:(NSString *)colorString
{
    return [self string:string rangeText:text font:nil color:(colorString?[UIColor colorWithHexString:colorString] : nil)];
}

+ (NSAttributedString *)string:(NSString *)string rangeText:(NSString *)text fontSize:(CGFloat)fontSize colorString:(NSString *)colorString
{
    return [self string:string rangeText:text font:[UIFont systemFontOfSize:fontSize] color:(colorString?[UIColor colorWithHexString:colorString] : nil)];
}

#endif

+ (NSAttributedString *)string:(NSString *)string rangeText:(NSString *)text font:(UIFont *)font color:(UIColor *)color
{
    if (string) {
        if (!text) {
            text = string;
        }
        return [self string:string range:[string rangeOfString:text] font:font color:color];
    }
    return nil;
}

+ (NSAttributedString *)string:(NSString *)string range:(NSRange)range font:(UIFont *)font color:(UIColor *)color
{
    if (string && range.length) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
        [attString addAttributeFont:font range:range];
        [attString addAttributeColor:color range:range];
        return attString;
    }
    return [[self alloc] initWithString:string];
}

//+ (NSAttributedString *)string:(NSString *)string colorString:(NSString *)colorString rangeTexts:(NSString *)text, ...NS_REQUIRES_NIL_TERMINATION
//{
//    if (string) {
//        NSMutableAttributedString *attString = [NSMutableAttributedString stringWithString:string];
//        UIColor *color = [UIColor colorWithHexString:colorString];
//        va_list list;
//        va_start(list, text);
//        NSString * temStr = text;
//        while (temStr!=nil) {
//            temStr = va_arg(list, NSString*);
//            [attString addAttributeColor:color range:[string rangeOfString:temStr]];
//        }
//        va_end(list);
//        return attString;
//    }
//    return nil;
//}

@end


@implementation NSMutableAttributedString (Utils)

- (void)addAttributeFont:(UIFont *)font range:(NSRange)range
{
    if (font) {
        [self addAttribute:NSFontAttributeName value:font range:range];
    }
}

- (void)addAttributeColor:(UIColor *)color range:(NSRange)range
{
    if (color) {
        [self addAttribute:NSForegroundColorAttributeName value:color range:range];
        [self addAttribute:(id)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
//        if (c) {
//            <#statements#>
//        }
    }
}

- (void)addAttributeBackgroundColor:(UIColor *)color range:(NSRange)range
{
    if (color) {
        [self addAttribute:NSBackgroundColorAttributeName value:color range:range];
    }
}

- (void)addAttributeUnderlineColor:(UIColor *)color range:(NSRange)range
{
    if (color) {
        [self addAttribute:NSUnderlineStyleAttributeName value:@(1) range:range];
        [self addAttribute:NSUnderlineColorAttributeName value:color range:range];
    }
}

- (void)addAttributeStrikethroughColor:(UIColor *)color range:(NSRange)range
{
    if (color) {
        [self addAttribute:NSStrikethroughStyleAttributeName value:@(1) range:range];
        [self addAttribute:NSStrikethroughColorAttributeName value:color range:range];
        if (iOS(10)) {
            [self addAttribute:NSBaselineOffsetAttributeName value:@(1) range:range];
        }
    }
}

- (void)addAttributeLineSpace:(CGFloat)lineSpace range:(NSRange)range
{
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineSpacing = lineSpace;
    NSDictionary *attr = @{NSParagraphStyleAttributeName : paragraph};
    [self addAttributes:attr range:range];
}

- (void)setAttributeLineSpace:(CGFloat)lineSpace
{
    [self addAttributeLineSpace:lineSpace range:NSMakeRange(0, self.length)];
}

- (void)addAttributeParagraphStyle:(NSParagraphStyle *)style range:(NSRange)range
{
    [self addAttribute:NSParagraphStyleAttributeName value:style range:range];
}

- (void)safeSetAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    if (!name || [NSNull isEqual:name]) return;
    if (value && ![NSNull isEqual:value]) [self addAttribute:name value:value range:range];
    else [self removeAttribute:name range:range];
}

- (void)removeAttributesInRange:(NSRange)range {
    [self setAttributes:nil range:range];
}

@end
