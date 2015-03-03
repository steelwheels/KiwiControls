/**
 * @file	KCGraphicsDrawer.h
 * @brief	Define KCGraphicsDrawer class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCGraphicsType.h"

#if TARGET_OS_IPHONE
#	define KCRect		CGRect
#else
#	define KCRect		NSRect
#endif

@protocol  KCGraphicsDrawing <NSObject>
- (void) drawWithContext: (CGContextRef) context atLevel: (NSUInteger) level inBoundsRect: (KCRect) boundsrect ;
@end

@interface KCGraphicsDrawer : NSObject <KCGraphicsDrawing>

@end

#undef KCRect

