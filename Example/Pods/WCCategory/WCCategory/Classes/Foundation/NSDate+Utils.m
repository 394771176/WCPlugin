//
//  NSDate+Utils.m
//  FFStory
//
//  Created by PageZhang on 14/11/17.
//  Copyright (c) 2014年 FF. All rights reserved.
//

#import "NSDate+Utils.h"
//#import "WCCategory.h"
#import "WCCategory+NS.h"

#include <sys/time.h>
NSTimeInterval WCTimeIntervalWithSecondsSince1970(void) {
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return tv.tv_sec;
}

@implementation NSDate (Utils)

+ (NSCalendar *)sharedCalendar {
    static __strong NSCalendar *_calendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _calendar = [NSCalendar currentCalendar];
    });
    return _calendar;
}
+ (NSDateFormatter *)sharedDateFormatter {
    static __strong NSDateFormatter *_formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _formatter = [[NSDateFormatter alloc] init];
    });
    return _formatter;
}

+ (NSDate *)datePlus:(NSTimeInterval)interval {
    return [[NSDate date] dateByAddingTimeInterval:interval];
}
+ (NSDate *)dateMinus:(NSTimeInterval)interval {
    return [[NSDate date] dateByAddingTimeInterval:-interval];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - format
+ (NSDateFormatter *)shortTimeFormatter {
    NSDateFormatter *formatter = [self sharedDateFormatter];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    return formatter;
}
+ (NSDateFormatter *)shortDateFormatter {
    NSDateFormatter *formatter = [self sharedDateFormatter];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    return formatter;
}

- (NSInteger)weekDay
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* day = [cal components:NSCalendarUnitWeekday
                                   fromDate:self];
    return day.weekday;
}

- (NSString *)weekDayStr
{
    //实际上 day 为 1 - 7， 但是考虑到 方便前后顺延， 用day %7 来处理
    NSInteger day = [self weekDay] % 7;
    static NSArray *weeks = nil;
    if (!weeks) weeks = @[@"六", @"日", @"一", @"二", @"三", @"四", @"五"];
    return weeks[day];
}

- (NSString *)weekDayString
{
    return [@"周" stringByAppendingString:[self weekDayStr]];
}

- (NSString *)stringValue:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [NSDate sharedDateFormatter];
    dateFormatter.dateFormat = dateFormat;
    return [dateFormatter stringFromDate:self];
}

- (NSString *)stringFormatterDay
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* day = [cal components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear
                                   fromDate:self];
    NSDateComponents* today = [cal components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear
                                     fromDate:[NSDate date]];
    NSDateComponents* yesterday = [cal components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear
                                         fromDate:[[NSDate date] dateByAddingTimeInterval:-(24*60*60.f)]];
    
    if (day.day == today.day && day.month == today.month && day.year == today.year) {
        return @"今天";
    } else if (day.day == yesterday.day && day.month == yesterday.month
               && day.year == yesterday.year) {
        return @"昨天";
    } else {
        return [self stringValue:yyyy_Md];
    }
}

- (NSString *)stringFormatterForAutoYear:(NSString *)dateFormat
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* day = [cal components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear
                                   fromDate:self];
    NSDateComponents* today = [cal components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear
                                     fromDate:[NSDate date]];
    if (day.year == today.year) {
        NSRange range = [dateFormat rangeOfString:@"M"];
        if (range.length) {
            dateFormat = [dateFormat substringFromIndex:range.location];
        }
        return [self stringValue:dateFormat];
    } else {
        return [self stringValue:dateFormat];
    }
}

- (NSInteger)getDifferenceByNowDate {
    //获得当前时间
    NSDate *now = [NSDate date];
    //实例化一个NSDateFormatter对象
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:self  toDate:now  options:0];
    return [comps day];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - convert
+ (NSInteger)nowValue:(NSCalendarUnit)unit {
    return [[NSDate date] thenValue:unit];
}
- (NSInteger)thenValue:(NSCalendarUnit)unit {
    NSDateComponents *comps = [[self.class sharedCalendar] components:unit fromDate:self];
    switch (unit) {
        case NSCalendarUnitYear:   return [comps year];
        case NSCalendarUnitMonth:  return [comps month];
        case NSCalendarUnitDay:    return [comps day];
        case NSCalendarUnitHour:   return [comps hour];
        case NSCalendarUnitMinute: return [comps minute];
        case NSCalendarUnitSecond: return [comps second];
        default: return 0;
    }
}

- (NSInteger)valueToNow:(NSCalendarUnit)unit {
    if (unit == NSCalendarUnitDay) {
        // 需要先把时间转成年月日格式，才能得到准确的天数
        NSDateComponents *comps1 = [[self.class sharedCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
        NSDate *date1 = [[self.class sharedCalendar] dateFromComponents:comps1];
        NSDateComponents *comps2 = [[NSDate sharedCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
        NSDate *date2 = [[NSDate sharedCalendar] dateFromComponents:comps2];
        NSDateComponents *comps3 = [[self.class sharedCalendar] components:NSCalendarUnitDay fromDate:date1 toDate:date2 options:0];
        return [comps3 day];
    } else {
        NSDateComponents *comps = [[self.class sharedCalendar] components:unit fromDate:self toDate:[NSDate date] options:0];
        switch (unit) {
            case NSCalendarUnitYear:   return [comps year];
            case NSCalendarUnitMonth:  return [comps month];
            case NSCalendarUnitHour:   return [comps hour];
            case NSCalendarUnitMinute: return [comps minute];
            case NSCalendarUnitSecond: return [comps second];
            default: return 0;
        }
    }
}

+ (NSString *)todayString
{
    static NSString *todayStr = nil;
    if (!todayStr) {
        todayStr = [[NSDate date] stringValue:yyyyMMdd];
    }
    return todayStr;
}

+ (NSDate *)dateFromDateStr:(NSString *)dateStr formatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter dateFromString:dateStr];
}

+ (NSTimeInterval)timeIntervalFromDateStr:(NSString *)dateStr formatter:(NSString *)formatter
{
    NSDate *date = [self dateFromDateStr:dateStr formatter:formatter];
    NSTimeInterval times = [date timeIntervalSince1970];
    return times;
}

+ (NSDateComponents *)dateComponentsFromDateString:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@"-"];
    if (array.count==3) {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.year = [[array safeObjectAtIndex:0] integerValue];
        components.month = [[array safeObjectAtIndex:1] integerValue];
        components.day = [[array safeObjectAtIndex:2] integerValue];
        return components;
    }
    return nil;
}

+ (NSDate *)dateFromComponents:(NSDateComponents *)components
{
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

+(NSString *)timeStampToString:(NSTimeInterval)interval
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString* string = [dateFormat stringFromDate:confromTimesp];
    
    return string;
}
- (NSInteger)year
{
    return [self components].year;
}

- (NSInteger)month
{
    return [self components].month;
}

- (NSInteger)day
{
    return [self components].day;
}

- (NSInteger)hour
{
    return [self components].hour;
}

- (NSInteger)minute
{
    return [self components].minute;
}

- (NSInteger)second
{
    return [self components].second;
}

- (NSDateComponents *)components
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    return components;
}

- (NSDateComponents *)componentsYMD
{
    return [self components];
}

- (NSDateComponents *)componentsYMDHMS
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear |
                                                                            NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond
                                                                   fromDate:self];
    return components;
}

- (NSDate *)setHour:(NSInteger)hour min:(NSInteger)min second:(NSInteger)second
{
    NSDateComponents *components = [self componentsYMDHMS];
    [components setHour:hour];
    [components setMinute:min];
    [components setSecond:second];
    
    return [NSDate dateFromComponents:components];
}

- (BOOL)isSameDayDate:(NSDate *)date
{
    BOOL same = NO;
    if (self.year == date.year && self.month == date.month && self.day == date.day) {
        same = YES;
    }
    
    return same;
}

+ (BOOL)isBeginOfMonth
{
    NSDate *date = [NSDate date];
    NSInteger day =  [date componentsYMD].day;
    if (day == 1) {
        return YES;
    }
    return NO;
    
}
- (NSString *)dayString
{
    return [self stringValue:yyyyMMdd];
    /*
     description 是 标准时区 的时间描述，
     北京时间同一天，但description 有可能不是不同一天
     北京时间      =》  标准时间
     4月6号 7：00  =》 4月5号 23：00
     4月6号 16：00 =》 4月6号 8：00
     */
//    NSString *str1 = [self.description componentsSeparatedByString:@" "].firstObject;
//    return str1;
}

@end


@implementation NSDate (Dict)

+ (NSDate *)dateFromGMTString:(NSString *)str
{
    return [self dateFromDateStr:str formatter:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
}

+ (NSDate *)dateFromDict:(NSDictionary *)dict forKey:(NSString *)key
{
    if (dict&&key&&[dict isKindOfClass:[NSDictionary class]]) {
        NSString *string = [dict stringForKey:key];
        if (string.length) {
            if ([string rangeOfString:@"-"].length) {
                return [self dateFromGMTString:string];
            } else {
                if ([dict doubleForKey:key]>0.f) {
                    return [self dateWithTimeIntervalSince1970:[dict doubleForKey:key]];
                }
            }
        }
    }
    return nil;
}

@end

@implementation NSDate (Compare)

+ (BOOL)NoLaterToday:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@"-"];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSArray *today = @[@(components.year), @(components.month), @(components.day)];
    if (array.count == today.count) {
        for (NSInteger i=0; i<today.count; i++) {
            if ([array[i] integerValue] == [today[i] integerValue]) {
                continue;
            } else {
                return [array[i] integerValue] < [today[i] integerValue];
            }
        }
        //同一天
        return YES;
    }
    return NO;
}

+ (BOOL)NoEarlierToday:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@"-"];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSArray *today = @[@(components.year), @(components.month), @(components.day)];
    if (array.count == today.count) {
        for (NSInteger i=0; i<today.count; i++) {
            if ([array[i] integerValue] == [today[i] integerValue]) {
                continue;
            } else {
                return [array[i] integerValue] > [today[i] integerValue];
            }
        }
        //同一天
        return YES;
    }
    return NO;
}

+ (BOOL)todayIsValidWithBegin:(NSString *)begin andEnd:(NSString *)end
{
    return [self NoLaterToday:begin] && [self NoEarlierToday:end];
}

@end
