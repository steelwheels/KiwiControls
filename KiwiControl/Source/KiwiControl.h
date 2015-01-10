/**
 * @file	KiwiControl.h
 * @brief	Import all header files for KiwiControl library
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <TargetConditionals.h>
#if TARGET_OS_IPHONE
#else /* TARGET_OS_IPHONE */
#	import <Cocoa/Cocoa.h>

	//! Project version number for KiwiControl.
	FOUNDATION_EXPORT double KiwiControlVersionNumber;

	//! Project version string for KiwiControl.
	FOUNDATION_EXPORT const unsigned char KiwiControlVersionString[];
#endif /* TARGET_OS_IPHONE */

#import "KCPreference.h"
#import "KCViewVisitor.h"
#import "KCViewUtil.h"
#import "KCXIBUtil.h"
#import "KCDebugUtil.h"


