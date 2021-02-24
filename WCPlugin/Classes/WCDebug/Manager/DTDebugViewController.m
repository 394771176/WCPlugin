//
//  DTDebugViewController.m
//  DrivingTest
//
//  Created by cheng on 2017/8/21.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "DTDebugViewController.h"
#import "DTDebugFileController.h"
#import "DTDebugPlistController.h"
#import "DTDebugListCell.h"
#import "DTDebugManager.h"

@interface DTDebugViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, DTDebugListCellDelegate> {
    UITableView *_tableView;
    
    NSArray *_titleArray;
    NSArray *_dataSource;
}

@end

@implementation DTDebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"DEBUG";
    
    _titleArray = @[@"info", @"tools", @"file"];
    _dataSource = @[
                    @[@"APP信息", @"用户信息", @"系统参数"],
                    @[@"扫一扫", @"DEBUG模式", @"查阅模式", @"服务器", @"显示日志", @"显示FPS", @"Lottie预览", @"允许zhua包", @"【Flutter】zhua包IP", @"服务器时间"],
                    @[@"沙盒", @"清空本地数据"]
                    ];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [_dataSource objectAtIndex:section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerId = @"UITableViewHeaderFooterView";
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerId];
        view.frame = CGRectMake(0, 0, tableView.width, 32);
        view.backgroundColor = [UIColor colorWithHexString:@"e3e3e3"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 6, tableView.width - 24, view.height - 6)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        label.textColor = [UIColor colorWithHexString:@"9e9e9e"];
        label.font = [UIFont systemFontOfSize:13];
        label.tag = 888;
        [view addSubview:label];
    }
    UILabel *label = [view viewWithTag:888];
    label.text = [_titleArray objectAtIndex:section];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DTDebugListCell";
    DTDebugListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DTDebugListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
    }
    NSArray *array = [_dataSource objectAtIndex:indexPath.section];
    cell.title = [array objectAtIndex:indexPath.row];
    if ([cell.title isEqualToString:@"用户信息"]) {
        if ([[DTDebugManager sharedInstance] getUserId]) {
            cell.content = [NSString stringWithFormat:@"%@", [[DTDebugManager sharedInstance] getUserId]];
        } else {
            cell.content = @"未登录";
        }
    } else if ([cell.title isEqualToString:@"显示日志"]) {
        cell.content = [DTDebugManager sharedInstance].showLog ? @"开启" : @"关闭";
    } else if ([cell.title isEqualToString:@"显示FPS"]) {
        cell.content = [DTDebugManager sharedInstance].showFPS ? @"开启" : @"关闭";
    } else if ([cell.title isEqualToString:@"允许zhua包"]) {
        cell.content = [DTDebugManager sharedInstance].holdRequest ? @"开启" : @"关闭";
    } else if ([cell.title isEqualToString:@"服务器时间"]) {
        cell.content = [DTDebugManager sharedInstance].useServerTime ? @"开启" : @"关闭";
    } else if ([cell.title isEqualToString:@"DEBUG模式"]) {
        cell.content = [DTDebugManager sharedInstance].appDebug ? @"开启" : @"关闭";
    } else if ([cell.title isEqualToString:@"服务器"]) {
        cell.content = [DTDebugManager currentServerTitle];
    } else if ([cell.title isEqualToString:@"查阅模式"]) {
        cell.content = [DTDebugManager sharedInstance].appVerify ? @"开启" : @"关闭";
    } else if ([cell.title isEqualToString:@"【Flutter】zhua包IP"]) {
        cell.content = [DTDebugManager sharedInstance].holdProxy;
    } else if ([cell.title isEqualToString:@"查阅模式"]) {
        cell.content = [DTDebugManager sharedInstance].appVerify ? @"开启" : @"关闭";
    }
//    else if ([cell.title isEqualToString:@"Lottie预览"]) {
//        cell.content = [DTDebugManager sharedInstance].seeLottie ? @"开启" : @"关闭";
//    }
    else {
        cell.content = nil;
    }
    return cell;
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DTDebugListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *string = cell.title;
    if ([string isEqualToString:@"APP信息"]) {
        DTDebugPlistController *controller = [[DTDebugPlistController alloc] init];
        controller.title = string;
        controller.item = [[DTDebugManager sharedInstance] getAPPInfo];
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([string isEqualToString:@"用户信息"]) {
        DTDebugPlistController *controller = [[DTDebugPlistController alloc] init];
        controller.title = string;
        controller.item = [[DTDebugManager sharedInstance] getUserInfo];
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([string isEqualToString:@"系统参数"]) {
        DTDebugPlistController *controller = [[DTDebugPlistController alloc] init];
        controller.title = string;
        controller.item = [[DTDebugManager sharedInstance] getSystemInfo];
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([string isEqualToString:@"扫一扫"]) {
//        [FFQRCodeScanController showInViewController:[DTPubUtil mainController] handle:^UIViewController *(NSString *output) {
//            if (output.length) {
//                UIViewController *controller = [SCLinkAdapterUtil getControllerWithLink:output];
//
//                return controller;
//            }
//            return nil;
//        }];
    } else if ([string isEqualToString:@"沙盒"]) {
        DTDebugFileController *controller = [[DTDebugFileController alloc] init];
        controller.path = NSHomeDirectory();
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([string isEqualToString:@"显示日志"]) {
        [DTDebugManager sharedInstance].showLog = ![DTDebugManager sharedInstance].showLog;
        [tableView reloadData];
    } else if ([string isEqualToString:@"显示FPS"]) {
        [DTDebugManager sharedInstance].showFPS = ![DTDebugManager sharedInstance].showFPS;
        [tableView reloadData];
    } else if ([string isEqualToString:@"允许zhua包"]) {
        [DTDebugManager sharedInstance].holdRequest = ![DTDebugManager sharedInstance].holdRequest;
        [tableView reloadData];
    } else if ([string isEqualToString:@"【Flutter】zhua包IP"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入flutter代理IP" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert textFieldAtIndex:0].placeholder = @" ip+端口,端口不填默认8888";
        [alert textFieldAtIndex:0].text = [DTDebugManager sharedInstance].holdProxy?:@"10.10.28.xx";
        [alert textFieldAtIndex:0].clearButtonMode = UITextFieldViewModeWhileEditing;
        alert.tag = 1111;
        [alert show];
    } else if ([cell.title isEqualToString:@"服务器时间"]) {
        [DTDebugManager sharedInstance].useServerTime = ![DTDebugManager sharedInstance].useServerTime;
        [tableView reloadData];
    } else if ([string isEqualToString:@"DEBUG模式"]) {
        [DTDebugManager sharedInstance].appDebug = ![DTDebugManager sharedInstance].appDebug;
        [tableView reloadData];
    } else if ([string isEqualToString:@"服务器"]) {
        [DTDebugManager showServerList:^{
            [tableView reloadData];
        }];
    } else if ([string isEqualToString:@"查阅模式"]) {
        [DTDebugManager sharedInstance].appVerify = ![DTDebugManager sharedInstance].appVerify;
        [tableView reloadData];
    } else if ([string isEqualToString:@"清空本地数据"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定要清空所有本地数据吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空数据", nil];
        [alert show];
    }
    else {
        [MBProgressHUD showHUDMessageInWindow:string];
    }
}

#pragma mark - DTDebugListCellDelegate

- (void)debugListCellDidLongPressAction:(DTDebugListCell *)cell
{
    if (cell.content.length) {
        [UIPasteboard generalPasteboard].string = cell.content;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag == 1111) {
            //flutter 代理IP
            NSString *text = [alertView textFieldAtIndex:0].text;
            [DTDebugManager sharedInstance].holdProxy = text;
            [_tableView reloadData];
            return;
        }
        [DTDebugManager removeAllFilesInDocument];
    }
}

@end

