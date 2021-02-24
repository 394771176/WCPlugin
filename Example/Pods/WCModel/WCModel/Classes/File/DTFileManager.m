//
//  DTFileManager.m
//  Snake
//
//  Created by cheng on 17/8/19.
//  Copyright © 2017年 cheng. All rights reserved.
//

#import "DTFileManager.h"


NSString * readTxtFromPath(NSString *path)
{
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return string;
}

void writeTxtToPath(NSString *text, NSString *path)
{
    [text writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


@interface DTFileManager () {
    
}

@property (nonatomic, readonly) NSFileManager *fileManager;

@end

@implementation DTFileManager

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSFileManager *)fileManager
{
    return [NSFileManager defaultManager];
}

+ (NSFileManager *)fileManager
{
    return [[self sharedInstance] fileManager];
}

+ (BOOL)isFileExist:(NSString *)path
{
    return [[self fileManager] fileExistsAtPath:path];
}

+ (BOOL)isFileDirectory:(NSString *)path
{
    BOOL isDir = NO;
    BOOL isExist = NO;
    isExist = [[self fileManager] fileExistsAtPath:path isDirectory:&isDir];
    return isExist & isDir;
}

+ (NSArray *)contentsWithPath:(NSString *)path
{
    return [[self fileManager] contentsOfDirectoryAtPath:path error:NULL];
}

+ (NSArray *)subpathsWithPath:(NSString *)path
{
    return [[self fileManager] subpathsOfDirectoryAtPath:path error:NULL];
}

+ (NSArray *)subpathsAtPath:(NSString *)path
{
    return [[self fileManager] subpathsAtPath:path];
}

+ (NSDictionary *)attWithFilePath:(NSString *)path
{
    return [[self fileManager] attributesOfItemAtPath:path error:NULL];
}

+ (NSString *)fileSizeFormat:(NSInteger)size
{
    if (size < 1024) {
        return [NSString stringWithFormat:@"%zd B", size];
    } else if (size < 1024 * 1024) {
        return [NSString stringWithFormat:@"%.2f KB", size/1024.f];
    } else {
        return [NSString stringWithFormat:@"%.2f MB", size/1024.f/1024.f];
    }
}

+ (BOOL)copyItemWithPath:(NSString *)path toPath:(NSString *)toPath
{
    return [self copyItemWithPath:path toPath:toPath cover:YES];
}

+ (BOOL)copyItemWithPath:(NSString *)path toPath:(NSString *)toPath cover:(BOOL)cover
{
    if ([self.fileManager fileExistsAtPath:path]) {
        if (cover || ![self.fileManager fileExistsAtPath:toPath]) {
            NSError *error = nil;
            [self.fileManager copyItemAtPath:path toPath:toPath error:&error];
            return error ? NO : YES;
        }
    }
    return NO;
}

+ (BOOL)moveItemWithPath:(NSString *)path toPath:(NSString *)toPath
{
    return [self moveItemWithPath:path toPath:toPath cover:YES];
}

+ (BOOL)moveItemWithPath:(NSString *)path toPath:(NSString *)toPath cover:(BOOL)cover
{
    if ([self.fileManager fileExistsAtPath:path]) {
        if (cover || ![self.fileManager fileExistsAtPath:toPath]) {
            NSError *error = nil;
            [self.fileManager moveItemAtPath:path toPath:toPath error:&error];
            return error ? NO : YES;
        }
    }
    return NO;
}

+ (BOOL)deleteItemWithPath:(NSString *)path
{
    if (path) {
        NSError *error = nil;
        [[self fileManager] removeItemAtPath:path error:&error];
        return error ? NO : YES;
    }
    return NO;
}

+ (BOOL)deleteItemWithPath:(NSString *)path fileName:(NSString *)fileName
{
    if (path && fileName) {
     return [self deleteItemWithPath:[path stringByAppendingPathComponent:fileName]];
    }
    return NO;
}

@end
