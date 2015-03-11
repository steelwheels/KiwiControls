/**
 * @file	KCXGraphicsView.h
 * @brief	Define KCGraphicsView class for Mac OS X
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <Cocoa/Cocoa.h>
#import "KCGraphicsDrawer.h"
#import "KCGraphicsEditor.h"
#import "KCGraphicsDelegate.h"

@interface KCGraphicsLayerView: NSView
{
	NSUInteger		layerLevel ;
	id <KCGraphicsDrawing>	graphicsDrawer ;
	id <KCGraphicsEditing>	graphicsEditor ;
	id <KCGraphicsDelegate>	graphicsDelegate ;
}

- (instancetype) initWithCoder:(NSCoder *) decoder ;
- (instancetype) initWithFrame:(CGRect)frame ;

- (void) setLayerLevel: (NSUInteger) level ;
- (NSUInteger) layerLevel ;

- (void) setGraphicsDrawer: (id <KCGraphicsDrawing>) drawer ;
- (id <KCGraphicsDrawing>) graphicsDrawer ;
- (void) setGraphicsEditor: (id <KCGraphicsEditing>) editor ;
- (id <KCGraphicsEditing>) graphicsEditor ;
- (void) setGraphicsDelegate: (id <KCGraphicsDelegate>) delegate ;
- (id <KCGraphicsDelegate>) graphicsDelegate ;

- (void) drawRect:(CGRect) dirtyRect ;
@end

@interface KCGraphicsView : KCGraphicsLayerView
{
	NSMutableArray *	transparentViews ;
}

- (instancetype) initWithCoder:(NSCoder *) decoder ;
- (instancetype) initWithFrame:(CGRect)frame ;

- (void) setGraphicsDrawer: (id <KCGraphicsDrawing>) drawer ;
- (void) setGraphicsEditor: (id <KCGraphicsEditing>) editor ;
- (void) setGraphicsDelegate: (id <KCGraphicsDelegate>) delegate ;

- (void) allocateTransparentViews: (unsigned int) viewnum ;

@end
