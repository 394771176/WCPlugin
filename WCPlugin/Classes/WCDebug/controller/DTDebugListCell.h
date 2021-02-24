//
//  DTDebugListCell.h
//  DrivingTest
//
//  Created by cheng on 2017/8/22.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTDebugListCell;

@protocol DTDebugListCellDelegate <NSObject>

- (void)debugListCellDidLongPressAction:(DTDebugListCell *)cell;

@end

@interface DTDebugListCell : UITableViewCell

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, weak) id<DTDebugListCellDelegate> delegate;

- (void)showArrow:(BOOL)show;//default show is yes

- (void)setTitle:(NSString *)title content:(NSString *)content;

@end
