//
//  NSString+Utils.m
//  FFStory
//
//  Created by PageZhang on 14/11/18.
//  Copyright (c) 2014年 FF. All rights reserved.
//

#import "NSString+Utils.h"
//#import "WCCategory.h"
#import "WCCategory+NS.h"

NSString *FFPlaceholderChar(void) {
    unichar objectReplacementChar = 0xFFFC;
    return [NSString stringWithCharacters:&objectReplacementChar length:1];
}

NSString *FFHighlightColorStr(NSString *string)
{
    return [string hlightedColorStr];
}

NSString *FFURLEncode(NSString *input) {
    return [input urlEncoded];
}

@implementation NSString (Utils)

- (BOOL)isMobileNumber
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSString *)removePhoneHeader
{
    return [self removeKeyTextHeader:@"+86"];
}

- (NSString *)removeKeyTextHeader:(NSString *)text
{
    NSRange range = [self rangeOfString:text];
    if (range.location != NSNotFound) {
        NSString *subText = [self substringFromIndex:(range.location + range.length)];
        return subText;
    } else {
        return self;
    }
}

+ (BOOL)isBlankString:(NSString *)string{
    
    if ([@"" isEqualToString:string]||[@"(null)"isEqualToString:string]) {
        return YES;
    }
    
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isEmptyString:(NSString *)string
{
    if (string == nil) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSString class]]) {
        if ([string isEqual:[NSNull null]] || string.length <= 0) {
            return YES;
        }
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (string.length <= 0) {
            return YES;
        }
    }
    
    return NO;
}

- (NSString *)reversedString {
    // Bridge to CFStringRef and allocate buffer.
    CFStringRef stringRef = (CFStringRef)CFBridgingRetain(self);
    NSUInteger length = CFStringGetLength(stringRef);
    UniChar *reversedCharacters = malloc(length * sizeof(UniChar));
    NSUInteger reversedCharactersIndex = 0;
    
    // Reverse string and take composed characters into account.
    NSInteger i = (length - 1);
    while (i >= 0) {
        CFRange range = CFStringGetRangeOfComposedCharactersAtIndex(stringRef, i);
        for (NSUInteger j = 0; j < range.length; j++) {
            reversedCharacters[reversedCharactersIndex] = CFStringGetCharacterAtIndex(stringRef, range.location + j);
            reversedCharactersIndex++;
        }
        i = (range.location - 1);
    }
    CFRelease(stringRef);
    
    // Bridge back to NSString.
    CFStringRef reversedStringRef = CFStringCreateWithCharacters(kCFAllocatorDefault, reversedCharacters, length);
    free(reversedCharacters);
    NSString *reversedString = CFBridgingRelease(reversedStringRef);
    return reversedString;
}

- (NSString *)whitespaceCleanedString {
    static __strong NSCharacterSet *_filterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _filterSet = [NSCharacterSet.alphanumericCharacterSet invertedSet];
    });
    return [[self componentsSeparatedByCharactersInSet:_filterSet] componentsJoinedByString:@""];
}

// Partly based on http://stackoverflow.com/a/15539686
- (NSString *)humanReadableStringFromCamelCaseString {
    NSMutableString *string = [NSMutableString string];
    
    NSInteger i = 0;
    while (i < [self length]) {
        NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:i];
        NSString *substring = [self substringWithRange:range];
        if ([substring rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]].location != NSNotFound) {
            [string appendString:@" "];
        }
        [string appendString:substring];
        i += range.length;
    }
    return [string capitalizedString];
}

- (NSString *)stringByReplacingCharactersInString:(NSString *)target withString:(NSString *)replacement {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:target];
    NSArray *components = [self componentsSeparatedByCharactersInSet:set];
    return [components componentsJoinedByString:replacement];
}

- (NSString *)stringByReplacingFirstOccurrenceOfString:(NSString *)target withString:(NSString *)replacement {
    BOOL foundTarget = NO;
    // scanner are not case sensitive by default.
    NSMutableString *mutableString = [self mutableCopy];
    NSScanner *scanner = [[NSScanner alloc] initWithString:mutableString];
    [scanner scanUpToString:target intoString:NULL];
    if (![scanner isAtEnd]) {
        NSUInteger targetLocation = [scanner scanLocation];
        [mutableString deleteCharactersInRange:NSMakeRange(targetLocation, target.length)];
        [mutableString insertString:replacement atIndex:targetLocation];
        foundTarget = YES;
    }
    return [mutableString copy];
}

- (NSString *)stringByDeleteCharactersExcludeInSet:(NSCharacterSet *)set {
    NSArray *components = [self componentsSeparatedByCharactersInSet:[set invertedSet]];
    return [components componentsJoinedByString:@""];
}
- (NSString *)stringByDeleteCharactersExcludeInString:(NSString *)target {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:target];
    return [self stringByDeleteCharactersExcludeInSet:set];
}

- (BOOL)containsSubString:(NSString *)subString
{
    if (subString) {
        if ([self rangeOfString:subString].length) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containsSubStringLowercase:(NSString *)subString
{
    if (subString) {
        return [self containsSubString:[subString lowercaseString]];
    }
    return NO;
}

- (BOOL)containsSubStringEasy:(NSString *)subString
{
    return [[self lowercaseString] containsSubStringLowercase:subString];
}

//MAKR:: 是否需要
//- (NSString *)stringByAppendingPathComponent:(NSString *)str
//{
//    return [NSString stringWithFormat:@"%@/%@", self, str];
//}

- (int)getUrlParamIntForkey:(NSString *)key
{
    NSString *string = [self getUrlParamValueForkey:key];
    if (string.length) {
        return [string intValue];
    }
    return 0;
}

- (NSInteger)getUrlParamIntegerForkey:(NSString *)key
{
    NSString *string = [self getUrlParamValueForkey:key];
    if (string.length) {
        return [string integerValue];
    }
    return 0;
}

- (BOOL)getUrlParamBoolForkey:(NSString *)key
{
    NSString *string = [self getUrlParamValueForkey:key];
    if (string.length) {
        return [string boolValue];
    }
    return NO;
}

- (NSString *)getValueForKey:(NSString *)key withTag:(NSString *)tag
{
    if ([self rangeOfString:tag].length) {
        NSArray *array = [self componentsSeparatedByString:@" "];
        NSString *string = nil;
        for (NSString *str in array) {
            if ([str rangeOfString:tag].length) {
                string = str;
                break;
            }
        }
        if (string) {
            return [string getUrlParamValueForkey:key];
        }
    }
    return nil;
}

+ (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText
{
    if (findText == nil && [findText isEqualToString:@""]) {
        return nil;
    }
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSString *string1 = [text stringByAppendingString:findText];
    NSString *temp;
    for (int i = 0; i < text.length; i ++) {
        temp = [string1 substringWithRange:NSMakeRange(i, findText.length)];
        //忽略大小写
        BOOL result = [temp caseInsensitiveCompare:findText] == NSOrderedSame;
        if (result) {
            NSRange range = {i,findText.length};
            [rangeArray addObject:[NSValue valueWithRange:range]];
        }
    }
    return rangeArray;
}

+ (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    NSInteger hour = floor(totalSeconds / (60 * 60));
    NSInteger minutes = floor(totalSeconds / 60 % 60);
    NSInteger sec = floor(totalSeconds % 60);

    NSMutableString *string = [NSMutableString string];
    if (hour > 0) {
        [string appendFormat:@"%zd小时", hour];
    }
    if (minutes > 0 || sec > 0) {
        if (sec > 0) {
            [string appendFormat:@"%zd分", minutes];
        } else {
            [string appendFormat:@"%zd分钟", minutes];
        }
    }
    if (sec > 0) {
        [string appendFormat:@"%zd秒", sec];
    }
    return string;
}
@end


@implementation NSString (Compare)

// NSNumber对象直接使用自己的compare:方法就可以了
- (NSComparisonResult)numberCompare:(NSString *)string {
    long long preview = [self longLongValue];
    long long compare = [string longLongValue];
    if (preview > compare) {
        return NSOrderedDescending;
    } else if (preview == compare) {
        return NSOrderedSame;
    } else {
        return NSOrderedAscending;
    }
}

- (NSComparisonResult)lengthCompare:(NSString *)string {
    if (self.length > string.length) {
        return NSOrderedDescending;
    } else if (self.length == string.length) {
        return NSOrderedSame;
    } else {
        return NSOrderedAscending;
    }
}

- (NSComparisonResult)reverseCompare:(NSString *)string {
    return -1 * [self caseInsensitiveCompare:string];
}
- (NSComparisonResult)reverseNumberCompare:(NSString *)string {
    return -1 * [self numberCompare:string];
}
- (NSComparisonResult)reverseLengthCompare:(NSString *)string {
    return -1 * [self lengthCompare:string];
}

@end

@implementation NSString (URL)

- (NSString *)urlEncoded {
    CFStringRef cfUrlEncodedString = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                             (__bridge CFStringRef)self,NULL,
                                                                             (CFStringRef)@"+!*’();:@&=$,/?%#[]",
                                                                             kCFStringEncodingUTF8);
    
    NSString *urlEncoded = [NSString stringWithString:(__bridge NSString *)cfUrlEncodedString];
    CFRelease(cfUrlEncodedString);
    return urlEncoded;
}

- (NSString *)getUrlQueryString {
    NSString *str = nil;
    NSRange start = [self rangeOfString:@"?"];
    if (start.location != NSNotFound) {
        str = [self substringFromIndex:start.location+start.length-1];
    }
    return str;
}

- (NSString *)getUrlParamValueForkey:(NSString *)key {
    NSString *str = nil;
    NSString *params = [self getUrlQueryString]; // 返回的值包含“?”
    // 更精确的查找，为避免查找expires_in的时候返回的是r2_expires_in的值
    NSString *key1 = [NSString stringWithFormat:@"?%@=", key];
    NSRange start = [params rangeOfString:key1];
    if (start.location == NSNotFound) {
        key1 = [NSString stringWithFormat:@"&%@=", key];
        start = [params rangeOfString:key1];
    }
    if (start.location != NSNotFound) {
        NSRange end = [[params substringFromIndex:start.location+start.length] rangeOfString:@"&"];
        NSUInteger offset = start.location+start.length;
        str = end.location == NSNotFound ? [params substringFromIndex:offset] : [params substringWithRange:NSMakeRange(offset, end.location)];
        str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    return str;
}

- (NSString *)setUrlParamsValue:(NSString *)value forKey:(NSString *)key
{
    NSString *oldValue = [self getUrlParamValueForkey:key];
    if (oldValue) {
        NSString *oldParams = [NSString stringWithFormat:@"%@=%@", key, oldValue];
        NSString *params = [NSString stringWithFormat:@"%@=%@", key, value];
        if (![oldParams isEqualToString:params]) {
            return [self stringByReplacingOccurrencesOfString:oldParams withString:params];
        }
    } else {
        if ([self rangeOfString:@"?"].length<=0) {
            return [self stringByAppendingString:[NSString stringWithFormat:@"?%@=%@", key, value]];
        } else {
            return [self stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, value]];
        }
    }
    return self;
}

- (NSURL *)serializeURLWithParams:(NSDictionary *)params {
    return [self serializeURLWithParams:params httpMethod:@"GET"];
}

- (NSURL *)serializeURLWithParams:(NSDictionary *)params httpMethod:(NSString *)httpMethod {
    
    NSURL* parsedURL = [NSURL URLWithString:self];
    if (params==nil || params.count <= 0) {
        return parsedURL;
    }
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator]) {
        id obj = [params valueForKey:key];
        if (([obj isKindOfClass:[UIImage class]])
            ||([obj isKindOfClass:[NSData class]])) {
            NSAssert(![httpMethod isEqualToString:@"GET"], @"can not use GET to upload a file");
            continue;
        } else if ([obj isKindOfClass:NSNumber.class]) {
            obj = [obj stringValue];
        }
        
        if ([obj isKindOfClass:NSArray.class]) {
            for (id subObj in (NSArray *)obj) {
                [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [subObj urlEncoded]]];
            }
        } else {
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [obj urlEncoded]]];
        }
    }
    
    if (pairs.count) {
        NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
        NSString* query = [pairs componentsJoinedByString:@"&"];
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query]];
    } else {
        return parsedURL;
    }
}

////MARK: - attributedString
//// <font color='gray'>意犹未尽？</font><font color='#4f91f3'>超值车品独家底价，去看看吧！</font>
//- (NSMutableAttributedString *)HTMLAttributedString
//{
//    if ([self rangeOfString:@"</font>"].length > 0) {
//        NSMutableAttributedString *attString = nil;
//        
//        NSRange headerRange = [self rangeOfString:@"<font"];
//        if (headerRange.location > 0) {
//            attString = [[NSMutableAttributedString alloc] initWithString:[self substringToIndex:headerRange.location]];
//        } else {
//            attString = [[NSMutableAttributedString alloc] init];
//        }
//        
//        NSArray *componentsArray = [[self substringFromIndex:headerRange.location] componentsSeparatedByString:@"</font>"];
//        
//        for (NSString *comString in componentsArray) {
//            if (comString.length > 0 && [comString hasPrefix:@"<font"]) {
//                NSRange range = [comString rangeOfString:@">"];
//                NSString *itemString = [comString substringFromIndex:range.location + range.length];
//                
//                NSString *fontString = [[comString substringToIndex:range.location] stringByReplacingOccurrencesOfString:@" " withString:@""];
//                NSString *colorString = nil;
//                if ([fontString rangeOfString:@"color="].length > 0) {
//                    NSRange colorRange = [fontString rangeOfString:@"color="];
//                    NSString *tmpColorString = [fontString substringFromIndex:colorRange.location + colorRange.length];
//                    if (tmpColorString.length > 0) {
//                        colorString = [tmpColorString stringByReplacingOccurrencesOfString:[tmpColorString substringToIndex:1] withString:@""];
//                    }
//                }
//                NSAttributedString *tempAttString = nil;
//                if (colorString.length > 0 && [colorString hasPrefix:@"#"]) {
//                    tempAttString = [[NSAttributedString alloc] initWithString:itemString attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:colorString]}];
//                } else {
//                    tempAttString = [[NSAttributedString alloc] initWithString:itemString attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"313131"]}];
//                }
//                [attString appendAttributedString:tempAttString];
//            }
//        }
//        return attString;
//    } else {
//        return [[NSMutableAttributedString alloc] initWithString:self];
//    }
//}

@end

@implementation NSString (ASCII)

- (NSUInteger)asciiLength {
    NSUInteger length = 0;
    for (int i = 0; i < self.length; i++) {
        unichar c = [self characterAtIndex:i];
        length += isascii(c) ? 1 : 2;
    }
    return length;
}

- (NSUInteger)unicodeLength {
    NSUInteger asciiLength = [self asciiLength];
    NSUInteger unicodeLength = asciiLength / 2;
    if(asciiLength % 2) {
        unicodeLength++;
    }
    return unicodeLength;
}

- (NSString *)substringFromAsciiIndex:(NSUInteger)from {
    int index = 0;
    NSUInteger length = 0;
    for (int i = 0; i < self.length; i++) {
        unichar c = [self characterAtIndex:i];
        length += isascii(c) ? 1 : 2;
        
        if (length < from) {
            index = i+1;
        } else {
            break;
        }
    }
    return [self substringFromIndex:index];
}

- (NSString *)substringToAsciiIndex:(NSUInteger)to {
    int index = 0;
    NSUInteger length = 0;
    for (int i = 0; i < self.length; i++) {
        unichar c = [self characterAtIndex:i];
        length += isascii(c) ? 1 : 2;
        
        if (length <= to) {
            index = i + 1;
        } else {
            break;
        }
    }
    return index > 0 ? [self substringToIndex:index] : self;
}

@end

@implementation NSString (format)

//距离 m, km
+ (NSString *)formatDistance:(CGFloat)distance
{
    return [self formatDistance:distance chinese:NO];
}

//距离 米, 千米
+ (NSString *)formatDistanceChinese:(CGFloat)distance
{
    return [self formatDistance:distance chinese:YES];
}

+ (NSString *)formatDistance:(CGFloat)distance chinese:(BOOL)chinese
{
    if (distance > 999 * 1000) {
        return (chinese ? @"未知" : @"unknow");
    } else {
        if (distance < 1000) {
            NSString *unit = (chinese ? @"米" : @"m");
            return [NSString stringWithFormat:@"%.0f%@", distance, unit];
        } else {
            NSString *unit = (chinese ? @"千米" : @"km");
            if (distance < 10000) {
                return [NSString stringWithFormat:@"%.1f%@", distance/1000.0f, unit];
            } else {
                return [NSString stringWithFormat:@"%.0f%@", distance/1000.0f, unit];
            }
        }
    }
}

//数目 - k, w, 10w
+ (NSString *)formatNum1K:(NSInteger)num
{
    return [self formatNum:num from:1000 chinese:NO];
}

+ (NSString *)formatNum1W:(NSInteger)num
{
    return [self formatNum:num from:10000 chinese:NO];
}

+ (NSString *)formatNum10W:(NSInteger)num
{
    return [self formatNum:num from:100000 chinese:NO];
}

//数目 - 千， 万， 10万
+ (NSString *)formatNum1KChinese:(NSInteger)num
{
    return [self formatNum:num from:1000 chinese:YES];
}

+ (NSString *)formatNum1WChinese:(NSInteger)num
{
    return [self formatNum:num from:10000 chinese:YES];
}

+ (NSString *)formatNum10WChinese:(NSInteger)num
{
    return [self formatNum:num from:100000 chinese:YES];
}

+ (NSString *)formatNum:(NSInteger)num from:(NSInteger)from chinese:(NSInteger)chinese
{
    if (num < from) {
        return [NSString stringWithFormat:@"%zd", num];
    } else {
        NSString *unit = nil;
        if (from < 2000) {
            unit = (chinese ? @"千" : @"k");
        } else {
            unit = (chinese ? @"万" : @"w");
        }
        
        CGFloat value = num * 1.f / from;
        //因为去一位小数，会根据第二位的小数 四舍五入
        if (((NSInteger)(value * 100)) % 100 < 5) {
            return [NSString stringWithFormat:@"%.0f%@", value, unit];
        } else {
            return [NSString stringWithFormat:@"%.1f%@", value, unit];
        }
    }
}

@end

@implementation NSString (Money)

+ (NSString *)translateMoneyToString:(CGFloat)money
{
    if (ceil(money)==floor(money)) {
        return [NSString stringWithFormat:@"%.0f",money];
    } else {
        return [NSString stringWithFormat:@"%.2f",money];
    }
}

+ (NSString *)stringDecimalStyleFromNumber:(CGFloat)number
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [formatter stringFromNumber:[NSNumber numberWithFloat:number]];
}

+ (NSString *)translateMoneyToMoneyString:(CGFloat)money
{
    NSString *moneyStr = [self translateMoneyCommaString:money];
    NSString *string = [NSString stringWithFormat:@"%.2f",money];
    NSArray *array = [string componentsSeparatedByString:@"."];
    if (array.count==2) {
        moneyStr = [NSString stringWithFormat:@"%@.%@", moneyStr, [array lastObject]];
    }
    return moneyStr;
}

+ (NSString *)translateMoneyCommaString:(CGFloat)money
{
    NSMutableString *moneyStr = [NSMutableString stringWithFormat:@"%.0f", money];
    NSInteger n = moneyStr.length;
    while (n>3) {
        n -= 3;
        [moneyStr insertString:@"," atIndex:n];
    }
    return moneyStr;
}

+ (NSString *)translateMoneyToMoneyIntString:(NSInteger)money
{
    NSMutableString *moneyStr = [NSMutableString stringWithFormat:@"%ld",money];
    NSInteger n = moneyStr.length;
    while (n>3) {
        n -= 3;
        [moneyStr insertString:@"," atIndex:n];
    }
    return moneyStr;
}

@end

@implementation NSString (fixios7)

// iOS 7以上用这个，不用之前的BPNSstring+fixios7
+ (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size fixString:(NSString *)string {
    return [string sizeWithFont:font constrainedToSize:size];
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    if (iOS(7)) {
        CGSize result = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil].size;
        result.height = ceilf(result.height);
        result.width = ceilf(result.width);
        return result;
    } else {
        CGSize result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        result.height = ceilf(result.height);
        result.width = ceilf(result.width);
        return result;
    }
}

- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font
{
    if (iOS(7)) {
        [self drawInRect:rect withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]];
        return [self sizeWithFont:font constrainedToSize:rect.size];
    } else {
        return [self drawInRect:rect withFont:font lineBreakMode:NSLineBreakByWordWrapping];
    }
}

- (CGSize)sizeWithWidth:(CGFloat)width withFont:(UIFont *)font lineSpace:(CGFloat)lineSpace {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    
    NSDictionary *attributes = @{ NSFontAttributeName:font,
                                  NSParagraphStyleAttributeName:paragraphStyle.copy
                                  };
    
    CGSize measureSize = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return measureSize;
}

@end

@implementation NSString (Chinese)

+ (NSString *)singleChineseStringFromNum:(NSInteger)num
{
    NSString *string = @"零一二三四五六七八九";
    return [string substringWithRange:NSMakeRange((num%10), 1)];
}

+ (NSString *)chineseStringFromTwoNum:(NSInteger)num
{
    if (num < 100) {
        if (num % 10 == 0 && num > 0) {
            if (num == 10) {
                return @"十";
            } else {
                return [NSString stringWithFormat:@"%@十",[self singleChineseStringFromNum:num / 10]];
            }
        }
        if (num > 20) {
            return [NSString stringWithFormat:@"%@十%@",[self singleChineseStringFromNum:num / 10], [self singleChineseStringFromNum:num % 10]];
        } else if (num > 10) {
            return [NSString stringWithFormat:@"十%@",[self singleChineseStringFromNum:num % 10]];
        } else {
            return [self singleChineseStringFromNum:num];
        }
    }
    return [NSString stringWithFormat:@"%ld", num];
}

@end

@implementation NSString (ColorHex)

- (NSString *)hlightedColorStr
{
    NSString *hexString = [self copy];
    if (![hexString hasPrefix:@"#"]) {
        hexString = [NSString stringWithFormat:@"#%@", hexString];
    }
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#"
                                                     withString:@"0x"];
    uint hexValue;
    if ([[NSScanner scannerWithString:hexString] scanHexInt:&hexValue]) {
        [self checkHexValue:&hexValue subtractWithPowerIndex:1];
        [self checkHexValue:&hexValue subtractWithPowerIndex:3];
        [self checkHexValue:&hexValue subtractWithPowerIndex:5];
        NSString *result = [NSString stringWithFormat:@"%x",hexValue];
        return result;
    }
    return hexString;
}

- (void)checkHexValue:(uint *)hexValue subtractWithPowerIndex:(int)index
{
    if  ((*hexValue % (int)powf(16, index + 1)) > powf(16, index)) {
        *hexValue -= powf(16, index);
    }
}

@end


@implementation NSString (Time)

+ (NSString *)minAndSecFromTime:(NSInteger)time
{
    NSInteger min = time / 60;
    NSInteger sec = time % 60;
    return [NSString stringWithFormat:@"%02zd:%02zd", min, sec];
}

+ (NSString *)hourMinAndSecFromTime:(NSInteger)time
{
    NSInteger hour = time / 3600;
    NSInteger min = time % 3600 / 60;
    NSInteger sec = time % 60;
    return [NSString stringWithFormat:@"%02zd:%02zd:%02zd", hour, min, sec];
}

+ (NSString *)hourMinAndSecAutoFromTime:(NSInteger)time
{
    NSInteger hour = time / 3600;
    if (hour > 0) {
        return [self hourMinAndSecFromTime:time];
    } else {
        return [self minAndSecFromTime:time];
    }
}

@end
