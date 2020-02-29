//
//  CLFLAnimatedImageAdditions.h
//  QueryViolations
//
//  Created by R_flava_Man on 17/4/5.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <FLAnimatedImage/FLAnimatedImage.h>
#import "FLAnimatedImageView.h"

@interface FLAnimatedImage (CLFix)

+ (UIImage *)ORIGpredrawnImageFromImage:(UIImage *)imageToPredraw;

@end
