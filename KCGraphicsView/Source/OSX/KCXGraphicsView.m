/**
 * @file	KCXGraphicsView.m
 * @brief	Define KCGraphicsView class for Mac OS X
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCXGraphicsView.h"

#define DO_DEBUG 0
#if DO_DEBUG
#	import <CoconutGraphics/CoconutGraphics.h>
#endif

@implementation KCGraphicsView

- (void) setDrawer: (KCGraphicsDrawer *) drawer
{
	graphicsDrawer = drawer ;
}

- (void) drawRect:(NSRect) dirtyRect
{
	[super drawRect:dirtyRect];
	
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort] ;
	NSRect bounds = [self bounds] ;
	
	/* Setup as left-lower-origin */
	CGFloat height = self.bounds.size.height;
	CGContextTranslateCTM(context, 0.0, height);
	CGContextScaleCTM(context, 1.0, - 1.0);
	
	[graphicsDrawer drawWithContext: context inBoundsRect: bounds] ;
	
#	if DO_DEBUG
	CNPrintRect(bounds) ;
#	endif
}

@end
