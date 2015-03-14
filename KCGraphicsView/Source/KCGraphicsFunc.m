/**
 * @file	KCGraphicsFunc.m
 * @brief	Define functions for graphics
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KCGraphicsFunc.h"

static inline void
addLinesOfHexagon(CGContextRef context, const struct CNHexagon * hexagon)
{
	CGPoint		points[7] ;
	memcpy(points, hexagon->vertexes, sizeof(struct CGPoint) * 6) ;
	points[6] = points[0] ;
	CGContextAddLines(context, points, 7) ;
}

void
KCDrawHexagon(CGContextRef context, const struct CNHexagon * hexagon)
{
	addLinesOfHexagon(context, hexagon) ;
	CGContextStrokePath(context) ;
}

void
KCFillHexagon(CGContextRef context, const struct CNHexagon * hexagon)
{
	addLinesOfHexagon(context, hexagon) ;
	CGContextFillPath(context) ;
}