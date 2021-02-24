//
//  DTDebugTextController.m
//  Snake
//
//  Created by cheng on 17/8/19.
//  Copyright © 2017年 cheng. All rights reserved.
//

#import "DTDebugTextController.h"
#import "DTDebugUtil.h"

@interface DTDebugTextController () {
    UITextView *_textView;
}

@end

@implementation DTDebugTextController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_delegate) {
        self.navigationItem.rightBarButtonItem = [DTDebugUtil barButtonItemWithTitle:@"提交" target:self action:@selector(rightBtnAction)];
    } else {
        self.navigationItem.rightBarButtonItem = [DTDebugUtil barButtonItemWithTitle:@"copy" target:self action:@selector(rightBtnAction)];
    }
    
    
    _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_textView];
    
    _textView.text = _text;
}

- (void)rightBtnAction
{
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(debugTextControllerDidEdit:)]) {
            _text = _textView.text;
            [_delegate debugTextControllerDidEdit:self];
        }
    } else {
        [UIPasteboard generalPasteboard].string = _text?:@"";
    }
}

@end
