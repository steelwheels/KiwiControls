/**
 * @file	KCXGraphicsView.h
 * @brief	Define KCGraphicsView class for Mac OS X
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <Cocoa/Cocoa.h>
#import "KCGraphicsDrawer.h"

@interface KCGraphicsView : NSView
{
	KCGraphicsDrawer *	graphicsDrawer ;
}

- (void) setDrawer: (KCGraphicsDrawer *) drawer ;

@end
