/**
 * @file	KCGraphicsDrawer.h
 * @brief	Define KCGraphicsDrawer class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCGraphicsType.h"

@protocol  KCGraphicsDrawing <NSObject>
- (void) drawWithContext: (CGContextRef) context inBoundsRect: (CGRect) boundsrect ;

- (BOOL) isEditable ;
- (void) setEditable: (BOOL) flag ;

- (void) touchesBegan: (CGPoint) point inBoundsRect: (CGRect) boundsrect ;
- (void) touchesMoved: (CGPoint) newpoint inBoundsRect: (CGRect) boundsrect ;
- (void) touchesEnded ;
- (void) touchesCancelled ;
@end


