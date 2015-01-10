/**
 * @file	KCGraphicsDrawer.h
 * @brief	Define KCGraphicsDrawer class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@protocol  KCGraphicsDrawing <NSObject>
- (void) drawWithContext: (CGContextRef) context inBoundsRect: (NSRect) boundsrect ;
@end

@interface KCGraphicsDrawer : NSObject <KCGraphicsDrawing>

@end

