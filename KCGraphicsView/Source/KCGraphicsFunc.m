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

static inline int
normalizeIndex(int index)
{
	while(index < 0){
		index += 6 ;
	}
	return index % 6 ;
}

void
KCFillHexagonWithLineGradiation(CGContextRef context, struct CN3PointsLineGradient * gradient, const struct CNHexagon * hexagon, int fromidx, int toidx)
{
	CGContextSaveGState(context) ;
	
	CGContextBeginPath(context) ;
	addLinesOfHexagon(context, hexagon) ;
	CGContextClip(context) ;
	
	CGPoint frompoint = hexagon->vertexes[normalizeIndex(fromidx)] ;
	CGPoint topoint   = hexagon->vertexes[normalizeIndex(toidx)] ;
	CGContextDrawLinearGradient(context, gradient->gradientRef, frompoint, topoint, 0) ;
	
	CGContextRestoreGState(context) ;
}
