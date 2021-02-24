//
//  UILabel+Utils.m
//  DrivingTest
//
//  Created by cheng on 15/12/31.
//  Copyright © 2015年 eclicks. All rights reserved.
//

#import "UILabel+Utils.h"
#import "WCCategory+UI.h"

@implementation UILabel (Utils)

+ (id)labelWithFrame:(CGRect)frame font:(UIFont *)font color:(UIColor *)color
{
    UILabel *label = [[self alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    if (color) {
        label.textColor = color;
    }
    label.font = font;
    return label;
}

+ (id)labelWithFrame:(CGRect)frame font:(UIFont *)font colorString:(NSString *)colorString
{
    return [self labelWithFrame:frame font:font color:[UIColor colorWithHexString:colorString]];
}

+ (id)labelWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize color:(UIColor *)color
{
    return [self labelWithFrame:frame font:[UIFont systemFontOfSize:fontSize] color:color];
}

+ (id)labelWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize colorString:(NSString *)colorString
{
    return [self labelWithFrame:frame font:[UIFont systemFontOfSize:fontSize] color:[UIColor colorWithHexString:colorString]];
}

- (CGSize)measureSize
{
    NSDictionary *attributes = @{ NSFontAttributeName: self.font };
    CGSize measureSize = [self.text sizeWithAttributes:attributes];
    return measureSize;
}

- (void)setFontSize:(CGFloat)fontSize
{
    [self setFont:[UIFont systemFontOfSize:fontSize]];
}

- (void)setTextColorString:(NSString *)colorString
{
    [self setTextColor:[UIColor colorWithString:colorString]];
}

- (void)setFontSize:(CGFloat)fontSize colorString:(NSString *)colorString
{
    [self setFontSize:fontSize];
    [self setTextColorString:colorString];
}

- (void)setLabelWidthWithString:(NSString *)string
{
    self.text = string;
    self.width = [self getTextWidth];
}

- (void)setLabelHeightWithString:(NSString *)string
{
    self.text = string;
    self.height = [self getTextHeight];
}

- (CGFloat)getTextWidth
{
    return ceilf([self textRectForBounds:CGRectMake(0, 0, FLT_MAX, self.height) limitedToNumberOfLines:self.numberOfLines].size.width);
}

- (CGFloat)getTextHeight
{
    return ceilf([self textRectForBounds:CGRectMake(0, 0, self.width, FLT_MAX) limitedToNumberOfLines:self.numberOfLines].size.height);
}

@end

@implementation UILabel (Attributed)

- (void)setText:(NSString *)text highLightText:(NSString *)highLightText withFont:(UIFont *)font
{
    [self setText:text highLightText:highLightText withColor:nil withFont:font];
}

- (void)setText:(NSString *)text highLightText:(NSString *)highLightText withColor:(UIColor *)color
{
    [self setText:text highLightText:highLightText withColor:color withFont:nil];
}

- (void)setText:(NSString *)text highLightText:(NSString *)highLightText withColor:(UIColor *)color withFont:(UIFont *)font
{
    self.attributedText = [NSAttributedString string:text rangeText:highLightText font:font color:color];
}

- (void)setText:(NSString *)text highLightTextArray:(NSArray *)highLightTextArray withColor:(UIColor *)color
{
    [self setText:text highLightTextArray:highLightTextArray withColor:color font:nil];
}

- (void)setText:(NSString *)text highLightTextArray:(NSArray *)highLightTextArray withColor:(UIColor *)color font:(UIFont *)font
{
    if (text && (color || font)) {
        NSMutableAttributedString *mString = [NSMutableAttributedString stringWithString:text];
        NSInteger loc = 0;
        NSString *ctext = [text copy];
        for (NSString *string in highLightTextArray) {
            NSRange range = [ctext rangeOfString:string];
            if (range.length>0) {
                range.location = loc+range.location;
                if (color) {
                    [mString addAttributeColor:color range:range];
                }
                if (font) {
                    [mString addAttributeFont:font range:range];
                }
                
                //从后面截断，防止高亮数字有相同的，比如 @[@"500", @"0"] 都有0
                loc = range.location+range.length;
                if (loc<text.length) {
                    ctext = [text substringFromIndex:loc];
                } else {
                    ctext = @"";
                }
            }
        }
        self.attributedText = mString;
        return;
    }
    self.text = text;
}

- (void)setText:(NSString *)text withLineSpace:(float)lineSpace
 {
     if (text.length <= 0) {
         return;
     }
     NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
     NSMutableParagraphStyle *paragraphStyle = [self paragraphStyle];
     [paragraphStyle setLineSpacing:lineSpace];
     [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
     self.attributedText = attributedString;
}

- (void)setText:(NSString *)text withWordSpace:(float)wordSpace
{
    if (text.length <= 0) {
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSKernAttributeName:@(wordSpace)}];
    self.attributedText = attributedString;
}

- (void)setText:(NSString *)text withLineSpace:(float)lineSpace wordSpace:(float)wordSpace
{
    if (text.length <= 0) {
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [self paragraphStyle];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    self.attributedText = attributedString;
}

- (NSMutableParagraphStyle *)paragraphStyle
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.textAlignment;
    return paragraphStyle;
}

@end
