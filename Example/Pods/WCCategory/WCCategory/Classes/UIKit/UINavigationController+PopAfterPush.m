//
//  UINavigationController+PopAfterPush.m
//  QueryViolations
//
//  Created by ali on 14-10-17.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "UINavigationController+PopAfterPush.h"
#import "WCCategory+UI.h"

@implementation UINavigationController (PopAfterPush)

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated complete:(void (^)(void))completion
{
    if (completion) {
        [CATransaction begin];
        [CATransaction setCompletionBlock:completion];
        [self pushViewController:viewController animated:animated];
        [CATransaction commit];
    } else {
        [self pushViewController:viewController animated:animated];
    }
}

- (void)pushViewControllerWithPopOneController:(UIViewController *)viewController
{
    __block id controller = [self.viewControllers lastObject];
    [self pushViewController:viewController animated:YES complete:^{
        NSMutableArray *controllerList = [self.viewControllers mutableCopy];
        if (controller!=[controllerList firstObject]) {
            [controllerList removeObject:controller];
            self.viewControllers = [NSArray arrayWithArray:controllerList];
        }
    }];
}

- (void)pushViewControllerWithPopToRootController:(UIViewController *)viewController
{
    __block NSInteger index = self.viewControllers.count - 1;
    [self pushViewController:viewController animated:YES complete:^{
        NSMutableArray *controllerList = [self.viewControllers mutableCopy];
        while (index > 0) {
            [controllerList removeObjectAtIndex:index];
            index --;
        }
        self.viewControllers = [NSArray arrayWithArray:controllerList];
    }];
}

- (void)pushViewControllerController:(UIViewController *)viewController withPopToControllerClass:(Class)popClass
{
    [self pushViewController:viewController animated:YES complete:^{
        NSMutableArray *controllerList = [self.viewControllers mutableCopy];
        for (int i=0; i<controllerList.count - 2; i++) {
            UIViewController *vc = [controllerList safeObjectAtIndex:i];
            if ([vc isKindOfClass:popClass]) {
                [controllerList removeObjectsInRange:NSMakeRange(i+1, controllerList.count-i-2)];
                self.viewControllers = [NSArray arrayWithArray:controllerList];
                break;
            }
        }
    }];
}

- (void)insertControllerForBackAction:(UIViewController *)controller
{
    if (!controller) {
        return;
    }
    NSArray *controlls = self.viewControllers;
    if (controlls.count <= 1) {
        return;
    }
    NSMutableArray *newControlls = [NSMutableArray arrayWithArray:controlls];
    [newControlls insertObject:controller atIndex:controlls.count-1];
    self.viewControllers = newControlls;
}

- (void)insertControllerAndDidBackAction:(UIViewController *)controller
{
    [self insertControllerForBackAction:controller];
    [self.navigationController popViewControllerAnimated:YES];
}

//跳转页面时 移除队列指定class的vc
- (void)pushViewController:(UIViewController *)viewController withPopControllerClass:(Class)popClass
{
    __block NSUInteger index = self.viewControllers.count - 1;
    [self pushViewController:viewController animated:YES complete:^{
        NSMutableArray *controllerList = [self.viewControllers mutableCopy];
        while (index > 0) {
            UIViewController *vc = [controllerList safeObjectAtIndex:index];
            if ([vc isKindOfClass:popClass]) {
                [controllerList removeObjectAtIndex:index];
            }
            index --;
        }
        self.viewControllers = [NSArray arrayWithArray:controllerList];
    }];
}

- (id)findControllerWithControllerClass:(Class)controllerClass
{
    return [self findControllerWithControllerClass:controllerClass compareBlock:nil];
}

- (id)findControllerWithControllerClass:(Class)controllerClass compareBlock:(BOOL (^)(id controller))compareBlock
{
    NSArray *controllerList = self.viewControllers;
    id result = nil;
    for (int i=0; i<controllerList.count-1; i++) {
        id controller = [controllerList safeObjectAtIndex:i];
        if ([controller isKindOfClass:controllerClass]) {
            if (compareBlock) {
                if (compareBlock(controller)) {
                    result = controller;
                    break;
                }
            } else {
                result = controller;
                break;
            }
        }
    }
    return result;
}

@end
