//
//  DTDebugFileController.m
//  DrivingTest
//
//  Created by cheng on 2017/8/22.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "DTDebugFileController.h"
#import "DTDebugPlistController.h"
#import "DTDebugListCell.h"
#import "DTDebugTextController.h"
#import "DTDebugUtil.h"

BOOL DTCreateFolderIfNeeded(NSString *dirPath) {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager new];
    if (![fileManager fileExistsAtPath:dirPath]) {
        if (![fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"Unable to create folder at %@: %@", dirPath, error.localizedDescription);
            return NO;
        }
    }
    return YES;
}

@interface DTDebugFileController () <UITableViewDelegate, UITableViewDataSource, UIDocumentInteractionControllerDelegate, DTDebugListCellDelegate> {
    UITableView *_tableView;
    UITextView *_textView;
    
    UIImageView *_imageView;
    
    NSArray *_dataSource;
    
    NSString *_markPath;
}

@property (nonatomic, assign) BOOL isDir;

@end

@implementation DTDebugFileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [DTDebugUtil barButtonItemWithTitle:@"copy" target:self action:@selector(rightBtnAction)];
    
    if (_isDir) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:_tableView];
        
        [self showSubPaths];
    } else {
        _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:_textView];
        
        [self showFileContent];
    }
}

- (void)setPath:(NSString *)path
{
    _path = path;
    self.isDir = [DTFileManager isFileDirectory:path];
    self.title = [_path lastPathComponent];
    NSLog(@"\n%@", path);
}

- (void)showFileContent
{
    if ([self.path hasSuffix:@".plist"]) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:self.path];
        if (dict) {
            NSString *string = [dict JSONString];
            _textView.text = string;
        } else {
            NSArray *array = [NSArray arrayWithContentsOfFile:self.path];
            NSString *string = [array JSONString];
            _textView.text = string;
        }
    } else if ([self.path hasSuffix:@".txt"] ||
               [self.path hasSuffix:@".json"] ||
               [self.path hasSuffix:@".sql"] ||
               [self.path hasSuffix:@".crv"]) {
        NSString *string = [NSString stringWithContentsOfFile:self.path encoding:NSUTF8StringEncoding error:NULL];
        _textView.text = string;
    } else if ([self.path hasSuffix:@".jpg"] ||
               [self.path hasSuffix:@".png"] ||
               [self.path hasSuffix:@".gif"] ||
               [self.path hasSuffix:@".jpeg"]) {
        if (!_imageView) {
            _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
            _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:_imageView];
        }
        _imageView.image = [UIImage imageWithContentsOfFile:self.path];
    } else {
        _textView.text = self.path;
    }
}

- (void)showSubPaths
{
    _dataSource = [DTFileManager contentsWithPath:self.path];
    [_tableView reloadData];
}

- (void)rightBtnAction
{
    if (self.path) {
        if (_isDir) {
            [UIPasteboard generalPasteboard].string = self.path?:@"";
        } else {
            [UIPasteboard generalPasteboard].string = _textView.text?:@"";
        }
    } else {
        [UIPasteboard generalPasteboard].string = _textView.text?:@"";
    }
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isDir) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _dataSource.count;
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
    cell.title = [_dataSource objectAtIndex:indexPath.row];
    NSString *path = [self.path stringByAppendingPathComponent:cell.title];
    BOOL isDir = [DTFileManager isFileDirectory:path];
    if (isDir) {
        cell.content = [NSString stringWithFormat:@"(%ld)", [DTFileManager contentsWithPath:path].count];
    } else {
        cell.content = nil;
    }
    return cell;
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *path = [self.path stringByAppendingPathComponent:[_dataSource objectAtIndex:indexPath.row]];
    if ([path hasSuffix:@".plist"]) {
        DTDebugPlistController *controller = [[DTDebugPlistController alloc] init];
        [controller setItemWithPath:path];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        DTDebugFileController *controller = [[DTDebugFileController alloc] init];
        controller.path = path;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - DTDebugListCellDelegate

- (void)debugListCellDidLongPressAction:(DTDebugListCell *)cell
{
    _markPath = [self.path stringByAppendingPathComponent:cell.title];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"plist" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开",@"文本格式",@"拷贝到Doc", nil];
    [actionSheet showInView:self.view];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self.navigationController;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIDocumentInteractionController *_docVc = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:_markPath]];
        _docVc.delegate = self;
        [_docVc presentPreviewAnimated:YES];
    } else if (buttonIndex == 1) {
        NSString *string = [NSString stringWithContentsOfFile:_markPath encoding:NSUTF8StringEncoding error:NULL];
        DTDebugTextController *vc = [[DTDebugTextController alloc] init];
        vc.text = string;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (buttonIndex == 2) {
        NSString *lastPath = _markPath.lastPathComponent;
        NSString *toPath = [DOC_PATH stringByAppendingPathComponent:@"DEBUG_COPY"];
        NSString *toFilePath = [toPath stringByAppendingPathComponent:lastPath];
        DTCreateFolderIfNeeded(toPath);
        [DTFileManager copyItemWithPath:_markPath toPath:toFilePath];
        [MBProgressHUD showHUDMessageInWindow:@"已拷贝"];
    }
}

@end
