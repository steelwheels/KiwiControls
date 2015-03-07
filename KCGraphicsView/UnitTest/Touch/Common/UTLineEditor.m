/**
 * @file	UTLineEditor.m
 * @brief	Define UTEditor class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "UTLineEditor.h"

@implementation UTLineEditor

- (instancetype) init
{
	if((self = [super init]) != nil){
		pointNum = 0 ;
	}
	return self ;
}

- (void) drawWithContext: (CGContextRef) context atLevel: (NSUInteger) level inBoundsRect: (CGRect) boundsrect
{
	(void) level ; (void) boundsrect ;
	if(pointNum >= 2){
		CGContextAddLines(context, pointArray, pointNum) ;
		CGContextStrokePath(context) ;
	}
}

- (void) touchesBegan: (CGPoint) point inContext: (CGContextRef) context atLevel: (NSUInteger) level inBoundsRect: (CGRect) boundsrect
{
	//printf("touchesBegin: ") ; CNPrintRect(boundsrect) ; putc('\n', stdout) ;
	//printf(" * ") ; CNPrintPoint(point) ; putc('\n', stdout) ;
	(void) context ; (void) level ;
	if(CGRectContainsPoint(boundsrect, point)){
		pointArray[0] = point ;
		pointNum = 1 ;
	} else {
		pointNum = 0 ;
	}
}

- (BOOL) touchesMoved: (CGPoint) newpoint inContext: (CGContextRef) context atLevel: (NSUInteger) level inBoundsRect: (CGRect) boundsrect
{
	//printf("touchesMoved: ") ; CNPrintPoint(newpoint) ; putc('\n', stdout) ;
	(void) context ; (void) level ;
	if(pointNum >= MAX_POINT_NUM){
		return NO ;
	}
	
	BOOL result ;
	if(CGRectContainsPoint(boundsrect, newpoint)){
		pointArray[pointNum++] = newpoint ;
		result = YES ;
	} else {
		result = NO ;
	}
	return result ;
}

- (void) touchesEnded
{
}

- (void) touchesCancelled
{
}

@end
