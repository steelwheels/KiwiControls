/**
 * @file	KCGraphicsEditor.h
 * @brief	Define KCGraphicsEditor class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

@protocol  KCGraphicsEditing <NSObject>
- (BOOL) isEditable ;
- (void) setEditable: (BOOL) flag ;

- (void) touchesBegan: (CGPoint) point atLevel: (NSUInteger) level inBoundsRect: (CGRect) boundsrect ;
- (bool) touchesMoved: (CGPoint) newpoint atLevel: (NSUInteger) level inBoundsRect: (CGRect) boundsrect ;
- (bool) touchesEnded ;
- (bool) touchesCancelled ;
@end

