/**
 * @file	KCGraphicsDrawer.h
 * @brief	Define KCGraphicsDrawer class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface KCGraphicsDrawer : NSObject

- (void) drawWithContext: (CGContextRef) context inFrameRect: (NSRect) framerect ;

@end

