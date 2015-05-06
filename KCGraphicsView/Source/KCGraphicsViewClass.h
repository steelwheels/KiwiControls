/**
 * @file	KCGraphicsView.h
 * @brief	Define KCGraphicsView class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KCGraphicsLayerView.h"

#import <TargetConditionals.h>
#if TARGET_OS_IPHONE
#	define		KCSuperClassOfGraphicsView	UIView
#else
#	define		KCSuperClassOfGraphicsView	NSView
#endif

@interface KCGraphicsView : KCSuperClassOfGraphicsView
{
	NSMutableArray *	graphicsViews ;
}

- (instancetype) initWithCoder:(NSCoder *) decoder ;
#if TARGET_OS_IPHONE
- (instancetype) initWithFrame:(CGRect)frame ;
#else
- (instancetype) initWithFrame:(NSRect)frame ;
#endif

- (void) addGraphicsDrawer: (id <KCGraphicsDrawing>) drawer withDelegate: (id <KCGraphicsDelegate>) delegate ;
- (void) setAllNeedsDisplay ;

@end

#undef KCSuperClassOfGraphicsView
