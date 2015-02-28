/**
 * @file	KCGraphicsType.h
 * @brief	Define KCGraphicsType class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import <TargetConditionals.h>
#if TARGET_OS_IPHONE
#	import <UIKit/UIKit.h>
#else
#	import <AppKit/AppKit.h>
#endif
#import <CoconutGraphics/CoconutGraphics.h>
