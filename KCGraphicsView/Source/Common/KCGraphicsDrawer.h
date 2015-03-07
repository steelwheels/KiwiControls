/**
 * @file	KCGraphicsDrawer.h
 * @brief	Define KCGraphicsDrawer class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCGraphicsType.h"

@protocol  KCGraphicsDrawing <NSObject>
- (void) drawWithContext: (CGContextRef) context atLevel: (NSUInteger) level inBoundsRect: (CGRect) boundsrect ;
@end


