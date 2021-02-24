//
//  DTDebugPhotosController.m
//  DrivingTest
//
//  Created by cheng on 2017/8/22.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "DTDebugPhotosController.h"
#import "DTFileManager.h"

@interface DTDebugPhotosController () {
    UITableView *_tableView;
    
    NSArray *_dataSource;
}

@end

@implementation DTDebugPhotosController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图片浏览";
    
    _dataSource = [DTFileManager contentsWithPath:self.path];
 
    // uicollection
}

#pragma mark - UITableView


@end
