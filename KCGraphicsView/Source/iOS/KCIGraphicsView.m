/**
 * @file	KCIGraphicsView.m
 * @brief	Define KCGraphicsView class for Mac OS X
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCIGraphicsView.h"

#define DO_DEBUG 0
#if DO_DEBUG
#	import <CoconutGraphics/CoconutGraphics.h>
#endif

@implementation KCGraphicsView

- (void) setDrawer: (KCGraphicsDrawer *) drawer
{
	graphicsDrawer = drawer ;
}

- (void) drawRect:(CGRect) dirtyRect
{
	[super drawRect:dirtyRect];

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGRect bounds = [self bounds] ;
	[graphicsDrawer drawWithContext: context inBoundsRect: bounds] ;
	
#	if DO_DEBUG
	CNPrintRect(bounds) ;
#	endif
}

@end
