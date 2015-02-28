/**
 * @file	UTGraphicsDrawer.m
 * @brief	Subclass of KCGraphicsDrawer for unit test
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */


#import "UTGraphicsDrawer.h"

#if TARGET_OS_IPHONE
#	define KCRect		CGRect
#else
#	define KCRect		NSRect
#endif

@interface UTGraphicsDrawer (Private)
- (void) drawCircleWithContext: (CGContextRef) context inBoundsRect: (KCRect) boundsrect ;
@end

@implementation UTGraphicsDrawer

- (void) drawWithContext: (CGContextRef) context inBoundsRect: (KCRect) boundsrect
{
	[self drawCircleWithContext: context inBoundsRect: boundsrect] ;
}

@end

@implementation UTGraphicsDrawer (Private)

- (void) drawCircleWithContext: (CGContextRef) context inBoundsRect: (KCRect) boundsrect
{
	CGFloat width = MIN(boundsrect.size.width, boundsrect.size.height) ;
	CGRect circlebounds = {
		.origin = {.x = 0.0, .y=0.0} ,
		.size   = {.width = width, .height=width}
	} ;
	CGContextFillEllipseInRect(context, circlebounds);
}

@end
