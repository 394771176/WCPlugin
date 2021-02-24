//
//  DTDebugListCell.m
//  DrivingTest
//
//  Created by cheng on 2017/8/22.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "DTDebugListCell.h"
#import "DTDebugUtil.h"

@interface DTDebugListCell () {
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    
    BOOL _show;
}

@end

@implementation DTDebugListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 4, 100, self.contentView.height - 8)];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _titleLabel.textColor = [UIColor colorWithHexString:@"131313"];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.minimumScaleFactor = 0.6;
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.right + 4 , _titleLabel.top, self.contentView.width - _titleLabel.right - 12, _titleLabel.height)];
        _contentLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _contentLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _contentLabel.adjustsFontSizeToFitWidth = YES;
        _contentLabel.numberOfLines = 2;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.minimumScaleFactor = 0.6;
        [self.contentView addSubview:_contentLabel];
        
        self.backgroundColor = [UIColor whiteColor];
        _show = YES;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [self.contentView addGestureRecognizer:longPress];
    }
    return self;
}

- (void)showArrow:(BOOL)show
{
    _show = show;
    if (show) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        CGFloat left = self.contentView.width - 24;
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                left = view.left;
                break;
            }
        }
        
        _contentLabel.frame = CGRectMake(_titleLabel.right + 4 , _titleLabel.top, left - _titleLabel.right - 12, _titleLabel.height);
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
        _contentLabel.frame = CGRectMake(_titleLabel.right + 4 , _titleLabel.top, self.contentView.width - _titleLabel.right - 12, _titleLabel.height);
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (void)setContent:(NSString *)content
{
    _content = content;
    _contentLabel.text = content;
}

- (void)setTitle:(NSString *)title content:(NSString *)content
{
    self.title = title;
    self.content = content;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self showArrow:_show];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (_delegate && [_delegate respondsToSelector:@selector(debugListCellDidLongPressAction:)]) {
            [_delegate debugListCellDidLongPressAction:self];
        }
    }
}

@end
