//
//  UIImage+Utils.m
//  FFStory
//
//  Created by PageZhang on 14/11/18.
//  Copyright (c) 2014年 FF. All rights reserved.
//

#import "UIImage+Utils.h"
#import "WCCategory+UI.h"

UIImage *FFPlaceholderImageWithSize(CGSize size) {
    return FFPlaceholderImageWithSizeAndColor(size, nil);

}
UIImage *FFPlaceholderImageWithSizeAndColor(CGSize size, UIColor *tintColor) {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    if (tintColor) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, tintColor.CGColor);
        CGContextFillRect(context, (CGRect){.size=size});
    }
    UIImage *placeholder = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return placeholder;
}

@implementation UIImage (Utils)

- (CGFloat)width
{
    return self.size.width;
}

- (CGFloat)height
{
    return self.size.height;
}

- (UIImage *)tintedWithColor:(UIColor *)color {
    return [self tintedWithColor:color fraction:0];
}
- (UIImage *)tintedWithColor:(UIColor *)tintColor fraction:(CGFloat)fraction {
    if (tintColor) {
        CGRect rect = (CGRect){.size=self.size};
        UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
        [tintColor set];
        UIRectFill(rect);
        [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.f];
        
        if (fraction > 0.0) {
            [self drawInRect:rect blendMode:kCGBlendModeSourceAtop alpha:fraction];
        }
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    return self;
}

- (UIImage *)subImageFromRect:(CGRect)rect
{
    CGImageRef imageRef  = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)grayImage
{
    int bitmapInfo = kCGImageAlphaNone;
    int width = self.size.width;
    int height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), self.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

/*
 //绘图
 -(UIImage*)imageChangeColor:(UIColor*)color
 {
 //获取画布
 UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
 //画笔沾取颜色
 [color setFill];
 
 CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
 UIRectFill(bounds);
 //绘制一次
 [self drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0f];
 //再绘制一次
 [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
 //获取图片
 UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 return img;
 }
 */

- (UIImage *)imageWithAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, alpha);
    CGContextTranslateCTM(context, 0.0f, self.size.height);
    CGContextScaleCTM(context, 1.f, -1.f);
    CGContextDrawImage(context, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)addImageToBottom:(UIImage *)image
{
    CGSize size1 = CGSizeMake(self.size.width, self.size.height);
    CGSize size2 = CGSizeMake(self.size.width, self.size.width*image.size.height/image.size.width);
    
    CGSize size = CGSizeMake(size1.width, size1.height+size2.height);
    
//    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    // Draw image1
    [image drawInRect:CGRectMake(0, size1.height, size2.width, size2.height)];
    // Draw image2
    [self drawInRect:CGRectMake(0, 0, size1.width, size1.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

- (UIImage *)addCornerRadius:(CGFloat)cornerRadius
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    CGRect drawRect = CGRectMake(0, 0, self.size.width, self.size.height);
    [[UIBezierPath bezierPathWithRoundedRect:drawRect cornerRadius:cornerRadius] addClip];
    [self drawInRect:drawRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//- (UIImage *)resizableImageForAlliOSVersionWithCapInsets:(UIEdgeInsets)capInsets {
//    if ([[UIDevice currentDevice].systemVersion doubleValue] > 4.99) {
//        return [self resizableImageWithCapInsets:capInsets];
//    } else {
//        return [self stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
//    }
//}

- (UIImage *)resizeWithScale:(CGFloat)scale
{
    return [self resizeToSize:CGSizeMake(self.width * scale, self.height * scale)];
}

- (UIImage *)resizeToSize:(CGSize)size
{
    if (self.size.width==size.width&&self.size.height==size.height) {
        return self;
    }
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

- (UIImage *)resizeWithMaxSize:(CGSize)size
{
    if (self.size.width>size.width || self.size.height>size.height) {
        CGSize maxSize = CGSizeMake(size.width, floorf(size.width/self.size.width*self.size.height));
        if (maxSize.height>size.height) {
            maxSize = CGSizeMake(floorf(size.height/self.size.height*self.size.width), size.height);
        }
        return [self resizeToSize:maxSize];
    }
    return self;
}

@end

@implementation UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    if (color) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithColorString:(NSString *)string
{
    return [self imageWithColor:[UIColor colorWithHexString:string]];
}

+ (UIImage *)imageWithColorString:(NSString *)string cornerRadius:(CGFloat)radius withSize:(CGSize)size
{
    return [self imageWithColor:[UIColor colorWithHexString:string] cornerRadius:radius withSize:size];
}

+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)radius withSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [color setFill];
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColorString:(NSString *)string cornerRadius:(CGFloat)radius
{
    return [self imageWithColor:[UIColor colorWithHexString:string] cornerRadius:radius];
}

+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)radius
{
    CGSize size = CGSizeMake(radius*2+3, radius*2+3);
    UIImage *image = [self imageWithColor:color cornerRadius:radius withSize:size];
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(radius+1, radius+1, radius+1, radius+1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithSize:(CGSize)size borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius
{
    return [self imageWithSize:size bgColor:nil borderColor:borderColor borderWidth:borderWidth cornerRadius:cornerRadius];
}

+ (UIImage *)imageWithSize:(CGSize)size bgColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    if (fabs(size.height/2 - cornerRadius) < 0.0001) {
        cornerRadius = (size.height - borderWidth) /2;
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth/2, borderWidth/2) cornerRadius:cornerRadius];
    if (bgColor) {
        [bgColor setFill];
        [path fill];
    }
    if (borderColor && borderWidth > 0) {
        [borderColor setStroke];
        [path setLineWidth:borderWidth];
        [path stroke];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize
{
    NSMutableArray *ar = [NSMutableArray array];
    
    for(UIColor *c in colors) {
        
        [ar addObject:(id)c.CGColor];
        
    }
    
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    
    CGPoint start;
    
    CGPoint end;
    
    switch (gradientType) {
            
        case GradientTypeTopToBottom:
            
            start = CGPointMake(0.0, 0.0);
            
            end = CGPointMake(0.0, imgSize.height);
            
            break;
            
        case GradientTypeLeftToRight:
            
            start = CGPointMake(0.0, 0.0);
            
            end = CGPointMake(imgSize.width, 0.0);
            
            break;
            
        case GradientTypeUpleftToLowright:
            
            start = CGPointMake(0.0, 0.0);
            
            end = CGPointMake(imgSize.width, imgSize.height);
            
            break;
            
        case GradientTypeUprightToLowleft:
            
            start = CGPointMake(imgSize.width, 0.0);
            
            end = CGPointMake(0.0, imgSize.height);
            
            break;
            
        default:
            
            break;
            
    }
    
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    
    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(colorSpace);
    
    UIGraphicsEndImageContext();
    
    return image;
    
}


@end

