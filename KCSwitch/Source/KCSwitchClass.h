/**
 * @file	KCSwitchClass.h
 * @brief	Define KCSwitch class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KCSwitchType.h"

#if TARGET_OS_IPHONE
#	define KCSuperClassOfSwitch	UISwitch
#else
#	define KCSuperClassOfSwitch	NSButton
#endif

@interface KCSwitch : KCSuperClassOfSwitch

@end

#undef KCSuperClassOfSwitch

