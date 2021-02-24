//
//  UIImageView+Utils.m
//  DrivingTest
//
//  Created by cheng on 2017/6/29.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "UIImageView+Utils.h"

@implementation UIImageView (Utils)

+ (id)imageViewWithImageName:(NSString *)name
{
    UIImageView *view = [(UIImageView *)[self alloc] initWithImage:[UIImage imageNamed:name]];
    return view;
}

- (void)setImageWithName:(NSString *)name
{
    if (name) {
        [self setImage:[UIImage imageNamed:name]];
    } else {
        [self setImage:nil];
    }
}

@end
