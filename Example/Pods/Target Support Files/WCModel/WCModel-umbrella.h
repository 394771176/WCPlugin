#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BPFileUtil.h"
#import "DTFileManager.h"

FOUNDATION_EXPORT double WCModelVersionNumber;
FOUNDATION_EXPORT const unsigned char WCModelVersionString[];

