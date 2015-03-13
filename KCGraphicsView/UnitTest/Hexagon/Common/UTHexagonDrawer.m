/**
 * @file	UTHexagonDrawer.m
 * @brief	Subclass of KCGraphicsDrawer for unit test
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "UTHexagonDrawer.h"

@implementation UTHexagonDrawer

- (void) drawWithContext: (CGContextRef) context atLevel: (NSUInteger) level inBoundsRect: (CGRect) boundsrect
{
	(void) level ;
	
	CGPoint center = CNRectGetCenter(boundsrect) ;
	CGFloat radius = MIN(boundsrect.size.width, boundsrect.size.height) / 2.0 ;
	struct CNHexagon hexagon = CNMakeHexagon(center, radius) ;
	KCDrawHexagon(context, &hexagon) ;
}

@end

