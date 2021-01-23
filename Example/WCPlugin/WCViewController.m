//
//  WCViewController.m
//  WCPlugin
//
//  Created by 394771176 on 02/23/2020.
//  Copyright (c) 2020 394771176. All rights reserved.
//

#import "WCViewController.h"
#import <WCPlugin/MBProgressHUDAdditions.h>

@interface WCViewController ()

@end

@implementation WCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    static int i = 0;
    int  n = i % 5;
    if (n == 0) {
        [MBProgressHUD showHUDLoadingMessageInWindow:@"请求中..."];
        [MBProgressHUD stopLoadingHUD:1];
    } else if (n == 1) {
        [MBProgressHUD showHUDErrorHintInWindow:@"请求失败"];
    } else if (n == 2) {
        [MBProgressHUD showHUDNoNetworkHintInWindow:@"网络异常"];
    } else if (n == 3) {
        [MBProgressHUD showHUDSuccessHintInWindow:@"请求成功"];
    } else if (n == 4) {
        [MBProgressHUD showHUDMessageInWindow:@"好的"];
    }
    i++;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
