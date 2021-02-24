//
//  WCQuickUI.h
//  WCCategory
//
//  Created by cheng on 2020/3/18.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define RECT(x, y, w, h)             CGRectMake(x, y, w, h)

#define UICREATE(uiClass, x, y, w, h, AA, toView) \
UICREATEView(uiClass, x, y, w, h, AA, nil, toView)

#define UICREATEView(uiClass, x, y, w, h, AA, _bgColor, toView) \
[uiClass Create:RECT(x, y, w, h) autoResizing:AA bgColor:_bgColor addToView:toView];

#define UICREATELabel(uiClass, x, y, w, h, AA, _text, _font, _color, toView) \
UICREATELabel2(uiClass, x, y, w, h, AA, TTLeft, _text, _font, _color, toView)

#define UICREATELabel2(uiClass, x, y, w, h, AA, TT, _text, _font, _color, toView) \
[uiClass Create:RECT(x, y, w, h) autoResizing:AA text:_text alignment:TT font:_font color:_color addToView:toView];

#define UICREATEImage(uiClass, x, y, w, h, AA, CC, _image, toView) \
[uiClass Create:RECT(x, y, w, h) autoResizing:AA contentMode:CC image:_image addToView:toView];

#define UICREATEControl(uiClass, x, y, w, h, AA, _target, _action, toView) \
[uiClass Create:RECT(x, y, w, h) autoResizing:AA target:_target action:_action addToView:toView];

#define UICREATEBtnImg(uiClass, x, y, w, h, AA, _image, _target, _action, toView) \
[uiClass Create:RECT(x, y, w, h) autoResizing:AA image:_image target:_target action:_action addToView:toView];

#define UICREATEBtn(uiClass, x, y, w, h, AA, _title, _font, _color, _target, _action, toView) \
[uiClass Create:RECT(x, y, w, h) autoResizing:AA title:_title font:_font color:_color target:_target action:_action addToView:toView];

//======================

#define UICREATETo(view, uiClass, x, y, w, h, AA, toView) \
view = UICREATE(uiClass, x, y, w, h, AA, toView)

#define UICREATEViewTo(view, uiClass, x, y, w, h, AA, bgColor, toView) \
view = UICREATEView(uiClass, x, y, w, h, AA, bgColor, toView)

#define UICREATELabelTo(label, uiClass, x, y, w, h, AA, text, font, color, toView) \
label = UICREATELabel(uiClass, x, y, w, h, AA, text, font, color, toView)

#define UICREATELabel2To(label, uiClass, x, y, w, h, AA, TT, text, font, color, toView) \
label = UICREATELabel2(uiClass, x, y, w, h, AA, TT, text, font, color, toView)

#define UICREATEImageTo(imageV, uiClass, x, y, w, h, AA, CC, image, toView) \
imageV = UICREATEImage(uiClass, x, y, w, h, AA, CC, image, toView)

#define UICREATEControlTo(control, uiClass, x, y, w, h, AA, target, action, toView) \
control = UICREATEControl(uiClass, x, y, w, h, AA, target, action, toView)

#define UICREATEBtnImgTo(btn, uiClass, x, y, w, h, AA, image, target, action, toView) \
btn = UICREATEBtnImg(uiClass, x, y, w, h, AA, image, target, action, toView)

#define UICREATEBtnTo(btn, uiClass, x, y, w, h, AA, title, font, color, target, action, toView) \
btn = UICREATEBtn(uiClass, x, y, w, h, AA, title, font, color, target, action, toView)


typedef NS_ENUM(NSUInteger, UIAutoResizingType) {
    AANone = UIViewAutoresizingNone,
    AAL = UIViewAutoresizingFlexibleLeftMargin,
    AAW = UIViewAutoresizingFlexibleWidth,
    AAR = UIViewAutoresizingFlexibleRightMargin,
    AAT = UIViewAutoresizingFlexibleTopMargin,
    AAH = UIViewAutoresizingFlexibleHeight,
    AAB = UIViewAutoresizingFlexibleBottomMargin,
    AAWH = AAW | AAH,
    AALR = AAL | AAR,
    AATB = AAT | AAB,
    AALRTB = AAL | AAR | AAT | AAB,
    AAWT = AAW | AAT,
};

typedef NS_ENUM(NSUInteger, NSAlignmentType) {
    TTLeft = NSTextAlignmentLeft,
    TTCenter = NSTextAlignmentCenter,
    TTRight = NSTextAlignmentRight,
    TTJustified = NSTextAlignmentJustified,
    TTNatural = NSTextAlignmentNatural,
};

typedef NS_ENUM(NSUInteger, UIContetntModeType) {
    CCCenter = UIViewContentModeCenter,
    CCFill = UIViewContentModeScaleToFill,
    CCAFit = UIViewContentModeScaleAspectFit,
    CCAFill = UIViewContentModeScaleAspectFill,
};

@interface UIView (Quick)

+ (id)Create:(CGRect)frame autoResizing:(NSUInteger)resizing bgColor:(id)bgColor addToView:(id)view;

@end

@interface UILabel (Quick)

+ (id)Create:(CGRect)frame autoResizing:(NSUInteger)resizing text:(NSString *)text alignment:(NSUInteger)alignment font:(id)font color:(id)color addToView:(id)view;

@end

@interface UIImageView (Quick)

+ (id)Create:(CGRect)frame autoResizing:(NSUInteger)resizing contentMode:(NSUInteger)mode image:(id)image addToView:(id)view;

@end

@interface UIControl (Quick)

+ (id)Create:(CGRect)frame autoResizing:(NSUInteger)resizing target:(id)target action:(SEL)action addToView:(id)view;

@end

@interface UIButton (Quick)

+ (id)Create:(CGRect)frame autoResizing:(NSUInteger)resizing image:(id)image target:(id)target action:(SEL)action addToView:(id)view;

+ (id)Create:(CGRect)frame autoResizing:(NSUInteger)resizing title:(NSString *)title font:(id)font color:(id)color target:(id)target action:(SEL)action addToView:(id)view;

@end
