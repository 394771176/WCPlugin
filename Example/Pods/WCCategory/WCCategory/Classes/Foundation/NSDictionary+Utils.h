//
//  NSDictionary+Utils.h
//  FFStory
//
//  Created by PageZhang on 14/11/18.
//  Copyright (c) 2014年 FF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 合并字典，如果有相同的key，second中的value会把first的覆盖
extern NSDictionary *FFMergeDictionaries(NSDictionary *first, NSDictionary *second);

@interface NSDictionary <KeyType, ObjectType> (Utils)

- (NSString *)stringForKey:(KeyType<NSCopying>)aKey;

- (float)floatForKey:(KeyType<NSCopying>)aKey;

- (double)doubleForKey:(KeyType<NSCopying>)aKey;

- (int)intForKey:(KeyType<NSCopying>)aKey;

- (NSInteger)integerForKey:(KeyType<NSCopying>)aKey;

- (BOOL)boolForKey:(KeyType<NSCopying>)aKey;

- (NSArray *)arrayForKey:(KeyType<NSCopying>)aKey;

- (NSDictionary *)dictionaryForKey:(KeyType<NSCopying>)aKey;

// 返回符合条件的key-value对字典
- (NSDictionary *)filterEntriesUsingBlock:(BOOL (^)(id key, id value))block;

// 修改key和value，返回修改后的字典
- (NSDictionary *)mappedValuesUsingBlock:(id (^)(id key, id value))block;

- (NSArray *)arrayFromStringForKey:(NSString *)aKey;

+ (BOOL)validDict:(NSDictionary *)dict;
+ (BOOL)validDict:(NSDictionary *)dict forKey:(NSString *)key;
+ (BOOL)validArrayFromDict:(NSDictionary *)dict forKey:(NSString *)key;

+ (NSDictionary *)dictFromItemArray:(NSArray *)array withKey:(NSString *)key;

+ (NSDictionary *)dictionaryFromURLQuery:(NSString *)query;

@end

@interface NSMutableDictionary <KeyType, ObjectType> (Utils)

- (void)setInt:(NSInteger)n forKey:(NSString *)key;
- (void)setDouble:(CGFloat)d forKey:(NSString *)key;

- (void)safeSetObject:(ObjectType)anObject forKey:(KeyType<NSCopying>)aKey;

@end


