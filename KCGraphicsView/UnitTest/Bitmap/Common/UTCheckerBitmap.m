/**
 * @file	UTCheckerBitmap.m
 * @brief	Define functions to allocate checker-bitmap patterns
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "UTCheckerBitmap.h"

enum {
	UTBlackIndex	= 0,
	UTWhiteIndex	= 1
} UTCheckerIndex ;

CNBitmap *
UTAllocateCheckerBitmap(NSUInteger width, NSUInteger height)
{
	CNBitmap * bitmap = [[CNBitmap alloc] initWithWidth: width withHeiht: height] ;
	
	CNColorIndex * indexptr = bitmap.indexTable ;
	NSUInteger x, y ;
	for(y=0 ; y<height ; y++){
		CNColorIndex index = (y % 2 == 0) ? UTWhiteIndex : UTBlackIndex ;
		for(x=0 ; x<width ; x++){
			*indexptr = index ;
			index = (index == UTBlackIndex) ? UTWhiteIndex : UTBlackIndex ;
			indexptr++ ;
		}
	}
	return bitmap ;
}

CNColorIndexTable *
UTAllocateCheckerColorIndexTable(void)
{
	CNColorIndexTable * newtable = [[CNColorIndexTable alloc] initWithCount: 2] ;
	struct CNRGB * rgbptr = newtable.rgbArray ;
	
	CNColorTable * colortable = [CNColorTable defaultColorTable] ;
	rgbptr[UTBlackIndex] = [colortable black] ;
	rgbptr[UTWhiteIndex] = [colortable white] ;
	return newtable ;
}