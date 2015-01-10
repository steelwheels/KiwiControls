/**
 * @file	KCIGraphicsView.h
 * @brief	Define KCGraphicsView class for Mac OS X
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>
#import "KCGraphicsDrawer.h"

@interface KCGraphicsView : UIView
{
	KCGraphicsDrawer *	graphicsDrawer ;
}

- (void) setDrawer: (KCGraphicsDrawer *) drawer ;

@end
