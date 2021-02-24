//
//  WCQuickUI.m
//  WCCategory
//
//  Created by cheng on 2020/3/18.
//

#import "WCQuickUI.h"
#import "WCCategory+UI.h"

UIColor *ColorFrom(id color)
{
    if (color) {
        if ([color isKindOfClass:UIColor.class]) {
            return color;
        } else if ([color isKindOfClass:NSString.class]) {
            return [UIColor colorWithString:color];
        }
    }
    return [UIColor clearColor];
}

UIFont *FontFrom(id font) {
    if (font) {
        if ([font isKindOfClass:UIFont.class]) {
            return font;
        } else if ([font isKindOfClass:NSNumber.class] || [font isKindOfClass:NSString.class]) {
            return [UIFont systemFontOfSize:[font integerValue]];
        }
    }
    return [UIFont systemFontOfSize:16];
}

UIImage *ImageFrom(id image) {
    if (image) {
        if ([image isKindOfClass:UIImage.class]) {
            return image;
        } else if ([image isKindOfClass:NSString.class]) {
            return [UIImage imageNamed:image];
        }
    }
    return nil;
}

@implementation UIView (Quick)

+ (id)Create:(CGRect)frame autoResizing:(NSUInteger)resizing bgColor:(id)bgColor addToView:(id)view
{
    UIView *aview = nil;
    if ([self isKindOfClass:UIButton.class]) {
        aview = [[self class] buttonWithType:UIButtonTypeCustom];
    } else {
        aview = [[self alloc] initWithFrame:frame];
    }
    aview.autoresizingMask = (UIViewAutoresizing)resizing;
    if (bgColor) {
        aview.backgroundColor = ColorFrom(bgColor);
    }
    if (view && [view respondsToSelector:@selector(addSubview:)]) {
        [view addSubview:aview];
    }
    return aview;
}

@end

@implementation UILabel (Quick)

+ (id)Create:(CGRect)frame autoResizing:(NSUInteger)resizing text:(NSString *)text alignment:(NSUInteger)alignment font:(id)font color:(id)color addToView:(id)view
{
    UILabel *label = [self Create:frame autoResizing:resizing bgColor:nil addToView:view];
    label.textAlignment = (NSTextAlignment)alignment;
    if (font) {
        label.font = FontFrom(font);
    }
    if (color) {
        label.textColor = ColorFrom(color);
    }
    if (text) {
        label.text = text;
    }
    return label;
}

@end

@implementation UIImageView (Quick)

+ (id)Create:(CGRect)frame autoResizing:(NSUInteger)resizing contentMode:(NSUInteger)mode image:(id)image addToView:(id)view
{
    UIImage *img = ImageFrom(image);
    if (CGRectEqualToRect(frame, CGRectZero) && img) {
        frame.size = img.size;
    }
    UIImageView *imageV = [self Create:frame autoResizing:resizing bgColor:nil addToView:view];
    imageV.contentMode = (UIViewContentMode)mode;
    [imageV setImage:img];
    return imageV;
}

@end

@implementation UIControl (Quick)

+ (id)Create:(CGRect)frame autoResizing:(NSUInteger)resizing target:(id)target action:(SEL)action addToView:(id)view
{
    UIControl *control = [self Create:frame autoResizing:resizing bgColor:nil addToView:view];
    if (target && action && [target respondsToSelector:action]) {
        [control addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return control;
}

@end

@implementation UIButton (Quick)

+ (id)Create:(CGRect)frame autoResizing:(NSUInteger)resizing image:(id)image target:(id)target action:(SEL)action addToView:(id)view
{
    UIButton *btn = [self Create:frame autoResizing:resizing target:target action:action addToView:view];
    if (image) {
        [btn setImage:ImageFrom(image) forState:UIControlStateNormal];
    }
    return btn;
}

+ (id)Create:(CGRect)frame autoResizing:(NSUInteger)resizing title:(NSString *)title font:(id)font color:(id)color target:(id)target action:(SEL)action addToView:(id)view
{
    UIButton *btn = [self Create:frame autoResizing:resizing target:target action:action addToView:view];
    if (title) {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (font) {
        [btn.titleLabel setFont:FontFrom(font)];
    }
    if (color) {
        [btn setTitleColor:ColorFrom(color) forState:UIControlStateNormal];
    }
    return btn;
}

@end
