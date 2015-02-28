/**
 * @file	KCCircleGraphics.h
 * @brief	Define function to draw circle
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KCGraphicsType.h"

static inline CGRect
KCBoundsOfCircle(const struct CNCircle * src)
{
	CGFloat radius  = src->radius ;
	CGFloat radius2 = radius * 2.0 ;
	CGRect result = {
		.origin = {
			.x = (src->center).x - radius,
			.y = (src->center).y - radius
		},
		.size = {
			.width  = radius2,
			.height = radius2
		}
	} ;
	return result ;
}

