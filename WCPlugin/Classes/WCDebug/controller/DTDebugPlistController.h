//
//  DTDebugPlistController.h
//  DrivingTest
//
//  Created by cheng on 2017/8/22.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTDebugPlistController : UIViewController

@property (nonatomic, strong) id item;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSArray *array;

- (void)setItemWithPath:(NSString *)path;

@end
