/**
 * @file	KCGraphicsFunc.m
 * @brief	Define functions for graphics
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KCGraphicsFunc.h"

void
KCDrawHexagon(CGContextRef context, const struct CNHexagon * hexagon)
{
	CGPoint		points[7] ;
	memcpy(points, hexagon->vertexes, sizeof(struct CGPoint) * 6) ;
	points[6] = points[0] ;
	CGContextAddLines(context, points, 7) ;
	CGContextStrokePath(context) ;
}
