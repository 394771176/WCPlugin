//
//  DTDebugTextController.h
//  Snake
//
//  Created by cheng on 17/8/19.
//  Copyright © 2017年 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTDebugTextController;

@protocol DTDebugTextControllerDelegate <NSObject>

- (void)debugTextControllerDidEdit:(DTDebugTextController *)controller;

@end

@interface DTDebugTextController : UIViewController

@property (nonatomic, strong) NSString *text;
@property (nonatomic, weak) id<DTDebugTextControllerDelegate> delegate;

@end
