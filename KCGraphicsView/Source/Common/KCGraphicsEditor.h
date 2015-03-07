/**
 * @file	KCGraphicsEditor.h
 * @brief	Define KCGraphicsEditor class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

@protocol  KCGraphicsEditing <NSObject>
- (void) touchesBegan: (CGPoint) point inContext: (CGContextRef) context atLevel: (NSUInteger) level inBoundsRect: (CGRect) boundsrect ;
- (BOOL) touchesMoved: (CGPoint) newpoint inContext: (CGContextRef) context atLevel: (NSUInteger) level inBoundsRect: (CGRect) boundsrect ;
- (void) touchesEnded ;
- (void) touchesCancelled ;
@end

