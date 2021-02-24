//
//  UIColor+Util.m
//  DrivingTest
//
//  Created by cheng on 16/9/21.
//  Copyright © 2016年 eclicks. All rights reserved.
//

#import "UIColor+Util.h"
#import "WCCategory+UI.h"

@implementation UIColor (Util)

+ (UIColor *)colorWithString:(NSString *)hexStr
{
    return [self colorWithString:hexStr alpha:1.0f];
}

+ (UIColor *)colorWithAlphaString:(NSString *)hexStr
{
    NSArray *hexArray = [hexStr componentsSeparatedByString:@"-"];
    if (hexArray.count==2) {
        return [self colorWithHexString:hexArray[0] alpha:[hexArray[1] floatValue]/100.0f];
    } else {
        return [self colorWithHexString:hexStr alpha:1.f];
    }
}

+ (UIColor *)colorWithString:(NSString *)hexString alpha:(float)alpha {
    return [self colorWithHexString:hexString alpha:alpha];
}

+ (nullable UIColor *)colorWithHexString:(NSString*)hexString
{
    return [self colorWithHexString:hexString alpha:1.f];
}

+ (nullable UIColor *)colorWithHexValue:(uint)hexValue alpha:(float)alpha {
    if (AvailableiOS(10)) {
        return [UIColor
                colorWithDisplayP3Red:((float)((hexValue & 0xFF0000) >> 16))/255.0
                green:((float)((hexValue & 0xFF00) >> 8))/255.0
                blue:((float)(hexValue & 0xFF))/255.0
                alpha:alpha];
        
    }
    return [UIColor
            colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
            green:((float)((hexValue & 0xFF00) >> 8))/255.0
            blue:((float)(hexValue & 0xFF))/255.0
            alpha:alpha];
}

+ (nullable UIColor *)colorWithHexString:(NSString*)hexString alpha:(float)alpha {
    if (hexString == nil || (id)hexString == [NSNull null]) {
        return nil;
    }
    UIColor *col;
    if (![hexString hasPrefix:@"#"]) {
        hexString = [NSString stringWithFormat:@"#%@", hexString];
    }
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#"
                                                     withString:@"0x"];
    uint hexValue;
    if ([[NSScanner scannerWithString:hexString] scanHexInt:&hexValue]) {
        col = [self colorWithHexValue:hexValue alpha:alpha];
    } else {
        // invalid hex string
        col = [UIColor clearColor];
    }
    return col;
}

- (NSString *)hexString {
    return [self hexStringWithAlpha:YES];
}

- (NSString *)hexStringWithAlpha:(BOOL)withAlpha {
    CGColorRef color = self.CGColor;
    size_t count = CGColorGetNumberOfComponents(color);
    const CGFloat *components = CGColorGetComponents(color);
    static NSString *stringFormat = @"%02x%02x%02x";
    NSString *hex = nil;
    if (count == 2) {
        NSUInteger white = (NSUInteger)(components[0] * 255.0f);
        hex = [NSString stringWithFormat:stringFormat, white, white, white];
    } else if (count == 4) {
        hex = [NSString stringWithFormat:stringFormat,
               (NSUInteger)(components[0] * 255.0f),
               (NSUInteger)(components[1] * 255.0f),
               (NSUInteger)(components[2] * 255.0f)];
    }
    
    if (hex && withAlpha && self.alpha < 1) {
        hex = [hex stringByAppendingFormat:@"-%zd",
               (unsigned long)(self.alpha * 100)];
    }
    return hex;
}

- (CGFloat)alpha {
    return CGColorGetAlpha(self.CGColor);
}

@end
