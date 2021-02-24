//
//  UIView+animation.m
//  CarMaintenance
//
//  Created by Kent on 13-7-9.
//  Copyright (c) 2013年 eclicks. All rights reserved.
//

#import "UIView+animation.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Utils.h"

@implementation UIView (animation)

- (void)startRotateAnimation
{
    [self startRotateAnimation:1.0f];
}

- (void)startRotateAnimation:(CGFloat)duration
{
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    theAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(3.13, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(6.26, 0, 0, 1)],
                           nil];
    theAnimation.cumulative = YES;
    theAnimation.duration = duration;
    theAnimation.repeatCount = HUGE_VALF;
    theAnimation.removedOnCompletion = YES;
    [self.layer addAnimation:theAnimation forKey:@"transform"];
}

- (void)startFadeTransition
{
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [animation setDuration:0.3f];
    [animation setRemovedOnCompletion:YES];
    [self.layer addAnimation:animation forKey:@"fade"];
}

- (void)startPushFadeTransition
{
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [animation setDuration:0.3f];
    [animation setRemovedOnCompletion:YES];
    [self.layer addAnimation:animation forKey:@"fade"];
}

- (void)startPushTransitionFromRight
{
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setDuration:0.3f];
    [animation setRemovedOnCompletion:YES];
    [self.layer addAnimation:animation forKey:@"push"];
}

- (void)stopAllAnimation
{
    [self.layer removeAllAnimations];
}

- (void)startClickAnimation:(void (^)(void))finish
{
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(1.66, 1.66);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0;
        if (finish) {
            finish();
        }
    }];
}

- (void)startClickAnimation:(void (^)(void))animation complete:(void (^)(void))complete
{
    [UIView animateWithDuration:0.15f animations:^{
        self.transform = CGAffineTransformMakeScale(1.4, 1.4);
    } completion:^(BOOL finished) {
        CGAffineTransform transform = self.transform;
        self.transform = CGAffineTransformIdentity;
        if (animation) {
            animation();
        }
        self.transform = transform;
        [UIView animateWithDuration:0.15f animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (complete) {
                complete();
            }
        }];
    }];
}

//- (void)startClickAnimation:(void (^)(void))animation complete:(void (^)(void))complete
//{
//    [UIView animateWithDuration:0.15f animations:^{
//        self.transform = CGAffineTransformMakeScale(1.4, 1.4);
//    } completion:^(BOOL finished) {
//        if (iOS(7)) {
//            CGAffineTransform transform = self.transform;
//            self.transform = CGAffineTransformIdentity;
//            if (animation) {
//                animation();
//            }
//            self.transform = transform;
//            POPSpringAnimation *ani = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
//            ani.springBounciness = 25;
//            ani.springSpeed = 16;
//            [ani setCompletionBlock:^(POPAnimation *ani, BOOL flag) {
//                if (complete) {
//                    complete();
//                }
//            }];
//            [ani setToValue:[NSValue valueWithCGPoint:CGPointMake(1.0f, 1.0f)]];
//            [self pop_addAnimation:ani forKey:nil];
//        } else {
//            CGAffineTransform transform = self.transform;
//            self.transform = CGAffineTransformIdentity;
//            if (animation) {
//                animation();
//            }
//            self.transform = transform;
//            [UIView animateWithDuration:0.15f animations:^{
//                self.transform = CGAffineTransformIdentity;
//            } completion:^(BOOL finished) {
//                if (complete) {
//                    complete();
//                }
//            }];
//        }
//    }];
//}

- (void)startKeyframeAnimationWithImages:(NSArray *)images duration:(CFTimeInterval)duration repeatCount:(float)repeatCount
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.calculationMode = kCAAnimationDiscrete;
    animation.duration = duration;
    animation.values = images;
    animation.repeatCount = repeatCount;
    [self.layer addAnimation:animation forKey:@"animation"];
}

- (void)shake
{
    CAKeyframeAnimation *keyAn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyAn setDuration:0.5f];
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      nil];
    [keyAn setValues:array];
    
    NSArray *times = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:0.1f],
                      [NSNumber numberWithFloat:0.2f],
                      [NSNumber numberWithFloat:0.3f],
                      [NSNumber numberWithFloat:0.4f],
                      [NSNumber numberWithFloat:0.5f],
                      [NSNumber numberWithFloat:0.6f],
                      [NSNumber numberWithFloat:0.7f],
                      [NSNumber numberWithFloat:0.8f],
                      [NSNumber numberWithFloat:0.9f],
                      [NSNumber numberWithFloat:1.0f],
                      nil];
    [keyAn setKeyTimes:times];
    
    [self.layer addAnimation:keyAn forKey:@"TextAnim"];
}

- (void)startWiggleAnimation
{
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    theAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.92, 1.08, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.02, 0.98, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 1.01, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 0.96, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.96, 1.03, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0.92, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.96, 1.01, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.01, 0.95, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                           nil];
    theAnimation.cumulative = YES;
    theAnimation.calculationMode = kCAAnimationLinear;
    theAnimation.duration = 3.5;
    theAnimation.repeatCount = HUGE_VALF;
    theAnimation.autoreverses = YES;
    [self.layer addAnimation:theAnimation forKey:@"transform"];
}

- (void)startScaleAnimationDelay:(CGFloat)delay complete:(void (^)(void))complete
{
    //    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    //    theAnimation.values = [NSArray arrayWithObjects:
    //                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],
    //                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)],
    //                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.25, 1.25, 1)],
    //                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
    //                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1)],
    //                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)],
    //                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
    //                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
    //                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.98, 0.98, 1)],
    //                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
    //                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
    //                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
    //                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
    //                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
    //                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
    //                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
    //                           nil];
    //    theAnimation.cumulative = YES;
    //    theAnimation.calculationMode = kCAAnimationLinear;
    //    theAnimation.duration = 2.f;
    //    theAnimation.repeatCount = 2;
    ////    theAnimation.autoreverses = YES;
    //    [self.layer addAnimation:theAnimation forKey:@"transform"];
    
    [UIView animateWithDuration:0.15f delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15f animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (complete) {
                complete();
            }
        }];
    }];
}

- (void)startScaleAnimation
{
    [self startDTShakeAnimationWithRepeatCount:HUGE_VALF];
}

- (void)startScaleAnimationWithRepeatCount:(float)repeatCount
{
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    theAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.15, 1.15, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                           nil];
    theAnimation.cumulative = YES;
    theAnimation.calculationMode = kCAAnimationLinear;
    theAnimation.duration = 2.f;
    theAnimation.repeatCount = repeatCount;
    theAnimation.autoreverses = NO;
    theAnimation.removedOnCompletion = NO;
    //    self.layer.shouldRasterize = YES;//抗锯齿
    [self.layer addAnimation:theAnimation forKey:@"transform"];
}



- (void)startDTShakeAnimation
{
    [self startDTShakeAnimationWithRepeatCount:HUGE_VALF];
}

- (void)startDTShakeAnimationWithRepeatCount:(float)repeatCount
{
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    theAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI/42, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/42, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI/36, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/36, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI/42, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/42, 0, 0, 1)],
                           nil];
    theAnimation.cumulative = YES;
    theAnimation.calculationMode = kCAAnimationLinear;
    theAnimation.duration = 2.0;
    theAnimation.repeatCount = repeatCount;
    theAnimation.autoreverses = YES;
    theAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:theAnimation forKey:@"transform"];
}

- (void)startDTShakeAnimationWithRepeatCountNew:(float)repeatCount
{
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    theAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI/36, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/36, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI/30, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/30, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI/36, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/36, 0, 0, 1)],
                           nil];
    theAnimation.cumulative = YES;
    theAnimation.calculationMode = kCAAnimationLinear;
    theAnimation.duration = 1.2;
    theAnimation.repeatCount = repeatCount;
    theAnimation.autoreverses = YES;
    theAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:theAnimation forKey:@"transform"];
}

- (void)scaleAnimationDelay:(CGFloat)delay repeatCount:(float)repeatCount
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = delay;// 动画时间
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.repeatCount = repeatCount;
    animation.autoreverses = YES;
    animation.removedOnCompletion = NO;
    animation.values = values;
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)startFlipAnimation
{
    [self startFlipAnimationWithRepeatCount:3];
}

- (void)startFlipAnimationWithRepeatCount:(float)repeatCount
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 4.5;// 动画时间
    NSMutableArray *values = [NSMutableArray array];
    
    CGFloat m34 = 800;
    CATransform3D transfrom = CATransform3DIdentity;
    transfrom.m34 = 1.0 / m34;
    //    transfrom = CATransform3DRotate(transfrom, M_PI*2, 0.0f, 1.0f, 0.0f);//(后面3个 数字分别代表不同的轴来翻转，本处为y轴)
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(transfrom, (M_PI - 0.001) * 1, 0.0f, 1.0f, 0.0f)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(transfrom, (M_PI - 0.001) * 2, 0.0f, 1.0f, 0.0f)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(transfrom, (M_PI - 0.001) * 1, 0.0f, 1.0f, 0.0f)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(transfrom, (M_PI - 0.001) * 2, 0.0f, 1.0f, 0.0f)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    
    animation.repeatCount = repeatCount;
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.values = values;
    
    CGPoint point = CGPointMake(0.5, 0.5);//设定翻转时的中心点，0.5为视图layer的正中
    CALayer *layer = self.layer;
    layer.anchorPoint = point;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)startTranslationAnimation:(CGFloat)move duration:(CGFloat)duration repeatCount:(float)repeatCount
{
    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"position"];
    translation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)];
    translation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y+move)];
    translation.duration = duration;
    
    translation.repeatCount = repeatCount;
    translation.autoreverses = YES;
    translation.removedOnCompletion = NO;
    [self.layer addAnimation:translation forKey:@"translation"];
}

- (void)animationWithType:(DTAnimationConfigType)type repeatCount:(float)repeatCount
{
    if (type == DTAnimationConfigTypeNone) {
        return;
    }
    if (repeatCount < 0.1) {
        repeatCount = HUGE_VALF;
    }
    switch (type) {
        case DTAnimationConfigTypeScale:
            return [self startScaleAnimationWithRepeatCount:repeatCount];
            break;
        case DTAnimationConfigTypeShake:
            return [self startDTShakeAnimationWithRepeatCountNew:repeatCount];
            break;
        case DTAnimationConfigTypeFlip:
            return [self startFlipAnimationWithRepeatCount:repeatCount];
            break;
        case DTAnimationConfigTypeUpDown:
            return [self startTranslationAnimation:5 duration:1 repeatCount:repeatCount];
            break;
        default:
            break;
    }
}

@end

@implementation UIView (Animate)

- (void)expandAnimated:(CGRect)rect {
    CGFloat x = CGRectGetMidX(rect);
    CGFloat y = CGRectGetMidY(rect);
    CGFloat w = x*2 > self.width ? x : self.width-x;
    CGFloat h = y*2 > self.height ? y : self.height-y;
    CGFloat r = sqrtf(pow(w, 2) + pow(h, 2));
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, -r, -r)].CGPath;
    self.layer.mask = maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.fromValue = (id)([UIBezierPath bezierPathWithOvalInRect:rect].CGPath);
    animation.duration = r/800;
    [maskLayer addAnimation:animation forKey:@"path"];
}

@end

@implementation UIView (pathAnimation)

CAKeyframeAnimation* keyframeAniamtionTarget(CGPathRef path, float time, float repeatTimes, id target)
{
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path=path;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.autoreverses=NO;
    animation.duration=time;
    return animation;
}

- (void)addAnimation:(CGPathRef)path time:(float)time
{
    [self.layer addAnimation:keyframeAniamtionTarget(path, time, 1, nil) forKey:nil];
}

CGFloat ArcAngle(CGFloat angle)
{
    return angle / 180.f * M_PI;
}

CGFloat ArcDistance(CGPoint center, CGPoint point)
{
    CGFloat x = fabs(point.x - center.x);
    CGFloat y = fabs(point.y - center.y);
    return sqrt(x * x + y * y);
}

CGFloat ArcAngleFrom(CGPoint center, CGPoint point)
{
    CGFloat x = point.x - center.x;
    CGFloat y = point.y - center.y;
    CGFloat d = ArcDistance(center, point);
    
    CGFloat angle = acos(x / d);//取值区间为 0 ~ π
    
    if (y < 0) {
        angle = M_PI * 2 - angle;
    }
    
    return angle;
}

CGPoint ArcPoint(CGPoint center, CGFloat radius, CGFloat angle)
{
    return ArcPointPercent(center, radius, angle, 1.f);
}

CGPoint ArcPointPercent(CGPoint center, CGFloat radius, CGFloat angle, CGFloat percent)
{
    return CGPointMake(center.x + cos(angle) * radius * percent, center.y + sin(angle) * radius * percent);
}


@end


@implementation UITableViewCell (cellAnimation)

- (void)startDisplayAnimation:(BOOL)animation
{
    if (animation) {
        self.layer.opacity = 0.0f;
        self.layer.transform = CATransform3DTranslate(CATransform3DMakeScale(1.1f, 1.1f, 1.0f), 0, 15.0f, 0);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.6f];
        self.layer.transform = CATransform3DIdentity;
        self.layer.opacity = 1.0f;
        [UIView commitAnimations];
    } else {
        self.layer.opacity = 0.0f;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.6f];
        self.layer.opacity = 1.0f;
        [UIView commitAnimations];
    }
}

@end
