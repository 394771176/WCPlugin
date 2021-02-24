//
//  UIViewController+Addition.h
//  DrivingSignup
//
//  Created by 成 on 14-4-10.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (addtions)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
@property (nonatomic) CGRect frame;
@property (nonatomic) CGFloat alpha;

@property (nonatomic, strong) UIColor *backgroundColor;

- (CGRect)bounds;
- (void)addSubview:(id)view;

@end
