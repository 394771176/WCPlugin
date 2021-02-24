//
//  NSDate+Utils.h
//  FFStory
//
//  Created by PageZhang on 14/11/17.
//  Copyright (c) 2014年 FF. All rights reserved.
//

#import <Foundation/Foundation.h>

#define yyyy_Md                 @"M月d号"                // 2月3号
#define yyyy_Hmm                @"H:mm"                 // 8:03
#define yyyy_HHmm               @"HH:mm"                // 08:03
#define yyyyMMdd                @"yyyy-MM-dd"           // 2016-02-03
#define yyyyMMddHHmm            @"yyyy-MM-dd HH:mm"     // 2016-02-03 08:03
#define yyyyMMddHHmmss          @"yyyy-MM-dd HH:mm:ss"  // 2016-02-03 08:03:18
#define yyyyMMddDot             @"yyyy.MM.dd"           // 2016.02.03
#define yyyyMMddHHmmChinese     @"yyyy年MM月dd日 HH:mm"     // 2016-02-03 08:03

extern NSTimeInterval WCTimeIntervalWithSecondsSince1970(void);
/*
 常见用法：
 NSDate、CFAbsoluteTimeGetCurrent（）常用于日常时间、时间戳的表示，与服务器之间的数据交互
 其中 CFAbsoluteTimeGetCurrent() 相当于[[NSDate data] timeIntervalSinceReferenceDate];
 CACurrentMediaTime() 常用于测试代码的效率
 */

@interface NSDate (Utils)

+ (NSCalendar *)sharedCalendar;

// 系统时间表示
+ (NSDateFormatter *)shortTimeFormatter;
+ (NSDateFormatter *)shortDateFormatter;

// 转换为字符串
- (NSString *)stringValue:(NSString *)dateFormat;

// 操作指定秒数
+ (NSDate *)datePlus:(NSTimeInterval)interval;
+ (NSDate *)dateMinus:(NSTimeInterval)interval;

// 当前的年月日，小时，分钟，秒数
+ (NSInteger)nowValue:(NSCalendarUnit)unit;

// 给定时间对应的年月日
- (NSInteger)thenValue:(NSCalendarUnit)unit;

// 给定时间到当前的天数，月数，年数，小时，分钟，秒数
- (NSInteger)valueToNow:(NSCalendarUnit)unit;

//返回 昨天 今天 或1月1日
- (NSString *)stringFormatterDay;
//同一年自动忽略年份
- (NSString *)stringFormatterForAutoYear:(NSString *)dateFormat;

+ (NSString *)todayString;

//将2016-01-01 转化成date
+ (NSDate *)dateFromDateStr:(NSString *)dateStr formatter:(NSString *)formatter;

+ (NSTimeInterval)timeIntervalFromDateStr:(NSString *)dateStr formatter:(NSString *)formatter;

//string : 2017-01-01
+ (NSDateComponents *)dateComponentsFromDateString:(NSString *)string;

+ (NSDate *)dateFromComponents:(NSDateComponents *)components;

///时间戳转化为字符转0000-00-00 00:00

+ (NSString *)timeStampToString:(NSTimeInterval)interval;

- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;

- (NSInteger)weekDay;
- (NSString *)weekDayStr;//日 一。。。六
- (NSString *)weekDayString;//周日 周一。。。周六

- (NSDateComponents *)componentsYMD;//y-m-d
- (NSDateComponents *)componentsYMDHMS;//h-m-s

- (NSDate *)setHour:(NSInteger)hour min:(NSInteger)min second:(NSInteger)second;
//判断是否属于同一天
- (BOOL)isSameDayDate:(NSDate *)date;

/**
 是否是每个月的月初,传入一个key,记录，当天只会出现一次，
 */
+ (BOOL)isBeginOfMonth;

- (NSInteger)getDifferenceByNowDate;

- (NSString *)dayString;

@end

@interface NSDate (Dict)

+ (NSDate *)dateFromDict:(NSDictionary *)dict forKey:(NSString *)key;

@end

@interface NSDate (Compare)

/*
 1月2号 早于 1月3号
 1月4号 晚于 1月3号
 
 1、2  ~  1、4
 不早于 1、2 ，  不晚于1、4
 
 判断时间区间是否有效
 1、2 不晚于今天，1、4不早于
 */

+ (BOOL)NoLaterToday:(NSString *)string;//不晚于 今天
+ (BOOL)NoEarlierToday:(NSString *)string;//不早于 今天
+ (BOOL)todayIsValidWithBegin:(NSString *)begin andEnd:(NSString *)end;

@end
