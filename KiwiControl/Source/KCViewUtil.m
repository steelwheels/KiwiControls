/**
 * @file	KCViewUtil.m
 * @brief	Utility functions for UIView operation
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCViewUtil.h"

#if TARGET_OS_IPHONE
#	define	KCView			UIView
#else
#	define	KCView			NSView
#endif

CGPoint
KCCenterPointInViewBounds(KCView * view)
{
	CGRect	bounds = view.bounds ;
	CGPoint	result = bounds.origin ;
	result.x += bounds.size.width / 2.0 ;
	result.y += bounds.size.height / 2.0 ;
	return result ;
}

CGPoint
KCAbsolutePointAtView(KCView * view, CGPoint centerpoint)
{
	CGPoint	result = centerpoint ;
	for( ; view ; view = view.superview){
		CGPoint bounds = view.bounds.origin ;
		result.x += bounds.x ;
		result.y += bounds.y ;
		CGPoint frame = view.frame.origin ;
		result.x += frame.x ;
		result.y += frame.y ;
	}
	return result ;
}

void
KCLayoutSubviewWithMargines(KCView * parentview, KCView * subview,
			    CGFloat topmargin, CGFloat bottommargin,
			    CGFloat leftmargin, CGFloat rightmargin)
{
	NSMutableArray * constraints = [[NSMutableArray alloc] initWithCapacity: 4];
	
	/* Top */
	[constraints addObject:[NSLayoutConstraint constraintWithItem: subview
							    attribute: NSLayoutAttributeTop
							    relatedBy: NSLayoutRelationEqual
							       toItem: parentview
							    attribute: NSLayoutAttributeTop
							   multiplier: 1.0
							     constant: topmargin]];
	/* Bottom */
	[constraints addObject:[NSLayoutConstraint constraintWithItem: subview
							    attribute: NSLayoutAttributeBottom
							    relatedBy: NSLayoutRelationEqual
							       toItem: parentview
							    attribute: NSLayoutAttributeBottom
							   multiplier: 1.0
							     constant: bottommargin]];
	
	/* Left */
	[constraints addObject:[NSLayoutConstraint constraintWithItem: subview
							    attribute: NSLayoutAttributeLeft
							    relatedBy: NSLayoutRelationEqual
							       toItem: parentview
							    attribute: NSLayoutAttributeLeft
							   multiplier: 1.0
							     constant: leftmargin]];
	
	/* Right */
	[constraints addObject:[NSLayoutConstraint constraintWithItem: subview
							    attribute: NSLayoutAttributeRight
							    relatedBy: NSLayoutRelationEqual
							       toItem: parentview
							    attribute: NSLayoutAttributeRight
							   multiplier: 1.0
							     constant: rightmargin]];
	
	[parentview addConstraints: constraints];
}