/**
 * @file	KCType.h
 * @brief	Define basic type definitions
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <TargetConditionals.h>
#if TARGET_OS_IPHONE
#	import <UIKit/UIKit.h>
#else
#	import <AppKit/AppKit.h>
#endif
#import <CoreGraphics/CoreGraphics.h>
