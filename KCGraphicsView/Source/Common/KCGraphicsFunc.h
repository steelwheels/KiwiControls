/**
 * @file	KCGraphicsFunc.h
 * @brief	Define functions for graphics
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KCGraphicsType.h"
#import <CoconutGraphics/CoconutGraphics.h>

static inline void
KCSetFillColor(CGContextRef context, const struct CNRGB * color)
{
	CGContextSetRGBFillColor(context, color->red, color->green, color->blue, color->alpha) ;
}

static inline void
KCSetStrokeColor(CGContextRef context, const struct CNRGB * color)
{
	CGContextSetRGBStrokeColor(context, color->red, color->green, color->blue, color->alpha) ;
}
