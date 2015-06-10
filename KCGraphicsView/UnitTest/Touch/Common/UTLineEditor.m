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

- (BOOL) isEditable
{
	return YES ;
}

- (void) setEditable: (BOOL) flag
{
	(void) flag ;
}

- (void) drawWithContext: (CGContextRef) context inBoundsRect: (CGRect) boundsrect
{
	(void) boundsrect ;
	if(pointNum >= 2){
		CGContextAddLines(context, pointArray, pointNum) ;
		CGContextStrokePath(context) ;
	}
}

- (void) touchesBegan: (CGPoint) point inBoundsRect: (CGRect) boundsrect
{
	//printf("touchesBegin: ") ; CNPrintRect(boundsrect) ; putc('\n', stdout) ;
	//printf(" * ") ; CNPrintPoint(point) ; putc('\n', stdout) ;
	if(CGRectContainsPoint(boundsrect, point)){
		pointArray[0] = point ;
		pointNum = 1 ;
	} else {
		pointNum = 0 ;
	}
}

- (void) touchesMoved: (CGPoint) newpoint inBoundsRect: (CGRect) boundsrect
{
	//printf("touchesMoved: ") ; CNPrintPoint(newpoint) ; putc('\n', stdout) ;
	if(pointNum >= MAX_POINT_NUM){
		return ;
	}
	
	BOOL result ;
	if(CGRectContainsPoint(boundsrect, newpoint)){
		pointArray[pointNum++] = newpoint ;
		result = true ;
	} else {
		result = false ;
	}
}

- (void *) touchesEnded
{
	return NULL ;
}

- (void) touchesCancelled
{
}

@end
