//
//  NSObject+DTFix.m
//  DrivingTest
//
//  Created by cheng on 2017/10/17.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "NSObject+DTFix.h"

@implementation NSObject (DTFix)

- (void)showError:(NSString *)msg
{
    NSString *title = @"";
    if ([self isKindOfClass:[NSArray class]]) {
        title = @"🎈🎈array -> dict🎈🎈";
    } else if ([self isKindOfClass:[NSDictionary class]]){
        title = @"🎈🎈dict -> array🎈🎈";
    }
    
    if (![msg isKindOfClass:[NSString class]]) {
        msg = [NSString stringWithFormat:@"%@ - %@", NSStringFromClass(msg.class), msg];
    }
    msg = [NSString stringWithFormat:@"%@ - %@", msg, self];
    
//    if (APP_DEBUG) {
//        [DTPubUtil addBlockOnMainThread:^{
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"FUCK ERROR" otherButtonTitles:nil, nil];
//            [alertView show];
//            [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%@ ### %@", title, msg];
//        }];
//    } else {
//        NSLog(@"%@ ### %@", title, msg);
//    }
}

@end

@implementation NSArray (DTFix)

//不可变数组，添加元素
- (void)addObject:(id)object
{
    NSString *string = [NSString stringWithFormat:@"method: %s - %@", __func__, object];
    [self showError:string];
}

- (void)removeObjectForKey:(NSString *)aKey
{
    NSString *string = [NSString stringWithFormat:@"method: %s - %@", __func__, aKey];
    [self showError:string];
}

- (void)setObject:(id)anObject forKey:(NSString *)aKey
{
    NSString *string = [NSString stringWithFormat:@"method: %s - %@ : %@", __func__, aKey, anObject];
    [self showError:string];
}

- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    NSString *string = [NSString stringWithFormat:@"method: %s - %@ : %@", __func__, aKey, anObject];
    [self showError:string];
}

- (id)stringForKey:(id)aKey
{
    NSString *string = [NSString stringWithFormat:@"method: %s - %@", __func__, aKey];
    [self showError:string];
    return nil;
}

- (float)floatForKey:(id)aKey
{
    NSString *string = [NSString stringWithFormat:@"method: %s - %@", __func__, aKey];
    [self showError:string];
    return 0.f;
}

- (double)doubleForKey:(id)aKey
{
    NSString *string = [NSString stringWithFormat:@"method: %s - %@", __func__, aKey];
    [self showError:string];
    return 0.f;
}

- (int)intForKey:(id)aKey
{
    NSString *string = [NSString stringWithFormat:@"method: %s - %@", __func__, aKey];
    [self showError:string];
    return 0;
}

- (NSInteger)integerForKey:(id)aKey
{
    NSString *string = [NSString stringWithFormat:@"method: %s - %@", __func__, aKey];
    [self showError:string];
    return 0;
}

- (BOOL)boolForKey:(id)aKey
{
    NSString *string = [NSString stringWithFormat:@"method: %s - %@", __func__, aKey];
    [self showError:string];
    return NO;
}

- (id)objectForKey:(NSString *)aKey
{
    NSString *string = [NSString stringWithFormat:@"method: %s - %@", __func__, aKey];
    [self showError:string];
    return nil;
}

- (void)setInt:(NSInteger)n forKey:(NSString *)key
{
    NSString *string = [NSString stringWithFormat:@"method: %s - %@ : %ld", __func__, key, n];
    [self showError:string];
}
- (void)setDouble:(CGFloat)d forKey:(NSString *)key
{
    NSString *string = [NSString stringWithFormat:@"method: %s - %@ : %f", __func__, key, d];
    [self showError:string];
}

- (NSDictionary *)filterEntriesUsingBlock:(BOOL (^)(id key, id value))block
{
    NSString *string = [NSString stringWithFormat:@"method: %s", __func__];
    [self showError:string];
    return nil;
}

- (NSDictionary *)mappedValuesUsingBlock:(id (^)(id key, id value))block
{
    NSString *string = [NSString stringWithFormat:@"method: %s", __func__];
    [self showError:string];
    return nil;
}

@end

@implementation NSDictionary (DTFix)

//不可变字典，添加key value
- (void)setObject:(id)anObject forKey:(NSString *)aKey
{
    NSString *string = [NSString stringWithFormat:@"method: %s - %@ - %@", __func__, anObject, aKey];
    [self showError:string];
}

- (id)objectAtIndex:(NSUInteger)index
{
    NSString *string = [NSString stringWithFormat:@"method: %s", __func__];
    [self showError:string];
    return nil;
}

- (NSUInteger)indexOfObject:(id)anObject
{
    NSString *string = [NSString stringWithFormat:@"method: %s", __func__];
    [self showError:string];
    return NSNotFound;
}

- (void)addObject:(id)object
{
    NSString *string = [NSString stringWithFormat:@"method: %s", __func__];
    [self showError:string];
}

- (void)addObjectsFromArray:(NSArray *)array
{
    NSString *string = [NSString stringWithFormat:@"method: %s", __func__];
    [self showError:string];
}

- (void)safeAddObject:(id)anObject
{
    NSString *string = [NSString stringWithFormat:@"method: %s - %@", __func__, anObject];
    [self showError:string];
}

- (id)safeObjectAtIndex:(NSUInteger)index
{
    NSString *string = [NSString stringWithFormat:@"method: %s - %@", __func__, @(index)];
    [self showError:string];
    return nil;
}

- (void)safeRemoveObjectAtIndex:(NSUInteger)index
{
    NSString *string = [NSString stringWithFormat:@"method: %s - %@", __func__, @(index)];
    [self showError:string];
}

- (NSString *)stringValueSeparatedByComma
{
    NSString *string = [NSString stringWithFormat:@"method: %s", __func__];
    [self showError:string];
    return nil;
}

- (NSArray *)filteredArrayUsingBlock:(BOOL(^)(id obj))block
{
    NSString *string = [NSString stringWithFormat:@"method: %s", __func__];
    [self showError:string];
    return nil;
}

- (NSArray *)mappedArrayUsingBlock:(id (^)(id obj))block
{
    NSString *string = [NSString stringWithFormat:@"method: %s", __func__];
    [self showError:string];
    return nil;
}

- (NSArray *)sortedArrayWithKey:(NSString *)key ascending:(BOOL)ascending
{
    NSString *string = [NSString stringWithFormat:@"method: %s", __func__];
    [self showError:string];
    return nil;
}
- (NSArray *)sortedArrayWithKeys:(NSArray *)keys ascending:(BOOL)ascending
{
    NSString *string = [NSString stringWithFormat:@"method: %s", __func__];
    [self showError:string];
    return nil;
}
- (NSArray *)sortedArrayWithKeys:(NSArray *)keys ascendings:(NSArray *)ascendings
{
    NSString *string = [NSString stringWithFormat:@"method: %s", __func__];
    [self showError:string];
    return nil;
}

- (NSArray *)subArrayWithIndex:(NSInteger)index group:(NSInteger)group
{
    NSString *string = [NSString stringWithFormat:@"method: %s", __func__];
    [self showError:string];
    return nil;
}

- (void)filterUsingBlock:(BOOL(^)(id obj))block
{
    NSString *string = [NSString stringWithFormat:@"method: %s", __func__];
    [self showError:string];
}

- (void)moveObjectAtIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex
{
    NSString *string = [NSString stringWithFormat:@"method: %s", __func__];
    [self showError:string];
}

@end
