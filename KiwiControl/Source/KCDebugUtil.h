/**
 * @file	KCDebugUtil.h
 * @brief	Define utility functions for debugging
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCType.h"

#if TARGET_OS_IPHONE
#	define	KCView			UIView
#else
#	define	KCView			NSView
#endif

void
KCPrintView(KCView * view) ;

#undef KCView


