/**
 * @file	KCGraphicsLayerView.h
 * @brief	Define KCGraphicsLayerView class
 * @par Copyright
 *   Copyright (C) 2014,2015 Steel Wheels Project
 */

#import "KCGraphicsType.h"
#import "KCGraphicsDrawing.h"
#import "KCGraphicsDelegate.h"

#import <TargetConditionals.h>
#if TARGET_OS_IPHONE
#	define		KCSuperClassOfGraphicsView	UIView
#else
#	define		KCSuperClassOfGraphicsView	NSView
#endif

@interface KCGraphicsLayerView: KCSuperClassOfGraphicsView

@property (strong, nonatomic) id <KCGraphicsDrawing>	graphicsDrawer ;
@property (strong, nonatomic) id <KCGraphicsDelegate>	graphicsDelegate ;

- (instancetype) initWithCoder:(NSCoder *) decoder ;
#if TARGET_OS_IPHONE
- (instancetype) initWithFrame:(CGRect)frame ;
#else
- (instancetype) initWithFrame:(NSRect)frame ;
#endif

- (void) setGraphicsDrawer: (id <KCGraphicsDrawing>) drawer ;
- (id <KCGraphicsDrawing>) graphicsDrawer ;

- (void) setGraphicsDelegate: (id <KCGraphicsDelegate>) delegate ;
- (id <KCGraphicsDelegate>) graphicsDelegate ;

- (void) drawRect:(CGRect) dirtyRect ;
@end

#undef KCSuperClassOfGraphicsView

