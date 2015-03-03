/**
 * @file	KCIGraphicsView.h
 * @brief	Define KCGraphicsView class for Mac OS X
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>
#import "KCGraphicsDrawer.h"

@interface KCGraphicsLayerView: UIView
{
	NSUInteger		layerLevel ;
	KCGraphicsDrawer *	graphicsDrawer ;
}

- (instancetype) initWithCoder:(NSCoder *) decoder ;
- (instancetype) initWithFrame:(CGRect)frame ;

- (void) setLayerLevel: (NSUInteger) level ;
- (NSUInteger) layerLevel ;

- (void) setGraphicsDrawer: (KCGraphicsDrawer *) drawer ;
- (KCGraphicsDrawer *) graphicsDrawer ;

- (void) drawRect:(CGRect) dirtyRect ;
@end

@interface KCGraphicsView : KCGraphicsLayerView
{
	NSMutableArray *	transparentViews ;
}

- (instancetype) initWithCoder:(NSCoder *) decoder ;
- (instancetype) initWithFrame:(CGRect)frame ;

- (void) setGraphicsDrawer: (KCGraphicsDrawer *) drawer ;
- (void) allocateTransparentViews: (unsigned int) viewnum ;

@end
