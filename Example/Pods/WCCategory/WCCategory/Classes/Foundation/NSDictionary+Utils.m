//
//  NSDictionary+Utils.m
//  FFStory
//
//  Created by PageZhang on 14/11/18.
//  Copyright (c) 2014年 FF. All rights reserved.
//

#import "NSDictionary+Utils.h"
#import <libkern/OSAtomic.h>
//#import "WCCategory.h"
#import "WCCategory+NS.h"

NSDictionary *FFMergeDictionaries(NSDictionary *first, NSDictionary *second) {
    if ([first isKindOfClass:[NSDictionary class]] && [second isKindOfClass:[NSDictionary class]]) {
        if (first && second.count == 0) return [first copy];  // Fast Path.
        if (second && first.count == 0) return [second copy]; // Fast Path.
        
        NSMutableDictionary *merged = [NSMutableDictionary dictionaryWithDictionary:first];
        [merged addEntriesFromDictionary:second];
        return [merged copy];
    }
    return nil;
}

@implementation NSDictionary (Utils)

- (id)stringForKey:(id)aKey
{
    id source = [self objectForKey:aKey];
    
    if ([source isKindOfClass:[NSString class]]) {
        return source;
    } else if ([source isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", source];
    } else {
        return nil;
    }
}

- (float)floatForKey:(id)aKey
{
    id source = [self objectForKey:aKey];
    
    if ([source isKindOfClass:[NSString class]]) {
        return [source floatValue];
    } else if ([source isKindOfClass:[NSNumber class]]) {
        return [source floatValue];
    } else {
        return 0;
    }
}

- (double)doubleForKey:(id)aKey
{
    id source = [self objectForKey:aKey];
    
    if ([source isKindOfClass:[NSString class]]) {
        return [(NSString *)source doubleValue];
    } else if ([source isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)source doubleValue];
    } else {
        return 0;
    }
}

- (int)intForKey:(id)aKey
{
    id source = [self objectForKey:aKey];
    
    if ([source isKindOfClass:[NSString class]]) {
        return [source intValue];
    } else if ([source isKindOfClass:[NSNumber class]]) {
        return [source intValue];
    } else {
        return 0;
    }
}

- (BOOL)boolForKey:(id)aKey
{
    id source = [self objectForKey:aKey];
    
    if (source == [NSNull null]) {
        return NO;
    }
    return [source boolValue];
}

- (NSInteger)integerForKey:(id)aKey
{
    id source = [self objectForKey:aKey];
    if ([source isKindOfClass:[NSString class]]) {
        return [source integerValue];
    } else if ([source isKindOfClass:[NSNumber class]]) {
        return [source integerValue];
    } else {
        return 0;
    }
}

- (NSArray *)arrayForKey:(id)aKey
{
    NSArray *source = [self objectForKey:aKey];
    if ([source isKindOfClass:[NSArray class]]) {
        return source;
    }
    // 有对象但是类型错误
    NSString *errorTip = [NSString stringWithFormat:@"类型不匹配：%@",source];
    NSAssert(source == nil, errorTip);
    return nil;
}

- (NSDictionary *)dictionaryForKey:(id)aKey
{
    NSDictionary *source = [self objectForKey:aKey];
    if ([source isKindOfClass:[NSDictionary class]]) {
        return source;
    }
    NSString *errorTip = [NSString stringWithFormat:@"类型不匹配：%@",source];
    NSAssert(source == nil, errorTip);
    return nil;
}

+ (NSDictionary *)dictionaryFromURLQuery:(NSString *)query {
    if (query.length == 0) return nil;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSArray *elements = [query componentsSeparatedByString:@"&"];
    
    for (NSString *element in elements) {
        NSArray *pair = [element componentsSeparatedByString:@"="];
        if (pair.count != 2) {
            continue;
        }
        
        NSString *key = [pair[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *value = [pair[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        dictionary[key] = value;
    }
    return [dictionary copy];
}

#pragma mark - objects

- (NSDictionary *)filterEntriesUsingBlock:(BOOL (^)(id key, id value))block {
    return [self filterEntriesWithOptions:0 usingBlock:block];
}
- (NSDictionary *)filterEntriesWithOptions:(NSEnumerationOptions)opts usingBlock:(BOOL (^)(id key, id value))block {
    NSSet *matchingKeys = [self keysOfEntriesWithOptions:opts passingTest:^(id key, id value, BOOL *stop) {
        return block(key, value);
    }];
    
    NSArray *keys = [matchingKeys allObjects];
    NSArray *values = [self objectsForKeys:keys notFoundMarker:NSNull.null];
    
    return [NSDictionary dictionaryWithObjects:values forKeys:keys];
}

- (NSDictionary *)filterEntriesWithFailedEntries:(NSDictionary **)failedEntries usingBlock:(BOOL(^)(id key, id value))block {
    return [self filterEntriesWithOptions:0 failedEntries:failedEntries usingBlock:block];
}
- (NSDictionary *)filterEntriesWithOptions:(NSEnumerationOptions)opts failedEntries:(NSDictionary **)failedEntries usingBlock:(BOOL(^)(id key, id value))block {
    NSUInteger originalCount = self.count;
    BOOL concurrent = (opts&NSEnumerationConcurrent);
    
    __unsafe_unretained volatile id *keys = (__unsafe_unretained id *)calloc(originalCount, sizeof(*keys));
    if (keys == NULL) return nil;
    
    __unsafe_unretained volatile id *values = (__unsafe_unretained id *)calloc(originalCount, sizeof(*values));
    if (values == NULL) {
        free((void *)keys);
        return nil;
    }
    
    volatile int64_t nextSuccessIndex = 0;
    volatile int64_t *nextSuccessIndexPtr = &nextSuccessIndex;
    
    volatile int64_t nextFailureIndex = originalCount - 1;
    volatile int64_t *nextFailureIndexPtr = &nextFailureIndex;
    
    [self enumerateKeysAndObjectsWithOptions:opts usingBlock:^(id key, id value, BOOL *stop) {
        BOOL result = block(key, value);
        
        int64_t index;
        
        // find the index to store into the arrays
        if (result) {
            int64_t indexPlusOne = OSAtomicIncrement64Barrier(nextSuccessIndexPtr);
            index = indexPlusOne - 1;
        }else {
            int64_t indexMinusOne = OSAtomicDecrement64Barrier(nextFailureIndexPtr);
            index = indexMinusOne + 1;
        }
        
        keys[index] = key;
        values[index] = value;
    }];
    
    if (concurrent) {
        // finish all assignments into the 'keys' and 'values' arrays
        OSMemoryBarrier();
    }
    
    NSUInteger successCount = (NSUInteger)nextSuccessIndex;
    NSUInteger failureCount = originalCount - 1 - (NSUInteger)nextFailureIndex;
    
    if (failedEntries) {
        size_t objectsOffset = (size_t)(nextFailureIndex + 1);
        
        *failedEntries = [NSDictionary dictionaryWithObjects:(__unsafe_unretained id *)(values + objectsOffset) forKeys:(__unsafe_unretained id *)(keys + objectsOffset) count:failureCount];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:(id *)values forKeys:(id *)keys count:successCount];
    free((void *)keys);
    free((void *)values);
    
    return dict;
}


- (NSDictionary *)mappedValuesUsingBlock:(id (^)(id key, id value))block {
    return [self mappedValuesWithOptions:0 usingBlock:block];
}
- (NSDictionary *)mappedValuesWithOptions:(NSEnumerationOptions)opts usingBlock:(id (^)(id key, id value))block {
    NSUInteger originalCount = self.count;
    BOOL concurrent = (opts & NSEnumerationConcurrent);
    
    // we don't need to retain the individual keys, since the original dictionary is already doing so, and the keys themselves won't change
    __unsafe_unretained volatile id *keys = (__unsafe_unretained id *)calloc(originalCount, sizeof(*keys));
    if (keys == NULL) return nil;
    
    __strong volatile id *values = (__strong id *)calloc(originalCount, sizeof(*values));
    if (values == NULL) {
        free((void *)keys);
        return nil;
    }
    
    // declare these variables way up here so that they can be used in the
    // @onExit block below (avoiding unnecessary iteration)
    volatile int64_t nextIndex = 0;
    volatile int64_t *nextIndexPtr = &nextIndex;
    
    [self enumerateKeysAndObjectsWithOptions:opts usingBlock:^(id key, id value, BOOL *stop) {
        id newValue = block(key, value);
        
        // don't increment the index, go on to the next object
        if (newValue == nil) return;
        
        // find the index to store into the array -- 'nextIndex' is updated to
        // reflect the total number of elements
        int64_t indexPlusOne = OSAtomicIncrement64Barrier(nextIndexPtr);
        
        keys[indexPlusOne - 1] = key;
        values[indexPlusOne - 1] = newValue;
    }];
    
    // finish all assignments into the 'keys' and 'values' arrays
    if (concurrent) OSMemoryBarrier();
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:(id *)values forKeys:(id *)keys count:(NSUInteger)nextIndex];
    
    free((void *)keys);
    // nil out everything in the 'values' array to make sure ARC releases everything appropriately
    NSUInteger actualCount = (NSUInteger)*nextIndexPtr;
    for (NSUInteger i = 0; i < actualCount; ++i) values[i] = nil;
    free((void *)values);
    
    return dict;
}

- (NSArray *)arrayFromStringForKey:(NSString *)aKey
{
    NSString *string = [self stringForKey:aKey];
    if (string.length) {
        return [string componentsSeparatedByString:@","];
    }
    return nil;
}

+ (BOOL)validDict:(NSDictionary *)dict
{
    if (dict && [dict isKindOfClass:[NSDictionary class]] && dict.count) {
        return YES;
    }
    return NO;
}

+ (BOOL)validDict:(NSDictionary *)dict forKey:(NSString *)key
{
    if (!key.length) {
        return NO;
    }
    return [self validDict:dict] && [self validDict:[dict objectForKey:key]];
}

+ (BOOL)validArrayFromDict:(NSDictionary *)dict forKey:(NSString *)key
{
    return [NSArray validArrayFromDict:dict forKey:key];
}

+ (NSDictionary *)dictFromItemArray:(NSArray *)array withKey:(NSString *)key
{
    if ([NSArray validArray:array] && key.length) {
        __block BOOL respondKey = NO;
        NSString *realKey = [NSString stringWithFormat:@"_%@", key];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                respondKey = [obj respondsToSelector:NSSelectorFromString(key)];
            }
            
            if (respondKey) {
                NSString *string = [NSString stringWithFormat:@"%@", [obj valueForKey:realKey]];
                [dict safeSetObject:obj forKey:string];
            } else {
                *stop = YES;
            }
        }];
        return dict;
    }
    return nil;
}

@end

@implementation NSMutableDictionary (IntValue)

- (void)setInt:(NSInteger)n forKey:(NSString *)key
{
    [self safeSetObject:[NSString stringWithFormat:@"%ld", n] forKey:key];
}

- (void)setDouble:(CGFloat)d forKey:(NSString *)key
{
    [self safeSetObject:[NSString stringWithFormat:@"%f", d] forKey:key];
}

- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    @try{
        if (anObject&&aKey) {
            [self setObject:anObject forKey:aKey];
        }
    } @catch(NSException* e) {
        
    }
}

@end
