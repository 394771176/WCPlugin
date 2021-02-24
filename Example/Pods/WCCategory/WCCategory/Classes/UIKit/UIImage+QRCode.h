//
//  UIImage+QRCode.h
//  DrivingTest
//
//  Created by cheng on 2017/12/1.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QRCode)

// 解析二维码
- (NSString *)QRCodeString;

// 生成二维码，指定像素颜色
+ (UIImage *)QRCodeImageFromString:(NSString *)input withSize:(CGFloat)size;
+ (UIImage *)QRCodeImageFromString:(NSString *)input withSize:(CGFloat)size R:(CGFloat)R G:(CGFloat)G B:(CGFloat)B;

@end
