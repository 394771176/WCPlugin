//
//  DTDebugDragView.h
//  DrivingTest
//
//  Created by cheng on 2020/11/17.
//  Copyright © 2020 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTDebugDragView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) void(^dismissBlock)(void);

- (void)panAction:(UIPanGestureRecognizer *)gesture;

@end

@interface DTDebugDragSizeView : DTDebugDragView

@end

@interface DTDebugDragBgView : DTDebugDragView

@property (nonatomic, assign) NSInteger bgColorIndex;
@property (nonatomic, assign) BOOL showSuperBg;

@end

NS_ASSUME_NONNULL_END
