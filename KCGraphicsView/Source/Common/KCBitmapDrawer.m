/**
 * @file	KCBitmapDrawer.m
 * @brief	Define KCBitmapDrawer class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCBitmapDrawer.h"

#if TARGET_OS_IPHONE
#	define KCRect		CGRect
#else
#	define KCRect		NSRect
#endif

@interface KCBitmapDrawer ()
@property (strong, readwrite) CNBitmap *			bitmap ;
@property (strong, readwrite) CNColorIndexTable *	colorIndexTable ;
@end

@implementation KCBitmapDrawer

@synthesize bitmap, colorIndexTable ;

- (instancetype) initWithBitmap: (CNBitmap *) inbitmap withColorIndexTable: (CNColorIndexTable *) table
{
	if((self = [super init]) != nil){
		self.bitmap = inbitmap ;
		self.colorIndexTable = table ;
	}
	return self ;
}

- (void) drawWithContext: (CGContextRef) context inBoundsRect: (KCRect) boundsrect
{
	NSUInteger	bitmapwidth  = self.bitmap.width ;
	NSUInteger	bitmapheight = self.bitmap.height ;
	CGFloat		boundswidth  = boundsrect.size.width ;
	CGFloat		boundsheight = boundsrect.size.height ;
	
	const CNColorIndex *	indexarray = self.bitmap.indexTable ;
	const struct CNRGB *	rgbarray   = self.colorIndexTable.rgbArray ;
	
	if(bitmapwidth == 0 || bitmapheight == 0){
		assert(false) ;
	}
	
	CGFloat		cellwidth  = boundswidth  / ((CGFloat) bitmapwidth) ;
	CGFloat		cellheight = boundsheight / ((CGFloat) bitmapheight) ;
	CGFloat		x, y ;
	NSUInteger	colindex = 0 ;
	for(y=0 ; y<boundsheight ; y += cellheight){
		CGFloat celly = boundsheight - (y + cellheight) ;
		for(x=0 ; x<boundswidth ; x += cellwidth){
			CGFloat cellx = x ;
			CNColorIndex indexval = indexarray[colindex] ;
			const struct CNRGB * rgb = &(rgbarray[indexval]) ;
			/* set color */
			CGContextSetRGBFillColor(context, rgb->red, rgb->green, rgb->blue, rgb->alpha);
			/* draw cell */
			CGRect cellrect = {
				.origin = {
					.x = cellx,
					.y = celly
				},
				.size = {
					.width  = cellwidth,
					.height = cellheight
				}
			} ;
			CGContextFillRect(context, cellrect) ;
			colindex++ ;
		}
	}
}

@end
