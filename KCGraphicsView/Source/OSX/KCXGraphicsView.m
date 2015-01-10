/**
 * @file	KCXGraphicsView.m
 * @brief	Define KCGraphicsView class for Mac OS X
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCXGraphicsView.h"

@implementation KCGraphicsView

- (void) setDrawer: (KCGraphicsDrawer *) drawer
{
	graphicsDrawer = drawer ;
}

- (void) drawRect:(NSRect) dirtyRect
{
	[super drawRect:dirtyRect];
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort] ;
	//NSRect framerect = [self frame] ;
	[graphicsDrawer drawWithContext: context inFrameRect: dirtyRect] ;
}

@end
