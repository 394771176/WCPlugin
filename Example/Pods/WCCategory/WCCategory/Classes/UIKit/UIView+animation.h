//
//  UIView+animation.h
//  CarMaintenance
//
//  Created by Kent on 13-7-9.
//  Copyright (c) 2013年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DTAnimationConfigType) {
    DTAnimationConfigTypeNone = 0,
    DTAnimationConfigTypeScale,//缩放
    DTAnimationConfigTypeShake,//抖动
    DTAnimationConfigTypeFlip,//翻转
    DTAnimationConfigTypeUpDown,//上下
};

@interface UIView (DTAnimation)

- (void)startFadeTransition;
- (void)startRotateAnimation;
- (void)startRotateAnimation:(CGFloat)duration;
- (void)stopAllAnimation;

- (void)startPushFadeTransition;
- (void)startPushTransitionFromRight;

//点击效果  放大、降低透明度
- (void)startClickAnimation:(void (^)(void))finish;

- (void)startClickAnimation:(void (^)(void))animation complete:(void (^)(void))complete;

- (void)startKeyframeAnimationWithImages:(NSArray *)images duration:(CFTimeInterval)duration repeatCount:(float)repeatCount;

- (void)shake;

- (void)startWiggleAnimation;

- (void)startScaleAnimationDelay:(CGFloat)delay complete:(void (^)(void))complete;

//类似心跳，跳一下 停一下
- (void)startDTShakeAnimation;

- (void)startScaleAnimation;

- (void)scaleAnimationDelay:(CGFloat)delay repeatCount:(float)repeatCount;

- (void)startFlipAnimation;

- (void)animationWithType:(DTAnimationConfigType)type repeatCount:(float)repeatCount;

@end

@interface UIView (Animate)

// 从指定位置扩张
- (void)expandAnimated:(CGRect)rect;

@end

@interface UIView (pathAnimation)

- (void)addAnimation:(CGPathRef)path time:(float)time;


/**
 角度转弧度
 @param angle 角度
 @return 弧度
 */
CGFloat ArcAngle(CGFloat angle);

/**
 两点距离，及半径
 @param center 圆心
 @param point  点坐标
 @return 两点距离
 */
CGFloat ArcDistance(CGPoint center, CGPoint point);

/**
 获取旋转角度, x轴沿顺时针方向旋转
 @param center 圆心点
 @param point  点坐标
 @return 角度
 */
CGFloat ArcAngleFrom(CGPoint center, CGPoint point);

/**
 计算圆弧上某个角度下的点坐标

 @param center 圆心坐标
 @param radius 半径
 @param angle 弧度，弧度 =（角度 / 180.f * M_PI）
 @return 目标点的坐标
 */
CGPoint ArcPoint(CGPoint center, CGFloat radius, CGFloat angle);
CGPoint ArcPointPercent(CGPoint center, CGFloat radius, CGFloat angle, CGFloat percent);


@end


@interface UITableViewCell (cellAnimation)

- (void)startDisplayAnimation:(BOOL)animation;

@end
