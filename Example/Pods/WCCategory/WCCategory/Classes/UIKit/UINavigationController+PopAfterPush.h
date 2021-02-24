//
//  UINavigationController+PopAfterPush.h
//  QueryViolations
//
//  Created by ali on 14-10-17.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 push以后，pop掉上一个controler
 */
@interface UINavigationController (PopAfterPush)

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated complete:(void (^)(void))completion;

- (void)pushViewControllerWithPopOneController:(UIViewController *)viewController;

- (void)pushViewControllerWithPopToRootController:(UIViewController *)viewController;

- (void)pushViewControllerController:(UIViewController *)viewController withPopToControllerClass:(Class)popClass;

//跳转页面时 移除队列指定class的vc
- (void)pushViewController:(UIViewController *)viewController withPopControllerClass:(Class)popClass;

//返回的前面插入一个界面
- (void)insertControllerForBackAction:(UIViewController *)controller;
//返回的前面插入一个界面，同时执行返回操作
- (void)insertControllerAndDidBackAction:(UIViewController *)controller;

- (id)findControllerWithControllerClass:(Class)controllerClass;
- (id)findControllerWithControllerClass:(Class)controllerClass compareBlock:(BOOL (^)(id controller))compareBlock;

@end
