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

#import "JCFrame.h"
#import "JCFrameAttribute.h"
#import "JCFrameExecutor.h"
#import "JCFrameLayout.h"
#import "JCFrameLayoutConst.h"
#import "JCFrameMake.h"
#import "JCFrameUtilities.h"
#import "UIView+JCFrame.h"
#import "UIView+JCFrameLayout.h"

FOUNDATION_EXPORT double JCFrameLayoutVersionNumber;
FOUNDATION_EXPORT const unsigned char JCFrameLayoutVersionString[];

