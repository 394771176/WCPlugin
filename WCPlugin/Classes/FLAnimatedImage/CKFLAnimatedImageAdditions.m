//
//  CLFLAnimatedImageAdditions.m
//  QueryViolations
//
//  Created by R_flava_Man on 17/4/5.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "CKFLAnimatedImageAdditions.h"
#import <objc/runtime.h>
//#import <WCCategory/WCCategory.h>

// From vm_param.h, define for iOS 8.0 or higher to build on device.
#ifndef BYTE_SIZE
#define BYTE_SIZE 8 // byte size in bits
#endif

@interface FLAnimatedImage ()

+ (UIImage *)predrawnImageFromImage:(UIImage *)imageToPredraw;

@end

@implementation FLAnimatedImage(CLFix)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void (^__method_hook)(Class, SEL, SEL, SEL) = ^(Class cls, SEL sel, SEL newSel, SEL origSel) {
            Method method = class_getClassMethod(cls, sel);
            Method newMethod = class_getClassMethod(cls, newSel);
            
            if (class_addMethod(cls, origSel, method_getImplementation(method), method_getTypeEncoding(method))) {
                Method origMethod = class_getClassMethod(cls, origSel);
                method_setImplementation(origMethod, method_getImplementation(method));
                method_setImplementation(method, method_getImplementation(newMethod));
            }
        };
        
        __method_hook([self class], @selector(predrawnImageFromImage:), @selector(NEWpredrawnImageFromImage:), @selector(ORIGpredrawnImageFromImage:));
    });
}

+ (UIImage *)NEWpredrawnImageFromImage:(UIImage *)imageToPredraw
{
    NSArray *array = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
    NSString *sysVersion = [array safeObjectAtIndex:0];
    //判断10.0版本以上不解码 GIF
    if ([sysVersion integerValue] >= 10) {
        return imageToPredraw;
    }
    // Always use a device RGB color space for simplicity and predictability what will be going on.
    CGColorSpaceRef colorSpaceDeviceRGBRef = CGColorSpaceCreateDeviceRGB();
    // Early return on failure!
    if (!colorSpaceDeviceRGBRef) {
        FLLog(FLLogLevelError, @"Failed to `CGColorSpaceCreateDeviceRGB` for image %@", imageToPredraw);
        return imageToPredraw;
    }
    
    // Even when the image doesn't have transparency, we have to add the extra channel because Quartz doesn't support other pixel formats than 32 bpp/8 bpc for RGB:
    // kCGImageAlphaNoneSkipFirst, kCGImageAlphaNoneSkipLast, kCGImageAlphaPremultipliedFirst, kCGImageAlphaPremultipliedLast
    // (source: docs "Quartz 2D Programming Guide > Graphics Contexts > Table 2-1 Pixel formats supported for bitmap graphics contexts")
    size_t numberOfComponents = CGColorSpaceGetNumberOfComponents(colorSpaceDeviceRGBRef) + 1; // 4: RGB + A
    
    // "In iOS 4.0 and later, and OS X v10.6 and later, you can pass NULL if you want Quartz to allocate memory for the bitmap." (source: docs)
    void *data = NULL;
    size_t width = imageToPredraw.size.width;
    size_t height = imageToPredraw.size.height;
    size_t bitsPerComponent = CHAR_BIT;
    
    size_t bitsPerPixel = (bitsPerComponent * numberOfComponents);
    size_t bytesPerPixel = (bitsPerPixel / BYTE_SIZE);
    size_t bytesPerRow = (bytesPerPixel * width);
    
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageToPredraw.CGImage);
    // If the alpha info doesn't match to one of the supported formats (see above), pick a reasonable supported one.
    // "For bitmaps created in iOS 3.2 and later, the drawing environment uses the premultiplied ARGB format to store the bitmap data." (source: docs)
    if (alphaInfo == kCGImageAlphaNone || alphaInfo == kCGImageAlphaOnly) {
        alphaInfo = kCGImageAlphaNoneSkipFirst;
    } else if (alphaInfo == kCGImageAlphaFirst) {
        alphaInfo = kCGImageAlphaPremultipliedFirst;
    } else if (alphaInfo == kCGImageAlphaLast) {
        alphaInfo = kCGImageAlphaPremultipliedLast;
    }
    // "The constants for specifying the alpha channel information are declared with the `CGImageAlphaInfo` type but can be passed to this parameter safely." (source: docs)
    bitmapInfo |= alphaInfo;
    
    // Create our own graphics context to draw to; `UIGraphicsGetCurrentContext`/`UIGraphicsBeginImageContextWithOptions` doesn't create a new context but returns the current one which isn't thread-safe (e.g. main thread could use it at the same time).
    // Note: It's not worth caching the bitmap context for multiple frames ("unique key" would be `width`, `height` and `hasAlpha`), it's ~50% slower. Time spent in libRIP's `CGSBlendBGRA8888toARGB8888` suddenly shoots up -- not sure why.
    CGContextRef bitmapContextRef = CGBitmapContextCreate(data, width, height, bitsPerComponent, bytesPerRow, colorSpaceDeviceRGBRef, bitmapInfo);
    CGColorSpaceRelease(colorSpaceDeviceRGBRef);
    // Early return on failure!
    if (!bitmapContextRef) {
        FLLog(FLLogLevelError, @"Failed to `CGBitmapContextCreate` with color space %@ and parameters (width: %zu height: %zu bitsPerComponent: %zu bytesPerRow: %zu) for image %@", colorSpaceDeviceRGBRef, width, height, bitsPerComponent, bytesPerRow, imageToPredraw);
        return imageToPredraw;
    }
    
    //deal with crash #bug +[FLAnimatedImage predrawnImageFromImage:] (in QueryViolations) (FLAnimatedImage.m:695) CGContextDrawImage 的问题
    UIImage *predrawnImage = nil;
    @try {
        // Draw image in bitmap context and create image by preserving receiver's properties.
        CGContextDrawImage(bitmapContextRef, CGRectMake(0.0, 0.0, imageToPredraw.size.width, imageToPredraw.size.height), imageToPredraw.CGImage);
        CGImageRef predrawnImageRef = CGBitmapContextCreateImage(bitmapContextRef);
        predrawnImage = [UIImage imageWithCGImage:predrawnImageRef scale:imageToPredraw.scale orientation:imageToPredraw.imageOrientation];
        CGImageRelease(predrawnImageRef);
        CGContextRelease(bitmapContextRef);
    } @catch (NSException *exception) {
        NSAssert(!exception, @"collect gif crash %@", exception);
    } @finally {
        // Early return on failure!
        if (!predrawnImage) {
            CGContextRelease(bitmapContextRef);
            return imageToPredraw;
        }
        return predrawnImage;
    }
}

+ (UIImage *)ORIGpredrawnImageFromImage:(UIImage *)imageToPredraw
{
    return nil;
}

@end
