/**
 * @file	KCViewUtil.m
 * @brief	Utility functions for UIView operation
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCViewUtil.h"

CGPoint
KSCenterPointInViewBounds(UIView * view)
{
	CGRect	bounds = view.bounds ;
	CGPoint	result = bounds.origin ;
	result.x += bounds.size.width / 2.0 ;
	result.y += bounds.size.height / 2.0 ;
	return result ;
}

CGPoint
KSAbsolutePointAtView(UIView * view, CGPoint centerpoint)
{
	CGPoint	result = centerpoint ;
	for( ; view ; view = view.superview){
		CGRect frame = view.frame ;
		result.x += frame.origin.x ;
		result.y += frame.origin.y ;
	}
	return result ;
}