/**
 * @file	KCIGraphicsView.h
 * @brief	Define KCGraphicsView class for Mac OS X
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>
#import "KCGraphicsDrawer.h"
#import "KCGraphicsEditor.h"

@interface KCGraphicsLayerView: UIView
{
	NSUInteger		layerLevel ;
	id <KCGraphicsDrawing>	graphicsDrawer ;
	id <KCGraphicsEditing>	graphicsEditor ;
}

- (instancetype) initWithCoder:(NSCoder *) decoder ;
- (instancetype) initWithFrame:(CGRect)frame ;

- (void) setLayerLevel: (NSUInteger) level ;
- (NSUInteger) layerLevel ;

- (void) setGraphicsDrawer: (id <KCGraphicsDrawing>) drawer ;
- (id <KCGraphicsDrawing>) graphicsDrawer ;

- (void) setGraphicsEditor: (id <KCGraphicsEditing>) editor ;
- (id <KCGraphicsEditing>) graphicsEditor ;

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
- (void) allocateTransparentViews: (unsigned int) viewnum ;

@end
