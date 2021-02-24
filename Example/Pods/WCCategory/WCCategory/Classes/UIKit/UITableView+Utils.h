//
//  UITableView+Utils.h
//  DrivingTest
//
//  Created by cheng on 2017/11/21.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Utils)

//section之前header、cell、footer的高度之和
- (CGFloat)totalHeightToSection:(NSInteger)section target:(id<UITableViewDelegate, UITableViewDataSource>)target;

//indexpath之前header、cell、footer的高度之和, 和👆section的区别在于，即使row为0时，也会包含当前section的header的高度
- (CGFloat)totalHeightToIndexPath:(NSIndexPath *)indexPath target:(id<UITableViewDelegate, UITableViewDataSource>)target;

- (void)setTableHeaderHeight:(CGFloat)height;
- (void)setTableFooterHeight:(CGFloat)height;
- (void)setTableHeaderHeight:(CGFloat)hHeight footerHeight:(CGFloat)fHeight;

@end

@interface UITableView (DTInsetTab)

@property (nonatomic, assign) BOOL shouldRecognizeSimultaneouslyDT;
@property (nonatomic, weak) UITableView *anotherTable;

@end
