//
//  NSString+Utils.h
//  FFStory
//
//  Created by PageZhang on 14/11/18.
//  Copyright (c) 2014年 FF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSString+md5.h"

// 占位符
extern NSString *FFPlaceholderChar(void);
extern NSString *FFHighlightColorStr(NSString *string);

extern NSString *FFURLEncode(NSString *input);

@interface NSString (Utils)
- (BOOL)isMobileNumber;
- (NSString *)removePhoneHeader;
- (NSString *)removeKeyTextHeader:(NSString *)text;
//判断是否为空 超级教练
+ (BOOL)isBlankString:(NSString *)string;

+ (BOOL)isEmptyString:(NSString *)string;
// 反转字符串
- (NSString *)reversedString;
// 去掉字符串中的空白字符
- (NSString *)whitespaceCleanedString;
// "someThing" to "Some Thing"
- (NSString *)humanReadableStringFromCamelCaseString;

// 替换目标字符
- (NSString *)stringByReplacingCharactersInString:(NSString *)target withString:(NSString *)replacement;
- (NSString *)stringByReplacingFirstOccurrenceOfString:(NSString *)target withString:(NSString *)replacement;

// 保留目标字符(可用于去除电话号码中的冗余字符)
- (NSString *)stringByDeleteCharactersExcludeInSet:(NSCharacterSet *)set;
- (NSString *)stringByDeleteCharactersExcludeInString:(NSString *)target;

- (BOOL)containsSubString:(NSString *)subString;//严格匹配大小写
- (BOOL)containsSubStringLowercase:(NSString *)subString;//substring 小写
- (BOOL)containsSubStringEasy:(NSString *)subString;//忽略大小写

- (int)getUrlParamIntForkey:(NSString *)key;
- (NSInteger)getUrlParamIntegerForkey:(NSString *)key;
- (BOOL)getUrlParamBoolForkey:(NSString *)key;

//以空格分隔，然后包含tag的字符串中，key 对应的value
- (NSString *)getValueForKey:(NSString *)key withTag:(NSString *)tag;

/**
 *  返回重复字符的location
 *
 *  @param text     初始化的字符串
 *  @param findText 查找的字符
 *
 *  @return 返回重复字符的location
 */

+ (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText;

+ (NSString *)timeFormatted:(NSInteger)totalSeconds;

@end


@interface NSString (Compare)

// 排序
- (NSComparisonResult)numberCompare:(NSString *)string;
- (NSComparisonResult)lengthCompare:(NSString *)string;
// 逆向排序
- (NSComparisonResult)reverseCompare:(NSString *)string;
- (NSComparisonResult)reverseNumberCompare:(NSString *)string;
- (NSComparisonResult)reverseLengthCompare:(NSString *)string;


@end

@interface NSString (URL)

- (NSString *)urlEncoded;

- (NSString *)getUrlQueryString;

- (NSString *)getUrlParamValueForkey:(NSString *)key;

/*
 key没有则添加，有则更换value
 */
- (NSString *)setUrlParamsValue:(NSString *)value forKey:(NSString *)key;

- (NSURL *)serializeURLWithParams:(NSDictionary*)params;

- (NSURL *)serializeURLWithParams:(NSDictionary *)params httpMethod:(NSString *)httpMethod;

//- (NSMutableAttributedString *)HTMLAttributedString;

@end


@interface NSString (ASCII)

// 英文算一位，中文算两位
- (NSUInteger)asciiLength;
- (NSUInteger)unicodeLength;

- (NSString *)substringFromAsciiIndex:(NSUInteger)from;
- (NSString *)substringToAsciiIndex:(NSUInteger)to;

@end

@interface NSString (format)

//距离 m, km， distance 为米单位
+ (NSString *)formatDistance:(CGFloat)distance;
//距离 米, 千米， distance 为米单位
+ (NSString *)formatDistanceChinese:(CGFloat)distance;

//数目 - k, w, 10w
+ (NSString *)formatNum1K:(NSInteger)num;
+ (NSString *)formatNum1W:(NSInteger)num;
+ (NSString *)formatNum10W:(NSInteger)num;

//数目 - 千， 万， 10万
+ (NSString *)formatNum1KChinese:(NSInteger)num;
+ (NSString *)formatNum1WChinese:(NSInteger)num;
+ (NSString *)formatNum10WChinese:(NSInteger)num;

@end

@interface NSString (Money)

+ (NSString *)translateMoneyToString:(CGFloat)money;//两位小数，若小数为零 则不显示小数
+ (NSString *)translateMoneyToMoneyString:(CGFloat)money;//每三位 用逗号隔开(带两位小数)
+ (NSString *)translateMoneyCommaString:(CGFloat)money;//每三位 用逗号隔开
+ (NSString *)translateMoneyToMoneyIntString:(NSInteger)money;//每三位 用逗号隔开

//同 translateMoneyToMoneyString:(CGFloat)money
+ (NSString *)stringDecimalStyleFromNumber:(CGFloat)number;

@end

@interface NSString (fixios7)

- (CGSize)sizeWithFont:(UIFont *)font;
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

+ (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size fixString:(NSString *)string;
- (CGSize)sizeWithWidth:(CGFloat)width withFont:(UIFont *)font lineSpace:(CGFloat)lineSpace;
- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font;

@end

@interface NSString (Chinese)

+ (NSString *)singleChineseStringFromNum:(NSInteger)num;//个位数
+ (NSString *)chineseStringFromTwoNum:(NSInteger)num;//100以下 两位数

@end

@interface NSString (ColorHex)

- (NSString *)hlightedColorStr;

@end

@interface NSString (Time)

//分：秒，如 01：09， 一分零九秒， 90：10，九十分十秒，不会转成小时
+ (NSString *)minAndSecFromTime:(NSInteger)time;
//时：分：秒，如 00：01：09 或 01：30：10
+ (NSString *)hourMinAndSecFromTime:(NSInteger)time;
// 显示时间 时：分：秒， 当小于一小时时，显示  分：秒
// 适合使用在列表展示时，如果倒计时从1小时到59分会跳动，可以使用hourMinAndSec 固定格式
+ (NSString *)hourMinAndSecAutoFromTime:(NSInteger)time;

@end
