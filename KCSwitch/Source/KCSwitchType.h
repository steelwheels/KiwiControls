/**
 * @file	KCSwitchType.h
 * @brief	Header file to import OS dependent headers
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import <TargetConditionals.h>
#if TARGET_OS_IPHONE
#	import <UIKit/UIKit.h>
#else
#	import <Cocoa/Cocoa.h>
#endif
//#import <CoconutGraphics/CoconutGraphics.h>
//#import <KiwiControl/KiwiControl.h>

