/**
 * @file	KiwiControl.h.
 * @brief	Bridge for Objective-C
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#import "TargetConditionals.h"
#if TARGET_OS_IPHONE
#	import <UIKit/UIKit.h>
#else
#	import <Cocoa/Cocoa.h>
#endif

//! Project version number for KiwiControls.
FOUNDATION_EXPORT double KiwiControlsVersionNumber;

//! Project version string for KiwiControls.
FOUNDATION_EXPORT const unsigned char KiwiControlsVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <KiwiControls/PublicHeader.h>
//#import <KiwiGraphics/KiwiGraphics.h>

