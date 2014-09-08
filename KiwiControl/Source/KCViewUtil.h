/**
 * @file	KCViewUtil.h
 * @brief	Utility functions for UIView operation
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>

static inline CGRect
KSExpandRectByInsets(CGRect rect, UIEdgeInsets insets )
{
	CGFloat	x = rect.origin.x - insets.left ;
	CGFloat y = rect.origin.y - insets.top ;
	CGFloat w = rect.size.width + insets.left + insets.right ;
	CGFloat h = rect.size.height + insets.top + insets.bottom ;
	return CGRectMake(x, y, w, h) ;
}

