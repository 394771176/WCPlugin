//
//  UIView+DebugTest.h
//  DrivingTest
//
//  Created by cheng on 2020/11/12.
//  Copyright © 2020 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

extern UIColor * RandomColor(void);
extern UIColor * RandomAlphaColor(void);

@interface UIView (DebugTest)

@property (nonatomic, strong) UIColor *markBgColor;

/**
 *  调试用的方法
 */
//随机颜色
+ (UIColor *)randomColor;
+ (UIColor *)randomAlphaColor;

//展示全部子视图，并添加随机背景色
- (void)showSubView;
//展示全部子视图，并添加随机描边色
- (void)showSubViewLayerborder;

//展示全部子视图，并添加随机背景色, 并标记原色值
- (void)showSubViewWithMark;

//设置随机背景色
- (void)randomBgColor;

//点击后自动移除
- (void)autoRemoveByTapSelf;
//点击后自动移除
- (void)autoRemoveByLongTapSelf;

/**判断某个子视图的位置，如果存在则返回该子视图*/
- (UIView *)isExistSubViewForClass:(Class)subViewClass;

@end
