/**
 * @file	KCGraphicsDrawer.m
 * @brief	Define KCGraphicsDrawer class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCGraphicsDrawer.h"

#if TARGET_OS_IPHONE
#	define KCRect		CGRect
#else
#	define KCRect		NSRect
#endif

@implementation KCGraphicsDrawer

- (void) drawWithContext: (CGContextRef) context inBoundsRect: (KCRect) boundsrect
{
	(void) context ; (void) boundsrect ;
	assert(false) ;
}

@end
