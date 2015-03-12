/**
 * @file	KCGraphicsViewClass.h
 * @brief	Define KCGraphicsView class for Mac OS X
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCGraphicsType.h"
#import "KCGraphicsDrawer.h"
#import "KCGraphicsEditor.h"
#import "KCGraphicsDelegate.h"

#import <TargetConditionals.h>
#if TARGET_OS_IPHONE
#	define		KCSuperClassOfGraphicsView	UIView
#else
#	define		KCSuperClassOfGraphicsView	NSView
#endif

@interface KCGraphicsLayerView: KCSuperClassOfGraphicsView
{
	NSUInteger		layerLevel ;
	id <KCGraphicsDrawing>	graphicsDrawer ;
	id <KCGraphicsEditing>	graphicsEditor ;
	id <KCGraphicsDelegate>	graphicsDelegate ;
}

- (instancetype) initWithCoder:(NSCoder *) decoder ;
#if TARGET_OS_IPHONE
- (instancetype) initWithFrame:(CGRect)frame ;
#else
- (instancetype) initWithFrame:(NSRect)frame ;
#endif

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
#if TARGET_OS_IPHONE
- (instancetype) initWithFrame:(CGRect)frame ;
#else
- (instancetype) initWithFrame:(NSRect)frame ;
#endif

- (void) setGraphicsDrawer: (id <KCGraphicsDrawing>) drawer ;
- (void) setGraphicsEditor: (id <KCGraphicsEditing>) editor ;
- (void) setGraphicsDelegate: (id <KCGraphicsDelegate>) delegate ;

- (void) allocateTransparentViews: (unsigned int) viewnum ;

@end

#undef KCSuperClassOfGraphicsView

