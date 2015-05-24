/**
 * @file	UTHexagonDrawer.m
 * @brief	Subclass of KCGraphicsDrawer for unit test
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "UTHexagonDrawer.h"

static void divideBounds(CGRect dst[4], CGRect src) ;

@implementation UTHexagonDrawer

- (void) drawWithContext: (CGContextRef) context inBoundsRect: (CGRect) boundsrect
{	
	CNColorTable * ctable = [CNColorTable defaultColorTable] ;
	struct CNRGB goldcol  = [ctable goldenrod1] ;
	struct CNRGB blackcol = [ctable black] ;
	struct CN3PointsLineGradient gradient = CNAllocate3PointsLineGradient(goldcol, blackcol, goldcol) ;
	
	CGRect hexbounds[4] ;
	divideBounds(hexbounds, boundsrect) ;
	
	KCSetFillColor(context, blackcol) ;
	CGContextFillRect(context, boundsrect) ;
	
	KCSetFillColor(context, goldcol) ;
	KCSetStrokeColor(context, goldcol) ;
	
	for(unsigned int i=0 ; i<4 ; i++){
		CGPoint center = CNRectGetCenter(hexbounds[i]) ;
		CGFloat radius = MIN(hexbounds[i].size.width, hexbounds[i].size.height) / 2.0 ;
		struct CNHexagon hexagon = CNMakeHexagon(center, radius) ;
		switch(i){
			case 0: {
				KCDrawHexagon(context, &hexagon) ;
			} break ;
			case 1: {
				KCFillHexagon(context, &hexagon) ;
			} break ;
			case 2: {
				KCFillHexagonWithLineGradiation(context, &gradient, &hexagon, 0, 3) ;
			} break ;
			default: {
				KCFillHexagonWithLineGradiation(context, &gradient, &hexagon, 2, -1) ;
				//KCFillHexagon(context, &hexagon) ;
			} break ;
		}
	}

	CNRelease3PointsLineGradient(&gradient) ;
}

- (BOOL) isEditable
{
	return NO ;
}

- (void) setEditable: (BOOL) flag
{
	(void) flag ;
}

- (void) touchesBegan: (CGPoint) point inBoundsRect: (CGRect) boundsrect
{
	(void) point ; (void) boundsrect ;
}

- (void) touchesMoved: (CGPoint) newpoint inBoundsRect: (CGRect) boundsrect
{
	(void) newpoint ; (void) boundsrect ;
}

- (void) touchesEnded
{
}

- (void) touchesCancelled
{
}

@end

static void
divideBounds(CGRect dst[4], CGRect src)
{
	CGFloat	dx = src.size.width / 4.0 ;
	for(unsigned int i=0 ; i<4 ; i++){
		CGFloat x = src.origin.x + dx * i ;
		CGFloat y = src.origin.y ;
		CGFloat w = dx ;
		CGFloat h = src.size.height ;
		dst[i] = CGRectMake(x, y, w, h) ;
	}
}