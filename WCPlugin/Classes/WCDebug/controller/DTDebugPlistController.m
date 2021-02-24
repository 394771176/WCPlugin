//
//  DTDebugPlistController.m
//  DrivingTest
//
//  Created by cheng on 2017/8/22.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "DTDebugPlistController.h"
#import "DTDebugTextController.h"
#import "DTDebugListCell.h"
#import "DTDebugUtil.h"

@interface DTDebugPlistController () <UITableViewDataSource, UITableViewDelegate, DTDebugListCellDelegate, UIActionSheetDelegate, DTDebugTextControllerDelegate> {
    UITableView *_tableView;
    
    NSString *_path;
    
    DTDebugListCell *_markCell;
}

@end

@implementation DTDebugPlistController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.dict && !self.array) {
        NSArray *array = [self.dict allKeys];
        self.array = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_tableView];

}

- (void)setItem:(id)item
{
    if ([item isKindOfClass:[NSDictionary class]]) {
        self.dict = item;
    } else if ([item isKindOfClass:[NSArray class]]) {
        self.array = item;
    }
}

- (void)setItemWithPath:(NSString *)path
{
    _path = path;
    self.title = [path lastPathComponent];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    if (dict) {
        self.dict = dict;
    } else {
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        self.array = array;
    }
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.array) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.array.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DTDebugListCell";
    DTDebugListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DTDebugListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
    }
    NSString *key = [self.array objectAtIndex:indexPath.row];
    cell.title = [NSString stringWithFormat:@"%@", key];
    if (self.dict) {
        cell.content = [NSString stringWithFormat:@"%@", [self.dict objectForKey:key]];
    }
    return cell;
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id obj = nil;
    NSString *key = nil;
    if (self.dict) {
        key = [self.array objectAtIndex:indexPath.row];
        obj = [self.dict objectForKey:key];
        key = [NSString stringWithFormat:@"%@", key];
    } else {
        obj = [self.array objectAtIndex:indexPath.row];
    }
    
    if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]) {
        DTDebugPlistController *controller = [[DTDebugPlistController alloc] init];
        controller.title = key;
        controller.item = obj;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        NSString *string = [NSString stringWithFormat:@"%@", obj];
        DTDebugTextController *controller = [[DTDebugTextController alloc] init];
        controller.title = key;
        controller.text = string;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - DTDebugListCellDelegate

- (void)debugListCellDidLongPressAction:(DTDebugListCell *)cell
{
    if (_path) {
        _markCell = cell;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"plist" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑",@"拷贝", nil];
        [actionSheet showInView:self.view];
    } else {
        [UIPasteboard generalPasteboard].string = cell.content?:cell.title;
        [MBProgressHUD showHUDMessageInWindow:@"已拷贝至粘贴板"];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSIndexPath *indexPath = [_tableView indexPathForCell:_markCell];
        id obj = nil;
        NSString *key = nil;
        if (self.dict) {
            key = [self.array objectAtIndex:indexPath.row];
            obj = [self.dict objectForKey:key];
            key = [NSString stringWithFormat:@"%@", key];
        } else {
            obj = [self.array objectAtIndex:indexPath.row];
        }
        
        if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
            NSString *string = [NSString stringWithFormat:@"%@", obj];
            DTDebugTextController *controller = [[DTDebugTextController alloc] init];
            controller.title = key;
            controller.text = string;
            controller.delegate = self;
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            [MBProgressHUD showHUDMessageInWindow:@"该数据暂不支持修改"];
        }
    } else if (buttonIndex == 1) {
        [UIPasteboard generalPasteboard].string = _markCell.content?:_markCell.title;
    }
}

#pragma mark - DTDebugTextControllerDelegate

- (void)debugTextControllerDidEdit:(DTDebugTextController *)controller
{
    NSString *string = controller.text;
    NSIndexPath *indexPath = [_tableView indexPathForCell:_markCell];
    id obj = nil;
    NSString *key = nil;
    if (self.dict) {
        key = [self.array objectAtIndex:indexPath.row];
        obj = [self.dict objectForKey:key];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_dict];
        if ([obj isKindOfClass:[NSString class]]) {
            [dict setObject:string forKey:key];
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            NSString *objStr = [obj stringValue];
            if ([objStr rangeOfString:@"."].length) {
                [dict setObject:[NSNumber numberWithDouble:[string doubleValue]] forKey:key];
            } else {
                [dict setObject:[NSNumber numberWithInteger:[string integerValue]] forKey:key];
            }
        }
        [dict writeToFile:_path atomically:YES];
    } else {
        obj = [self.array objectAtIndex:indexPath.row];
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:_array];
        if ([obj isKindOfClass:[NSString class]]) {
            [array replaceObjectAtIndex:indexPath.row withObject:string];
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            NSString *objStr = [obj stringValue];
            if ([objStr rangeOfString:@"."].length) {
                [array replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithDouble:[string doubleValue]]];
            } else {
                [array replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInteger:[string integerValue]]];
            }
        }
        [array writeToFile:_path atomically:YES];
    }
    
    [self setItemWithPath:_path];
    [_tableView reloadData];
    
    [controller.navigationController popViewControllerAnimated:YES];
}

@end
